# 6. Работа с журналами

## Настройка выполнения контрольной точки: устанавливаем в 30секунд

```sql
alter system set checkpoint_timeout TO 30;
select pg_reload_conf();
```

## Нагрузка `pgbench`:

Зафиксируем LSN:
```
SELECT pg_current_wal_insert_lsn(), pg_current_wal_lsn();
 pg_current_wal_insert_lsn | pg_current_wal_lsn
---------------------------+--------------------
 0/2F2DF578                | 0/2F2DF578
(1 строка)
```

Сбрасываем статистику `bgwriter`:

```sql
select pg_stat_reset_shared('bgwriter');
```

Запускаем `pgbench`:

```shell
pgbench -c8 -P 60 -T 600 -U postgres -h nas -p 5436 postgres
```

По завершению теста фиксируем статистику `bgwriter` (checkpoints):

```
postgres=# select checkpoints_timed, checkpoints_req from pg_stat_bgwriter;
 checkpoints_timed | checkpoints_req
-------------------+-----------------
                20 |               0
(1 строка)

```

и фиксируем текущий LSN:


```
SELECT pg_current_wal_insert_lsn(), pg_current_wal_lsn();
 pg_current_wal_insert_lsn | pg_current_wal_lsn
---------------------------+--------------------
 0/3E6ADD20                | 0/3E6ADD20
(1 строка)

```

Из полученных данных вычисляем какой объем журнальных файлов был сгенерирован за время теста - 10 минут:

```
postgres=# select '0/3E6ADD20'::pg_lsn - '0/2F2DF578'::pg_lsn;
 ?column?
-----------
 255649704
(1 строка)
```

или

```
postgres=# select pg_wal_lsn_diff('0/3E6ADD20','0/2F2DF578');
 pg_wal_lsn_diff
-----------------
       255649704
(1 строка)

```

За 10 минут было выполнено 20 плановых контрольных точек, и в среднем на одну контрольную точку приходится 12782485 байт (~1.28 Мб). За время выполнения теста контрольных точек по требованию не выполнялось, это говорит о том, что объем данных не успевал достигнуть максимально установленного (1Гб).

## TPS в синхронном и асинхронном режимах

Синхронный режим

```
starting vacuum...end.
progress: 60.0 s, 92.6 tps, lat 85.988 ms stddev 77.356
progress: 120.0 s, 93.6 tps, lat 85.504 ms stddev 58.078
progress: 180.0 s, 95.4 tps, lat 83.898 ms stddev 54.433
progress: 240.0 s, 89.5 tps, lat 89.386 ms stddev 84.600
progress: 300.0 s, 96.0 tps, lat 83.346 ms stddev 57.063
progress: 360.0 s, 94.1 tps, lat 85.014 ms stddev 55.929
progress: 420.0 s, 95.2 tps, lat 84.037 ms stddev 52.453
progress: 480.0 s, 93.4 tps, lat 85.544 ms stddev 55.616
progress: 540.0 s, 91.5 tps, lat 87.619 ms stddev 89.407
progress: 600.0 s, 93.3 tps, lat 85.671 ms stddev 57.358
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 56072
latency average = 85.569 ms
latency stddev = 65.351 ms
initial connection time = 251.151 ms
tps = 93.482650 (without initial connection time)
```

Асинхронный режим:

```
postgres=# alter system set synchronous_commit = off;
ALTER SYSTEM
postgres=# select pg_reload_conf();
 pg_reload_conf
----------------
 t
(1 строка)

postgres=# show synchronous_commit;
 synchronous_commit
--------------------
 off
(1 строка)
```

```
starting vacuum...end.
progress: 60.0 s, 809.2 tps, lat 9.843 ms stddev 4.282
progress: 120.0 s, 849.7 tps, lat 9.414 ms stddev 4.399
progress: 180.0 s, 818.1 tps, lat 9.778 ms stddev 4.488
progress: 240.0 s, 792.9 tps, lat 10.088 ms stddev 4.318
progress: 300.0 s, 858.6 tps, lat 9.316 ms stddev 4.032
progress: 360.0 s, 800.2 tps, lat 9.996 ms stddev 4.497
progress: 420.0 s, 847.7 tps, lat 9.436 ms stddev 4.205
progress: 480.0 s, 822.7 tps, lat 9.723 ms stddev 4.294
progress: 540.0 s, 832.7 tps, lat 9.606 ms stddev 4.226
progress: 600.0 s, 828.6 tps, lat 9.653 ms stddev 4.377
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 495632
latency average = 9.679 ms
latency stddev = 4.319 ms
initial connection time = 249.708 ms
tps = 826.378063 (without initial connection time)

```

При синхронном режиме сервер сбрасывает на диск из буфера накопившиеся грязные записи, а также записи о фиксации, что увеличивает время отклика, но гарантирует долговечность.
При Асинхронном режиме сервер сбрасывает только заполненые страницы через определенный период времени `wal_writer_delay`, что уменьшает время отклика, но не гарантирует долговечность.


## Контрольные суммы

Создадим новый кластер и активируем проверку контрольных сумм:

```
postgres@nas:/home/user$ /usr/lib/postgresql/14/bin/pg_checksums -D /var/lib/postgresql/14/test/ -e
Обработка контрольных сумм завершена
Просканировано файлов: 931
Просканировано блоков: 3222
pg_checksums: синхронизация каталога данных
pg_checksums: модификация управляющего файла
Контрольные суммы в кластере включены
postgres@nas:/home/manager$
```
Создадим таблицу и некоторые данные в ней. Определим ее местонахождение на диске:

```
postgres=# create table test (s text);
CREATE TABLE
postgres=# insert into test values ('some_info');
INSERT 0 1
postgres=# select * from test;
     s
-----------
 some_info
(1 строка)

postgres=# select pg_relation_filepath('test');
 pg_relation_filepath
----------------------
 base/13799/16384
(1 строка)
```

Остановим кластер и изменим пару байт в начале таблицы (файла), затем запустим сервер и сделаем выборку из созданной таблицы:

```
postgres=# select * from test;
ПРЕДУПРЕЖДЕНИЕ:  ошибка проверки страницы: получена контрольная сумма 4096, а ожидалась - 11623
ОШИБКА:  неверная страница в блоке 0 отношения base/13799/16384

```

Сервер выругался на неконсистентность данных. Так как изменения коснулись заголовка таблицы (правили в начале файла), то сами данные не повреждены и можно обойти возмущение сервера и получить данные, но с риском получить искаженные данные:

```
postgres=# alter system set ignore_checksum_failure = on;
ALTER SYSTEM
postgres=# select pg_reload_conf();
 pg_reload_conf
----------------
 t
(1 строка)

postgres=# select * from test;
ПРЕДУПРЕЖДЕНИЕ:  ошибка проверки страницы: получена контрольная сумма 4096, а ожидалась - 11623
     s
-----------
 some_info
(1 строка)
```

Сервер выдал предупреждение, но данные отразил. В случаях повреждения самих данных в таблице, подобный финт не сработает и спасет только наличие резервной копии.

```
postgres=# select * from test;
ПРЕДУПРЕЖДЕНИЕ:  ошибка проверки страницы: получена контрольная сумма 4096, а ожидалась - 11623
ОШИБКА:  compressed pglz data is corrupt

```