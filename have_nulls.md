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