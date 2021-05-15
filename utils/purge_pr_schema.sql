use database DBT_TPCH_CICD_TEST;
show schemas like 'PR_%';
select 'drop schema ' || "name" || ';' from table(result_scan(last_query_id())) 
where "created_on" < dateadd(day, -2, current_timestamp());