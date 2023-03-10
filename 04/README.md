# Логический уровень PostgreSQL

1. Создаем кластер БД, БД `testdb`, схему, роль и пользователя:

```shell
docker run -d --name pg14-test -e POSTGRES_PASSWORD=postgres -p5432:5432 postgres:14
```
```shell
psql -U postgres -h 127.0.0.1 -p 5432
```
```postgresql
create database testdb;
\c testdb
create schema testnm;
create table (c1 int);
insert into t1 values(1);

create role readonly;
grant connect on database testdb to readonly;
grant usage on schema testnm to readonly;
grant select on all tables in schema testnm to readonly;

create user testread with password 'test123';
grant readonly to testread;
```

Входим по новым пользователем testread:

```shell
psql -U testread -h 127.0.0.1 -p 5432 -d testdb
```
```postgresql
testdb=> select * from t1;
ERROR:  permission denied for table t1
testdb=>
```
Данная ошибка закономерна, так как при создании таблицы `t1` не указали на схему. Поэтому таблица была создана в схеме `public`

```postgresql
         Список отношений
 Схема  | Имя |   Тип   | Владелец
--------+-----+---------+----------
 public | t1  | таблица | postgres
```
А права пользователю `testread` мы выдали на схему `testnm`. Во избежание данной ошибки доступа необходимо или явно указывать схему или заменить `search_path`, выставив нашу схему первой в списке поиска

```postgresql
testdb=# set search_path = testnm, public;
SET

    или указать по-умолчанию для БД

testdb=# alter database testdb set search_path = testnm, public;
ALTER DATABASE
```

2. Пересоздаем таблицу `t1`:

```postgresql
drop table t1;
create table testnm.t1(c1 int);
insert into testnm.t1 values(1);

\c testdb testread
testdb=> select * from testnm.t1;
ERROR:  permission denied for table t1
```
PS: пришось смотреть в шпаргалку и пересоздавать полномочия для `testread`

```postgresql
testdb=# alter default privileges in schema testnm grant select on tables TO readonly ;
ALTER DEFAULT PRIVILEGES

testdb=> select * from testnm.t1;
 c1
----
  1
(1 строка)
```

3. Создание таблицы от имени `testread`:

```postgresql
testdb=> create table t2(c1 int);insert into t2 values(2);
CREATE TABLE
INSERT 0 1
testdb=> \dt
         Список отношений
 Схема  | Имя |   Тип   | Владелец
--------+-----+---------+----------
 public | t2  | таблица | testread
(1 строка)
```

Таблица создалась и данные добавились, потому что мы создалии ее в схеме `public`, так как не указали схему `testnm`. По умолчанию все могут создавать и удалять объекты в схеме `public`.

Чтобы у всех пользователей не было прав на создание объектов (как и на просмотр, удаление и изменение) в `public` надо снять соответствующие привелегии роли `public` со схемы:

```postgresql
testdb=# revoke create on schema public from public ;

testdb=> create table t3(c1 int);insert into t3 values(2);
ERROR:  permission denied for schema public
СТРОКА 1: create table t3(c1 int);
                       ^
ERROR:  relation "t3" does not exist
СТРОКА 1: insert into t3 values(2);
```

PS: (из шпаргалки) - для удаления существующих привелегий с баз данных или других схем для роли `public`:
```postgresql
revoke CREATE on SCHEMA <schemaname> FROM public;
revoke all on DATABASE testdb FROM public;
```
