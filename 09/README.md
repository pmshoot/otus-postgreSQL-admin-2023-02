# Триггеры, поддержка заполнения витрин

## Вариант 1 
Создадим таблицы

```sql
CREATE TABLE goods
(
    goods_id    integer PRIMARY KEY,
    good_name   varchar(63) NOT NULL,
    good_price  numeric(12, 2) NOT NULL CHECK (good_price > 0.0)
);
INSERT INTO goods (goods_id, good_name, good_price)
VALUES 	(1, 'Спички хозяйственные', .50),
		(2, 'Автомобиль Ferrari FXX K', 185000000.01);

-- Продажи
CREATE TABLE sales
(
    sales_id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    good_id     integer REFERENCES goods (goods_id),
    sales_time  timestamp with time zone DEFAULT now(),
    sales_qty   integer CHECK (sales_qty > 0)
);

DROP TABLE IF EXISTS good_sum_mart;
CREATE TABLE good_sum_mart
(
    goods_id    integer PRIMARY KEY, -- добавлено поле id для ускорения выборки
	good_name   varchar(63) NOT NULL,
	sum_sale	numeric(16, 2)NOT NULL
);

INSERT INTO sales (good_id, sales_qty) VALUES (1, 10), (1, 1), (1, 120), (2, 1);
```
Создадим триггер на вставку, обновление, удаление и триггерную функцию

```sql
-- trigger func
CREATE OR REPLACE FUNCTION PRACT_FUNCTIONS.update_report()
RETURNS trigger
AS
$ur$
DECLARE 
    delta_goods_id      integer;
    delta_good_name     varchar(63);
    delta_good_price    numeric(12, 2);
    delta_sales_qty     integer;
BEGIN
    IF (TG_OP = 'DELETE') THEN 
        delta_good_price = (SELECT good_price FROM PRACT_FUNCTIONS.GOODS WHERE goods_id = NEW.good_id);
        delta_goods_id = OLD.good_id;
        delta_sales_qty = -1 * OLD.sales_qty;
        
    ELSIF (TG_OP = 'INSERT') THEN
        delta_good_price = (SELECT good_price FROM PRACT_FUNCTIONS.GOODS WHERE goods_id = NEW.good_id);
        delta_good_name = (SELECT good_name FROM PRACT_FUNCTIONS.GOODS WHERE goods_id = NEW.good_id);
        delta_goods_id = NEW.good_id;
        delta_sales_qty = NEW.sales_qty;

    ELSIF (TG_OP = 'UPDATE') THEN
        IF ( OLD.good_id != NEW.good_id) THEN
                RAISE EXCEPTION 'Update of goods_id : % -> % not allowed',
                                                      OLD.good_id, NEW.good_id;
        END IF;
        delta_good_price = (SELECT good_price FROM PRACT_FUNCTIONS.GOODS WHERE goods_id = NEW.good_id);
        delta_goods_id = OLD.good_id;
        delta_sales_qty = NEW.sales_qty - OLD.sales_qty;
    
    END IF;

    <<insert_update>>
    LOOP
        UPDATE PRACT_FUNCTIONS.good_sum_mart
            SET sum_sale = COALESCE(sum_sale + delta_sales_qty * delta_good_price, 0)
            WHERE goods_id = delta_goods_id;

        EXIT insert_update WHEN found;

        BEGIN
            INSERT INTO PRACT_FUNCTIONS.good_sum_mart (
                        goods_id,
                        good_name,
                        sum_sale)
                VALUES (
                        delta_goods_id,
                        delta_good_name,
                        delta_sales_qty * delta_good_price
                       );

            EXIT insert_update;

        EXCEPTION
            WHEN UNIQUE_VIOLATION THEN
                -- ничего не делать
        END;
    END LOOP insert_update;

    RETURN NULL;
END;
$ur$
    LANGUAGE plpgsql
    SECURITY DEFINER;

-- Trigger
CREATE OR REPLACE TRIGGER trigger_update_report
    AFTER INSERT OR UPDATE OR DELETE
    ON PRACT_FUNCTIONS.SALES
    FOR EACH ROW
EXECUTE PROCEDURE PRACT_FUNCTIONS.update_report();
```
Теперь при вставке, обновлении или удалении в таблице `sales` будет срабатывать триггер `trigger_update_report` и запускать функцию `update_report()`, которая в зависимости от типа операции будет вставлять или обновлять витрину.

