# Секционирование таблицы

## Создание таблиц и наполнение данными
Создадим секционированную таблицу `ticket_flights_part` на базе `ticket_flights`, включая ограничения и значения по-умолчанию.

```sql
DROP TABLE IF EXISTS ticket_flights_part;
CREATE TABLE TICKET_FLIGHTS_part (LIKE ticket_flights INCLUDING DEFAULTS INCLUDING constraints) PARTITION BY LIST(fare_conditions);
```

Усложним задачу и создадим 3 секционированные таблицы по полю `fare_conditions` с разбивкой на 2 секционированные под-таблицы по полю `amount` с условием 0 < `amount` < 50000 и 50000 < `amount` < MAX (максимально возможного по данному полю).

```sql
-- partition table by Economy
CREATE TABLE FLIGHTS_part_economy PARTITION OF ticket_flights_part FOR VALUES in ('Economy') PARTITION BY RANGE(amount);
-- partition sub-tables by amount
CREATE TABLE FLIGHTS_part_economy_lowcost PARTITION OF FLIGHTS_part_economy FOR VALUES FROM (0) TO (50000);
CREATE TABLE FLIGHTS_part_economy_highcost PARTITION OF FLIGHTS_part_economy FOR VALUES FROM (50000) TO (((10^10)-1)/(10^2));

-- partition table by Business
CREATE TABLE FLIGHTS_part_business PARTITION OF ticket_flights_part FOR VALUES in ('Business') PARTITION BY RANGE(amount);
-- partition sub-tables by amount
CREATE TABLE FLIGHTS_part_business_lowcost PARTITION OF FLIGHTS_part_business FOR VALUES FROM (0) TO (50000);
CREATE TABLE FLIGHTS_part_business_highcost PARTITION OF FLIGHTS_part_business FOR VALUES FROM (50000) TO (((10^10)-1)/(10^2));

-- partition table by Comfort
CREATE TABLE FLIGHTS_part_comfort PARTITION OF ticket_flights_part FOR VALUES in ('Comfort') PARTITION BY RANGE(amount);
-- partition sub-tables by amount
CREATE TABLE FLIGHTS_part_comfort_lowcost PARTITION OF FLIGHTS_part_comfort FOR VALUES FROM (0) TO (50000);
CREATE TABLE FLIGHTS_part_comfort_highcost PARTITION OF FLIGHTS_part_comfort FOR VALUES FROM (50000) TO (((10^10)-1)/(10^2));
```
Загрузим таблицу данными из `TICKET_FLIGHTS`
```postgresql
INSERT INTO TICKET_FLIGHTS_PART SELECT * FROM TICKET_FLIGHTS;
INSERT 0 8391852
```
Проверим количество строк в исходной и в конечной таблицах - оно не должно расходиться, если заданы правильные условия разделения.
```postgresql
ANALYZE;
WITH 
pc1 AS (SELECT count(*) c FROM TICKET_FLIGHTS),
pc2 AS (SELECT count(*) c FROM TICKET_FLIGHTS_PART)
SELECT p1.c AS ticket_flights, p2.c AS ticket_flights_part
FROM pc1 p1, pc2 p2;
  ticket_flights | ticket_flights_part
----------------+---------------------
        8391852 |             8391852
(1 row)
```

## Выборка данных 
Проверим выборку из секционированной таблицы через `explain` на предмет обращения к таблицам и за одним сравним условное время выборки на простой и секционированных таблицах
### Все данные
```postgresql 
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS;
                                QUERY PLAN
--------------------------------------------------------------------------
 Seq Scan on ticket_flights  (cost=0.00..153852.60 rows=8391960 width=32)
(1 row)
```

```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS_PART;
                                                     QUERY PLAN
--------------------------------------------------------------------------------------------------------------------
 Append  (cost=0.00..195814.44 rows=8391963 width=32)
   ->  Seq Scan on flights_part_business_lowcost ticket_flights_part_1  (cost=0.00..11146.96 rows=607996 width=33)
   ->  Seq Scan on flights_part_business_highcost ticket_flights_part_2  (cost=0.00..4614.60 rows=251660 width=33)
   ->  Seq Scan on flights_part_comfort_lowcost ticket_flights_part_3  (cost=0.00..2566.65 rows=139965 width=33)
   ->  Seq Scan on flights_part_comfort_highcost ticket_flights_part_4  (cost=0.00..0.00 rows=1 width=114)
   ->  Seq Scan on flights_part_economy_lowcost ticket_flights_part_5  (cost=0.00..129298.40 rows=7052640 width=32)
   ->  Seq Scan on flights_part_economy_highcost ticket_flights_part_6  (cost=0.00..6228.01 rows=339701 width=33)
(7 rows)
```
В первом случае сервер обошел только одну таблицу, во втором все секционированные под-таблицы.
Условное время **153852.60** простой таблицы против **195814.44** секционированной. Накладные расходы обхода 6-ти таблиц вместо 1-й.

