# Преобразование к нормальным формам:

1. В исходной таблице transaction нет повторяющихся записей, каждая ячейка содержит только скалярное значение. В таблице customer нет повторяющихся записей, но есть атрибут "address", который состоит из номера и названия района, что не является скалярным значением. 

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
```

2. Пусть в исходной таблице первичным ключом является атрибут "transaction_id", тогда каждый атрибут зависит от него, поэтому база данных находится во 2НФ

3. Если считать, что атрибут "transaction_id" является первичным ключом, то 