## Вариант 2
Для ускорения работы триггерной функции, на мой вгляд, лучше добавить поле с ценой продажи в таблицу `sales`. Это уменьшит количество обращений и слияний таблиц `goods` и `sales` для определения цены продажи, а также будет в своем роде историей продаж и цен. Также при изменении цены товара в таблице `goods` это будет влиять на прошедшие продажи. 

```sql
DROP TABLE IF EXISTS sales_n;
CREATE TABLE sales_n
(
    sales_id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    good_id     integer REFERENCES goods (goods_id),
    sales_time  timestamp with time zone DEFAULT now(),
    sales_qty   integer CHECK (sales_qty > 0),
    sales_price numeric(12, 2) NOT NULL CHECK (sales_qty > 0)
);

-- trigger func
CREATE OR REPLACE FUNCTION PRACT_FUNCTIONS.update_report_n()
RETURNS TRIGGER AS $$
DECLARE 
    delta_goods_id      integer;
    delta_good_name     varchar(63);
    delta_sum_sale      numeric(16, 2);
BEGIN
    IF (TG_OP = 'DELETE') THEN 
        delta_goods_id = OLD.good_id;
        delta_sum_sale = -1 * OLD.sales_qty * OLD.sales_price;
        
    ELSIF (TG_OP = 'INSERT') THEN
        delta_good_name = (SELECT good_name FROM PRACT_FUNCTIONS.GOODS WHERE goods_id = NEW.good_id);
        delta_goods_id = NEW.good_id;
        delta_sum_sale = NEW.sales_qty * NEW.sales_price;

    ELSIF (TG_OP = 'UPDATE') THEN
        IF ( OLD.good_id != NEW.good_id) THEN
                RAISE EXCEPTION 'Update of goods_id : % -> % not allowed',
                                                      OLD.good_id, NEW.good_id;
        END IF;
        delta_goods_id = OLD.good_id;
        delta_sum_sale = NEW.sales_qty * NEW.sales_price - OLD.sales_qty * OLD.sales_price;
    
    END IF;

    <<insert_update>>
    LOOP
        UPDATE PRACT_FUNCTIONS.good_sum_mart
            SET sum_sale = COALESCE(sum_sale + delta_sum_sale, 0)
            WHERE goods_id = delta_goods_id;

        EXIT insert_update WHEN found;

        BEGIN
            INSERT INTO PRACT_FUNCTIONS.good_sum_mart (
                        goods_id,
                        good_name,
                        sum_sale)
                VALUES (
                        delta_goods_id,
                        delta_good_name,
                        delta_sum_sale
                       );

            EXIT insert_update;

        EXCEPTION
            WHEN UNIQUE_VIOLATION THEN
                -- ничего не делать
        END;
    END LOOP insert_update;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER;

-- trigger
CREATE OR REPLACE TRIGGER trigger_update_report_n
    AFTER INSERT OR UPDATE OR DELETE
    ON PRACT_FUNCTIONS.SALES_N 
    FOR EACH ROW
EXECUTE PROCEDURE PRACT_FUNCTIONS.update_report_n();

INSERT INTO sales_n (good_id, sales_qty, sales_price) VALUES (1, 10, 0.5), (1, 1, 0.5), (1, 120, 0.5), (2, 1, 185000000.01);
```

---

Подобная схема - _витрина+триггер_, предпочтительнее, прежде всего, в плане производительности, а также в актуальности текущего момента. 
Выборки данных по запросу, особенно при огромном количестве записей, часто сделать не получится. Поэтому актуальность данных по созданному отчету будут отличаться от реальных, если были внесены изменения в цену или ассортимент товара. 
Тогда как, триггер будет _держать_ данные витрины в актуальном состоянии, и выборку из нее можно делать чаще и дешевле.
