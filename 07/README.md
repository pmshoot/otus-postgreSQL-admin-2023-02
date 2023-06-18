# Механизм блокировок

## 1. Настроим сервер на ведение журнала блокировок и выставим таймаут ожидания блокировки:

```sql
ALTER SYSTEM SET log_lock_waits = on;
alter system set deadlock_timeout TO 200;
select pg_reload_conf();
```
```
postgres=# show deadlock_timeout;
 deadlock_timeout
------------------
 200ms
```

В 1-м терминале запустим транзакцию на обновление данных:

```
postgres=# begin;
BEGIN
postgres=*# update test set txt='asdf+++' where id = 1;
UPDATE 2
```

Во 2-ом терминале запустим удаление строк из той же таблицы в другой транзакци:
```
| postgres=# begin;
| BEGIN
| postgres=*# delete from test where id=1;
```
Вторая транзакция заблокировалась в ожидании завершения 1-ой транзакции.
Проверим журнал:
```
2023-05-10 15:11:59.644 UTC [78] LOG:  process 78 still waiting for ShareLock on transaction 737 after 200.312 ms
2023-05-10 15:11:59.644 UTC [78] DETAIL:  Process holding the lock: 136. Wait queue: 78.
2023-05-10 15:11:59.644 UTC [78] CONTEXT:  while deleting tuple (0,1) in relation "test"
2023-05-10 15:11:59.644 UTC [78] STATEMENT:  delete from test where id=1;
```
Сервер выдал сообщение о превышении времени ожидания блокировки, установленной в параметрах.
Закроем транзакции:
```
postgres=*# commit;
COMMIT
```
```
| DELETE 1
| postgres=*# commit;
| COMMIT
```

## 2. Моделирование ситуации обновления одних и тех же строк из 3-х соединений:

Созданим тестовые данные

```sql
create table test (id int primary key, txt varchar(64));
insert into test values
(1, 'first text'),
(2, 'second text'),
(3, 'next text'),
(4, 'interset'),
(5, 'amazing text');
```

В трех терминалах запустим по транзакции и одну и ту же команду на обновление данных

1. pid 194
```sql
postgres=# begin;
BEGIN
postgres=*# update test set txt = 'changed 1' where id in (1,3,5);
UPDATE 3
```
2. pid 196

```sql
postgres=# begin;
BEGIN
postgres=*# update test set txt = 'changed 1' where id in (1,3,5);
```
3. pid 199
```sql
postgres=# begin;
BEGIN
postgres=*# update test set txt = 'changed 1' where id in (1,3,5);
```

2-я и 3-я консоль встали в режим ожидания.

Данные по блокировкам в `pg_locks`:
```
# |locktype     |relation |mode            |granted|pid   |wait_for|
--+-------------+---------+----------------+-------+------+--------+
1 |virtualxid   |[NULL]   |ExclusiveLock   |true   |   194|{}      |
2 |relation     |test     |RowExclusiveLock|true   |   194|{}      |
3 |relation     |test_pkey|RowExclusiveLock|true   |   194|{}      |
4 |transactionid|[NULL]   |ExclusiveLock   |true   |   194|{}      |
5 |relation     |test_pkey|RowExclusiveLock|true   |   196|{194}   |
6 |relation     |test     |RowExclusiveLock|true   |   196|{194}   |
7 |virtualxid   |[NULL]   |ExclusiveLock   |true   |   196|{194}   |
8 |tuple        |test     |ExclusiveLock   |true   |   196|{194}   |
9 |transactionid|[NULL]   |ExclusiveLock   |true   |   196|{194}   |
10|transactionid|[NULL]   |ShareLock       |false  |   196|{194}   |
11|transactionid|[NULL]   |ExclusiveLock   |true   |   199|{196}   |
12|relation     |test_pkey|RowExclusiveLock|true   |   199|{196}   |
13|tuple        |test     |ExclusiveLock   |false  |   199|{196}   |
14|relation     |test     |RowExclusiveLock|true   |   199|{196}   |
15|virtualxid   |[NULL]   |ExclusiveLock   |true   |   199|{196}   |
```

