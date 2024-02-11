# Студент: Киселев Виктор
# Диаграма таблиц из dbdiagram
![Alt text](/imgs/dbdiagram.png?raw=true "Optional Title")
# Создадим исохдные таблицы, загрузим туда данные

```
create table transactions (
  transaction_id integer primary key
  ,customer_id integer not null
  ,transaction_date date not null
  ,online_order bool -- may be null
  ,order_status varchar(9) not null
  ,product_id integer not null
  ,brand varchar(50) not null
  ,product_line varchar(10) not null
  ,product_class varchar(20) not null
  ,product_size varchar(10) not null
  ,list_price float not null
  ,standart_cost float -- may be null
)
```
![Alt text](/imgs/source_transactions.png?raw=true "Optional Title")
```

create table customers(
  customer_id integer primary key
  ,first_name text not null
  ,last_name text not null
  ,gender varchar(20) not null
  ,DOB date -- may be null
  ,job_title text not null
  ,job_industry_category varchar(50) not null
  ,wealth_segment varchar(30) not null
  ,deceased_indicator varchar(10) not null
  ,owns_car bool not null
  ,address text not null
  ,postcode integer not null
  ,state varchar(50) not null
  ,country varchar(50) not null
  ,property_valuation integer not null
)
```
![Alt text](/imgs/source_customers_1.png?raw=true "Optional Title")
![Alt text](/imgs/source_customers_2.png?raw=true "Optional Title")
# Проверим, какие атрибуты принимают значение null
В таблице "transactions":
```
select 
bool_and(transaction_id is not null) as transaction_id_have_no_null
,bool_and(product_id  is not null) as product_id_have_no_null
,bool_and(customer_id  is not null) as customer_id_have_no_null
,bool_and(transaction_date  is not null) as transaction_date_have_no_null
,bool_and(online_order  is not null) as online_order_have_no_null
,bool_and(order_status is not null) as order_status_have_no_null
,bool_and(brand  is not null) as brand_have_no_null
,bool_and(product_line is not null) as product_line_have_no_null 
,bool_and(product_class is not null) as product_class_have_no_null
,bool_and(product_size is not null) as product_size_have_no_null
,bool_and(list_price  is not null) as list_price_have_no_null
,bool_and(standard_cost  is not null) as standard_cost_have_no_null
from transactions t 
```
Поля, содержащие null:
"online_order", "standart_cost"

В таблице "customers":
```
select 
bool_and(customer_id is not null) as customer_id_have_no_null
,bool_and(first_name is not null) as first_name_have_no_null
,bool_and(last_name is not null) as last_name_have_no_null
,bool_and(gender is not null) as gender_have_no_null
,bool_and(dob is not null) as dob_have_no_null
,bool_and(job_title is not null) as job_title_have_no_null
,bool_and(job_industry_category is not null) as job_industry_category_have_no_null
,bool_and(wealth_segment is not null) as wealth_segment_have_no_null
,bool_and(deceased_indicator is not null) as deceased_indicator_have_no_null
,bool_and(owns_car is not null) as owns_car_have_no_null
,bool_and(address is not null) as address_have_no_null
,bool_and(postcode is not null) as postcode_have_no_null
,bool_and(state is not null) as state_have_no_null
,bool_and(country is not null) as country_have_no_null
,bool_and(property_valuation is not null) as property_valuation_have_no_null
,bool_and(home_number is not null) as home_number_have_no_null
,bool_and(region_name is not null) as region_name_have_no_null
from customers c 
```
Поля, содержащие null:
"DOB" 

# Приведение типов данных

В исходных таблицах есть следующие атрибуты, типы которых необходимо изменить:
* "transaction_date" имел текстовый тип, приводим к типу "date"
    ```
    ALTER TABLE transactions  ALTER COLUMN transaction_date TYPE date USING cast(transaction_date as date);
    ```
* "online_order" имеет текстовый тип. Мы приводим к типу "bool". Пустую строку преобразуем в null:
    ```
    ALTER TABLE transactions  ALTER COLUMN online_order TYPE bool USING cast((case online_order when '' then null else online_order end) as bool);
    ```
* "DOB" имеет текстовый тип. Приводим к типу "date". Пустую строку преобразуем в null
    ```
    ALTER TABLE customers  ALTER COLUMN DOB TYPE date USING cast((case DOB when '' then null else DOB end) as date);
    ```
* "deceased_indicator" имеет текствовый тип. Приводим к типу "bool". Значений null нет.
    ```
    ALTER TABLE customers  ALTER COLUMN deceased_indicator TYPE bool USING case deceased_indicator when 'Y' then true when 'N' then false end;
    ```
* "owns_car" имеет текстовый тип. Приводим к типу "bool". Значений null нет.
    ```
    ALTER TABLE customers  ALTER COLUMN owns_car TYPE bool USING case owns_car when 'Yes' then true when 'No' then false end;
    ```

# Преобразование к нормальным формам:

1. В исходной таблице "transaction" нет повторяющихся записей, каждая ячейка содержит только скалярное значение. 
В таблице customer нет повторяющихся записей, но есть атрибут "address", который состоит из номера и названия района, что не является скалярным значением. 

    Для приведения этой таблицы к 1НФ разбиваем атрибут "address" на 2 атрибута: номер дома, название района. Для этого сначала проверим, что атрибут "address" нигде не принимает значение "null", первый символ является цифрой, значение атрибута всегда содержит символ пробела

```
select 
sum(
	case when address is null then 1 
	else 0 
	end
	) = 0 as have_not_null
, sum(
	case when position(' ' in address) != 0 then 1
	else 0
	end) = count(*) as always_have_space
, sum(case when position(substring(address from 1 for 1) in '0123456789') != 0 then 1
	else 0
	end) = count(*) as always_first_is_digit
from customers c 
```

