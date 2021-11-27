-- create this one directly in the schema
create table raw.jaffle_shop.case
(
    customer_id integer,
    id integer,
    type varchar,
    status varchar,
    origin varchar,
    _etl_loaded_at timestamp default current_timestamp

);

create or replace stage case_stage
  file_format = csv
  url = 's3://dbt-tutorial-sf'
  storage_integration = s3_int;
  
copy into raw.jaffle_shop.case (customer_id, id, type, status, origin)
  from @case_stage/data/jaffle_shop_case.csv;