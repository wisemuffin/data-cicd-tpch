-- create this one directly in the schema
create table raw.jaffle_shop.customers
(
    id integer,
    first_name varchar,
    last_name varchar
);

copy into raw.jaffle_shop.customers (id, first_name, last_name)
    from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
        file_format = (
            type = 'CSV'
            field_delimiter = ','
            skip_header = 1
        )
;