### Фильтр по `amount`
```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS TF WHERE tf.AMOUNT > 50000;
                                        QUERY PLAN
------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..155354.38 rows=581965 width=32)
   Workers Planned: 4
   ->  Parallel Seq Scan on ticket_flights tf  (cost=0.00..96157.88 rows=145491 width=32)
         Filter: (amount > '50000'::numeric)
 JIT:
   Functions: 2
   Options: Inlining false, Optimization false, Expressions true, Deforming true
(7 rows)
```

```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS_PART TF WHERE tf.AMOUNT > 50000;
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Append  (cost=0.00..15237.60 rows=583317 width=33)
   ->  Seq Scan on flights_part_business_highcost tf_1  (cost=0.00..5243.75 rows=243615 width=33)
         Filter: (amount > '50000'::numeric)
   ->  Seq Scan on flights_part_comfort_highcost tf_2  (cost=0.00..0.00 rows=1 width=114)
         Filter: (amount > '50000'::numeric)
   ->  Seq Scan on flights_part_economy_highcost tf_3  (cost=0.00..7077.26 rows=339701 width=33)
         Filter: (amount > '50000'::numeric)
(7 rows)
```
В первом случае сервер применил фильтр и обошел всю таблицу, во втором секционированные под-таблицы по условию `fare_condition` и только секционированные таблицы по условияю `amount`.
Условное время **155354.38** простой таблицы против **15237.60** секционированной. Теперь сказываются накладные расходы обхода всей таблицы (простой), вместо 3-х из 6 секционированных. Время отбхода по 3-м секционированным таблице почти в 10 раз меньше, чем по всей простой.

### Фильтр по `fare_conditions`
```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS TF WHERE tf.fare_conditions = 'Economy';
                                   QUERY PLAN
---------------------------------------------------------------------------------
 Seq Scan on ticket_flights tf  (cost=0.00..174832.50 rows=7414856 width=32)
   Filter: ((fare_conditions)::text = 'Economy'::text)
 JIT:
   Functions: 2
   Options: Inlining false, Optimization false, Expressions true, Deforming true
(5 rows)
```

```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS_PART TF WHERE tf.fare_conditions = 'Economy';
                                            QUERY PLAN
---------------------------------------------------------------------------------------------------
 Append  (cost=0.00..190968.97 rows=7392341 width=32)
   ->  Seq Scan on flights_part_economy_lowcost tf_1  (cost=0.00..146930.00 rows=7052640 width=32)
         Filter: ((fare_conditions)::text = 'Economy'::text)
   ->  Seq Scan on flights_part_economy_highcost tf_2  (cost=0.00..7077.26 rows=339701 width=33)
         Filter: ((fare_conditions)::text = 'Economy'::text)
 JIT:
   Functions: 4
   Options: Inlining false, Optimization false, Expressions true, Deforming true
(8 rows)
```
В первом случае сервер применил фильтр и обошел всю таблицу, во втором только 2 секционированные под-таблицы по условию `fare_condition`.
Условное время **174832.50** простой таблицы против **190968.97** секционированной. Время отбхода и фильтрации увеличилось в обоих случаях, в случае секционированной таблицы даже больше. Сказывается фильтр по не проиндексированному текстовому полю.

### Фильтр по `amount` and `fare_conditions`
```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS TF WHERE tf.AMOUNT > 50000 AND tf.fare_conditions = 'Economy';
                                          QUERY PLAN
-----------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..153823.35 rows=514205 width=32)
   Workers Planned: 4
   ->  Parallel Seq Scan on ticket_flights tf  (cost=0.00..101402.85 rows=128551 width=32)
         Filter: ((amount > '50000'::numeric) AND ((fare_conditions)::text = 'Economy'::text))
 JIT:
   Functions: 2
   Options: Inlining false, Optimization false, Expressions true, Deforming true
(7 rows)
```

```postgresql
demo=> EXPLAIN SELECT * FROM TICKET_FLIGHTS_PART TF WHERE tf.AMOUNT > 50000 AND tf.fare_conditions = 'Economy';
                                       QUERY PLAN
-----------------------------------------------------------------------------------------
 Seq Scan on flights_part_economy_highcost tf  (cost=0.00..7926.51 rows=339701 width=33)
   Filter: ((amount > '50000'::numeric) AND ((fare_conditions)::text = 'Economy'::text))
(2 rows)
```
В первом случае сервер применил фильтр и также обошел всю таблицу, а во втором только одну секционированную под-таблицу по условию `fare_condition` и `amount`.
Условное время **153823.35** простой таблицы против **7926.51** секционированной. Время отбхода по одной секционированной таблице в разы меньше, чем по всей простой.

---
Секционирование очень полезно при наличии большого объема данных, работа с которыми происходит только по какой-то части. Можно вынести архивные данные по временному периоду (даже на отдельный носитель) или разделить работу нескольких подразделений с одной БД для уменьшения нагрузки сервера по обработке данных.

---