- 1-я транзакция удерживает блокировку `RowExclusiveLock` таблицы `test` и индекса (#2-#3) и собственную блокировку (#4)
- 2-я транзакция захватила блокировку на новую версию строки (#8) и пытается заблокировать таблицу в режиме `ShareLock` для записи, но `ShareLock` конфликтует с `RowExclusiveLock` и не может быть выполнен пока не снимется `RowExclusiveLock`. А 1-я транзакция удерживает исключительную блокировку, которую одновременно может удерживать только одна транзакция.
- 3-я транзакция замерла на этапе попытки захвата заблокировки версии строки (#13).

## 3. Взаимоблокировка трех транзакций


Создадим таблицу managers с тремя записями

```postgresql
sales=> create table managers (id int, name varchar, count int);
CREATE TABLE
sales=> insert into managers values
sales-> (1, 'Andrey', 1000),
sales-> (2, 'Maria', 2000),
sales-> (3, 'Slava', 2000);
INSERT 0 3
sales=> select * from managers;
 id |  name  | count
----+--------+-------
  1 | Andrey |  1000
  2 | Maria  |  2000
  3 | Slava  |  2000
(3 строки)
```

### Шаг 1 - первая транзакция

В териминал 1 запустим транзакцию и измененим данные строки с id=1 не завершая транзакции:
```postgresql
sales=# begin;
BEGIN
sales=*# update managers set count = count + 100 where id=1;
UPDATE 1
sales=*# update managers set count = count + 200 where id=2;
```

В териминал 2 запустим транзакцию и измененим данные строки с id=2 не завершая транзакции:
```postgresql
sales=# begin;
BEGIN
sales=*# update managers set count = count + 200 where id=2;
UPDATE 1
sales=*#
```

В териминал 3 запустим транзакцию и измененим данные строки с id=3 не завершая транзакции:
```postgresql
sales=# begin;
BEGIN
sales=*# update managers set count = count + 300 where id=3;
UPDATE 1
sales=*
```

### Шаг 2 - первая транзакция

В териминал 1 измененим данные строки с id=2 не завершая транзакции:
```postgresql
sales=*# update managers set count = count + 200 where id=2;
```
Вывода сервера об обновлении строки, не последовало, т.к. строка заблокирована транзакцией в терминале 2


В териминал 2 измененим данные строки с id=3 не завершая транзакции:
```postgresql
sales=*# update managers set count = count + 300 where id=3;
```
Вывода сервера об обновлении строки, не последовало, т.к. строка заблокирована транзакцией в терминале 3


В териминал 3 измененим данные строки с id=1 не завершая транзакции:
```postgresql
sales=*# update managers set count = count + 100 where id=1;

ОШИБКА:  обнаружена взаимоблокировка
ПОДРОБНОСТИ:  Процесс 103471 ожидает в режиме ShareLock блокировку "транзакция 5584"; заблокирован процессом 103452.
Процесс 103452 ожидает в режиме ShareLock блокировку "транзакция 5585"; заблокирован процессом 103451.
Процесс 103451 ожидает в режиме ShareLock блокировку "транзакция 5586"; заблокирован процессом 103471.
ПОДСКАЗКА:  Подробности запроса смотрите в протоколе сервера.
КОНТЕКСТ:  при изменении кортежа (0,4) в отношении "managers"

```
Вывода сервера сообщит о взаимной блокировке (deadlock)

Log сервера:
```
2023-06-18 15:11:17.172 +05 [103471] postgres@sales ОШИБКА:  обнаружена взаимоблокировка
2023-06-18 15:11:17.172 +05 [103471] postgres@sales ПОДРОБНОСТИ:  Процесс 103471 ожидает в режиме ShareLock блокировку "транзакция 5584"; заблокирован процессом 103452.
	Процесс 103452 ожидает в режиме ShareLock блокировку "транзакция 5585"; заблокирован процессом 103451.
	Процесс 103451 ожидает в режиме ShareLock блокировку "транзакция 5586"; заблокирован процессом 103471.
	Процесс 103471: update managers set count = count + 100 where id=1;
	Процесс 103452: update managers set count = count + 200 where id=2;
	Процесс 103451: update managers set count = count + 300 where id=3;
2023-06-18 15:11:17.172 +05 [103471] postgres@sales ПОДСКАЗКА:  Подробности запроса смотрите в протоколе сервера.
2023-06-18 15:11:17.172 +05 [103471] postgres@sales КОНТЕКСТ:  при изменении кортежа (0,4) в отношении "managers"
2023-06-18 15:11:17.172 +05 [103471] postgres@sales ОПЕРАТОР:  update managers set count = count + 100 where id=1;
```

В ситуации можно разобраться постфактум, изучив лог-файл сервера. Как вариант, можно поставить триггер ма мониторинге, который будет читать лог, выявлять подобные случаи и уведомлять администраторов.

## 4. Могут ли две транзакции, выполняющие единственную команду UPDATE одной и той же таблицы (без where), заблокировать друг друга?

Взаимоблокировка двух транзакций, выполняющих UPDATE одной и той же таблицы (без where) возможна, если одна транзакция будет обновлять строки таблицы, отсортированной по возрастанию, а другая по убыванию.

Данную ситуацию можно воспроизвести с помощью курсоров:

В первой консоли запустим транзакцию и создадим курсор на выборку из таблицы `managers` для обновления:
```postgresql
sales=# begin;
BEGIN
sales=*# declare cursor_1 cursor for select id,name,count from managers order by id for update;
DECLARE CURSOR
sales=*#
```

Во второй консоли повторим действия первой и создадим второй курсор, но с сортировкой по убыванию:
```postgresql
sales=# begin;
BEGIN
sales=*# declare cursor_2 cursor for select id,name,count from managers order by id desc for update;
DECLARE CURSOR
sales=*#
```

Затем по-очередно в каждой консоли будем вызывать команду получения данных очередной строки - `fetch`.

Консоль 1:

```postgresql
sales=*# fetch cursor_1;
 id |  name  | count
----+--------+-------
  1 | Andrey |   200
(1 строка)
```

Консоль 2:

```postgresql
sales=*# fetch cursor_2;
 id | name  | count
----+-------+-------
  3 | Slava |   200
(1 строка)
```

И так до тех пор, пока не дойдет до id=2 (середины), где курсоры пересекутся, при этом курсор консоли 1 получит данные, курсор второй консоли подвиснет в ожидании разблокировки:

```
sales=*# fetch cursor_1;
 id | name  | count
----+-------+-------
  2 | Maria |   200
(1 строка)
```

```
sales=*# fetch cursor_2;

```

При сдедующей попытке получить данные курсора в первой консоли, сервер выдаст ошибку взаимной блокировки:
```
ОШИБКА:  обнаружена взаимоблокировка
ПОДРОБНОСТИ:  Процесс 103452 ожидает в режиме ShareLock блокировку "транзакция 5594"; заблокирован процессом 106081.
Процесс 106081 ожидает в режиме ShareLock блокировку "транзакция 5593"; заблокирован процессом 103452.
ПОДСКАЗКА:  Подробности запроса смотрите в протоколе сервера.
КОНТЕКСТ:  при блокировке кортежа (0,14) в отношении "managers"
```