Узнаем, что атрибут "address" нигде не принимает значение "null", первый символ всегда является цифрой, пробел всегда есть в значении атрибута. Поэтому создаем новые атрибуты, разбиваем исходный атрибут на два: один будет иметь целочисленный тип, хранить номер дома, второй - текстовый тип, он будет хранить название региона.

```
alter table customers 
add column if not exists  home_number  integer,
add column if not exists  region_name  text;

update customers 
set home_number = cast(substring(address from 1 for position(' ' in address)) as integer),
region_name = substring(address from position(' ' in address) + 1 )

alter table customers
drop column if exists address
```

Также атрибут "job_title" содержит название должности и может содержать ранг, пример: "Media Manager IV"
Разделим данный атрибут на два, чтобы каждый из них содержал скалярное значение:
Посмотрим, какие бывают ранги:
```
select substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2), count(*)
from customers
group by substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2)
order by -count(*)
```

Ранга может не быть, он может принимать значения: "I", "II", "III", "IV".
Создадим отдельную колонку для ранга, в исходной колонке с названием должности уберем обозначение ранга:

```
ALTER TABLE customers  
add if not exists job_rank integer

update customers
set job_rank  = case 
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'I' then 1
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'II' then 2
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'III' then 3
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'IV' then 4
	else null 
end
,job_title = case 
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'I' then (substring(job_title from 1 for length(job_title) - length('I') - 1)) 
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'II' then (substring(job_title from 1 for length(job_title) - length('II') - 1))
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'III' then (substring(job_title from 1 for length(job_title) - length('III') - 1))
	when substring(job_title from length(job_title) - position (' ' in reverse(job_title)) + 2) = 'IV' then (substring(job_title from 1 for length(job_title) - length('IV') - 1))
	else job_title 
end;
```

2. Пусть в исходной таблице "transaction" первичным ключом является атрибут "transaction_id", тогда каждый атрибут зависит от него. 
Пусть в исохдной таблице "customer" первичным ключом является "customer_id", тогда каждый атрибут зависит от него. Поэтому база данных находится во 2НФ

3. В таблице "customer" существует транзитивная зависимость: "country" зависит от "postcode", "postcode" зависит от "customer_id". Поэтому данная таблица не находится в 3НФ. Для приведения её к 3НФ необходимо сделать декомпозицию, создать таблицу "postcode_country":
```
CREATE TABLE postcode_country (
	postcode integer PRIMARY key,
	country varchar(50) not null
)

insert into postcode_country (postcode, country)
select distinct postcode, country 
from customers 

alter table customers
drop table if exists country

ALTER TABLE customers
ADD FOREIGN KEY (postcode) REFERENCES postcode_country(postcode);
```
Логично предположить, что "state" тоже может зависеть от "postcode". Однако, это не так. Значению "postcode" = 2016 соответствует два значения атрибута state: "NSW", "New South Wales".

# Преобразования БД для уменьшения ее размера в памяти

Различных сочетаний полей "product_id", "brand", "product_line", "product_size" меньше, чем кол-во транзакций, поэтому разумно создать таблицу "products" с этими полями, суррогатным первичным ключом.
В таблице с транзакциями убираем поля продукта, добавляем "surrogate_product_id".
```
create table products (
	surrogate_product_id SERIAL PRIMARY KEY,
	product_id integer not null,
	brand varchar(50) not null,
	product_line varchar(10) not null,
	product_class varchar(10) not null,
	product_size varchar(10) not null
)


insert into products (product_id, brand, product_line, product_class, product_size)
select  product_id,  brand, product_line, product_class, product_size
from transactions
group by product_id,  brand, product_line, product_class, product_size

alter table transactions 
add column if not exists surrogate_product_id serial

update transactions t
set
surrogate_product_id = p.surrogate_product_id
from products p
where t.product_id = p.product_id and 
t.brand = p.brand and 
t.product_line = p.product_line and 
t.product_size = p.product_size


ALTER TABLE transactions
ADD FOREIGN KEY (surrogate_product_id) REFERENCES products(surrogate_product_id);

```

Многие атрибуты являются категориальными. Для уменьшения используемой памяти можно сделать отдельную таблицу для каждого из них, создать суррогатный первичный ключ, который будет занимать меньше памяти, чем значения атрибута. В исходной таблице удалить атрибут, добавить суррогатный ключ и сделать связь с новой таблицей. 

Данную операцию можно проделать для атрибутов: "job_industry_category", "wealth_segment", "country" ...

# Ошибки в данных

В таблице "transaction" у атрибута "customer_id" есть значение 5034, однако в таблице "customer" у атрибута "customer_id" нет такого значения. 
Я заменил это значение на 4000, чтобы внешний ключ из "transaction" в "customer" по полю "customer_id" смог добавиться.

```
update transactions 
set customer_id = 4000
where customer_id = 5034
```

Теперь можно добавить этот внешний ключ:

```
alter table customers
add primary key (customer_id)

alter table transactions 
add foreign key (customer_id) references customers(customer_id)
```
# Таблицы после загрузки данных
## customers
![Alt text](/imgs/customers_1.png?raw=true "Optional Title")
![Alt text](/imgs/customers_2.png?raw=true "Optional Title")
## postcode_country
![Alt text](/imgs/postcode_country.png?raw=true "Optional Title")
## products
![Alt text](/imgs/products.png?raw=true "Optional Title")
## transactions
![Alt text](/imgs/transactions.png?raw=true "Optional Title")
# Диаграма таблиц из DBeaver
![Alt text](/imgs/tables_diagram.png?raw=true "Optional Title")
