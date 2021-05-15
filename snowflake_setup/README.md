# Principals of access controls
- every role created needs to be granted to sysadmin

# infrastructure

## Databases

- DBT_TPCH_CICD_DEV - schema per developer
- DBT_TPCH_CICD_TEST - schema per pull request to UAT and test pull requests
- DBT_TPCH_CICD_PROD - production
- PC_FIVETRAN_DB - fivetrans required setup, same purpose as raw.
- RAW - data loaded into the warehouse in a raw format

# Setup order

- start a free trial with snowflake
- [setup your AWS account's s3 with snowflake](https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html)
- to get some sample raw data
    - run ./access_controls/raw_base.sql (update IAM role)
    - ./access_controls/raw/*.sql
    - ./ddl/raw/*.sql
- then setup jaffle shop
    - ./access_controls/jaffle_shop_base.sql
    - ./access_controls/service_accounts/*.sql

- fivetran working on (i think this is just created by fivetran)



## CICD setup
run CDK in /infrastructure