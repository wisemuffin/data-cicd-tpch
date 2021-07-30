# Instructions on how to setup this project

## Snowflake roles and compute setup

see docs in ./snowflake_setup/README.md

## github actions

### Secrets to add
If switching trial versions of snowflake you just need to update: DBT_PROFILE_SNOWFLAKE_ACCOUNT

AWS_ACCESS_KEY_ID
AWS_ROLE_TO_ASSUME
AWS_SECRET_ACCESS_KEY
DATAFOLD_APIKEY
DATAFOLD_HOST
DBT_PROFILE_PROD_PASSWORD
DBT_PROFILE_PROD_USER
DBT_PROFILE_SNOWFLAKE_ACCOUNT - example xx12345.ap-southeast-2
DBT_PROFILE_TEST_PASSWORD
DBT_PROFILE_TEST_USER

