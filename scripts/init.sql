-- create db DSaPS_HW1
drop table if exists transactions;

create table if not exists transactions (
    transaction_id integer primary key
    ,product_id integer
    ,customer_id integer
    ,transaction_date varchar(10)
    ,online_order varchar(5)
    ,order_status varchar(9)
    ,brand text
    ,product_line varchar(20)
    ,product_class varchar(20)
    ,product_size varchar(20)
    ,list_price float
    ,standard_cost float
);

drop table if exists customers;

create table if not exists customers (
    customer_id integer
    ,first_name text
    ,last_name text
    ,gender varchar(20)
    ,DOB varchar(10)
    ,job_title text
    ,job_industry_category text
    ,wealth_segment varchar(30)
    ,deceased_indicator varchar(10)
    ,owns_car varchar(5)
    ,address text
    ,postcode integer
    ,state varchar(50)
    ,country varchar(20)
    ,property_valuation integer
);

-- import data from files

create