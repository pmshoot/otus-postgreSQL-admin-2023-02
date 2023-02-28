# Установка и настройка PostgreSQL

Цель:
- создавать дополнительный диск для уже существующей виртуальной машины, размечать его и делать на нем файловую систему
- переносить содержимое базы данных PostgreSQL на дополнительный диск
- переносить содержимое БД PostgreSQL между виртуальными машинами

1. Установка postgresql на ВМ `vminst01`, проверка:

```
root@vminst01:/home/osboxes# pg_lsclusters 
Ver Cluster Port Status Owner    Data directory              Log file
12  main    5432 online postgres /var/lib/postgresql/12/main /var/log/postgresql/postgresql-12-main.log
```

2. Создадим таблицу и заполним данными:

```shell
root@vminst01:/home/osboxes# sudo -u postgres psql -c "create table data (d int); insert into data select generate_series(1,100);"
INSERT 0 100
```

3. Остановка кластера:

```shell
root@vminst01:/home/osboxes# pg_ctlcluster stop 12 main
root@vminst01:/home/osboxes# pg_lsclusters 
Ver Cluster Port Status Owner    Data directory              Log file
12  main    5432 down   postgres /var/lib/postgresql/12/main /var/log/postgresql/postgresql-12-main.log
```

4. На дополнительном диске `/dev/sdb1` создадим папку pgdata, установим пользователя postgres владельцем и перенесем 
   каталог с данными postgres'a:

```shell
sda      8:0    0   500G  0 disk 
├─sda1   8:1    0     1M  0 part 
├─sda2   8:2    0   236G  0 part /
├─sda3   8:3    0   300M  0 part /boot
├─sda4   8:4    0   9.5G  0 part [SWAP]
└─sda5   8:5    0 254.2G  0 part /home
sdb      8:16   0     5G  0 disk 
└─sdb1   8:17   0     5G  0 part /mnt/data

---
root@vminst01:/home/osboxes# mkdir -p /mnt/data/pgdata
root@vminst01:/home/osboxes# chown -R postgres: /mnt/data/pgdata/
root@vminst01:/home/osboxes# ls -l /mnt/data/
total 20
drwx------ 2 root     root     16384 Feb 28 14:22 lost+found
drwxr-xr-x 2 postgres postgres  4096 Feb 28 14:32 pgdata

root@vminst01:/home/osboxes# mv /var/lib/postgresql/12 /mnt/data/pgdata/
root@vminst01:/home/osboxes# ls -l /var/lib/postgresql/12
ls: cannot access '/var/lib/postgresql/12': No such file or directory
root@vminst01:/home/osboxes# ls -l /mnt/data/pgdata/12/main/
total 84
drwx------ 5 postgres postgres 4096 Feb 28 12:26 base
drwx------ 2 postgres postgres 4096 Feb 28 14:21 global
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_commit_ts
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_dynshmem
drwx------ 4 postgres postgres 4096 Feb 28 14:25 pg_logical
drwx------ 4 postgres postgres 4096 Feb 28 12:26 pg_multixact
drwx------ 2 postgres postgres 4096 Feb 28 14:20 pg_notify
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_replslot
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_serial
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_snapshots
drwx------ 2 postgres postgres 4096 Feb 28 14:20 pg_stat
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_stat_tmp
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_subtrans
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_tblspc
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_twophase
-rw------- 1 postgres postgres    3 Feb 28 12:26 PG_VERSION
drwx------ 3 postgres postgres 4096 Feb 28 12:26 pg_wal
drwx------ 2 postgres postgres 4096 Feb 28 12:26 pg_xact
-rw------- 1 postgres postgres   88 Feb 28 12:26 postgresql.auto.conf
-rw------- 1 postgres postgres  130 Feb 28 14:20 postmaster.opts
-rw------- 1 postgres postgres  107 Feb 28 14:20 postmaster.pid
root@vminst01:/home/osboxes# 
```

5. Старт сервера после переноса каталога с данными вызовет ошибку:

```shell
root@vminst01:/home/osboxes# pg_ctlcluster start 12 main
Error: /var/lib/postgresql/12/main is not accessible or does not exist
```

..потому что мы не внесли изменения об изменении местоположения каталога в файл настроек:

```shell
root@vminst01:/home/osboxes# grep data_directory  /etc/postgresql/12/main/postgresql.conf
data_directory = '/var/lib/postgresql/12/main'		# use data in another directory
```

заменим путь к каталогу и запустим кластер БД:

```shell
root@vminst01:/home/osboxes# echo data_directory = \'/mnt/data/pgdata/12/main/\' >> /etc/postgresql/12/main/postgresql.conf 
root@vminst01:/home/osboxes# grep data_directory  /etc/postgresql/12/main/postgresql.conf
data_directory = '/var/lib/postgresql/12/main'		# use data in another directory
data_directory = '/mnt/data/pgdata/12/main/'

root@vminst01:/home/osboxes# pg_ctlcluster start 12 main
root@vminst01:/home/osboxes# pg_lsclusters 
Ver Cluster Port Status Owner    Data directory            Log file
12  main    5432 online postgres /mnt/data/pgdata/12/main/ /var/log/postgresql/postgresql-12-main.log
root@vminst01:/home/osboxes# 
```

Кластер запущен. Проверим наличие созданной таблицы с данными:

```shell
root@vminst01:/home/osboxes# sudo -u postgres psql -c "select * from data limit 5;"
 d 
---
 1
 2
 3
 4
 5
(5 rows)
```

6. Перенос данных на другую ВМ. Для переноса данных подключим доп.диск из `vminst01` с каталогом БД к 
   другому серверу, запущенному на другой ВМ. Для этого проделаем аналогичные шаги:

   - остановим первую ВМ - `vminst01`
   - создадим новый инстанс ВМ - `vminst02`
   - в настройках ВМ `vminst02` добавим существующий доп.диск
   - запустим `vminst02`
   - добавим в `/etc/fstab` ВМ `vminst02` доп.диск для автомонтирования при загрузке
   - примонтируем доп.диск
   - установим postgresql
   - в настройках postgres'a заменим путь к каталогу данных на каталог на доп.диске
   - перезапустим кластер БД
   - проверим наличие данных

```shell
root@vminst02:/home/osboxes# pg_lsclusters 
Ver Cluster Port Status Owner    Data directory            Log file
12  main    5432 online postgres /mnt/data/pgdata/12/main/ /var/log/postgresql/postgresql-12-main.log
root@vminst02:/home/osboxes# sudo -u postgres psql -c "select * from data limit 5;"
 d 
---
 1
 2
 3
 4
 5
(5 rows)

```