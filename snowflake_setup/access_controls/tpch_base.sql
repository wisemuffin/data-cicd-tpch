/**
    This script creates the top-level objects for the
    Jaffle Shop initiative in Snowflake. It also
    creates corresponding object access roles to assign to 
    business function roles as needed.
**/
//=============================================================================
// create databases
//=============================================================================
USE ROLE SYSADMIN;

// Databases
CREATE DATABASE DBT_TPCH_CICD_DEV;     // local dbt targets this db from developer machines
CREATE DATABASE DBT_TPCH_CICD_TEST;    // CI from pull requests happens here
CREATE DATABASE DBT_TPCH_CICD_PROD;    // CI from merges to master happens here 


//=============================================================================


//=============================================================================
// create warehouses
//=============================================================================
USE ROLE SYSADMIN;

// dev warehouse
CREATE WAREHOUSE
    DBT_TPCH_CICD_DEV_WH
    COMMENT='Warehouse for powering developer activities for the cloud cost monitoring project'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;
//=============================================================================


//=============================================================================
// create object access roles for databases
//=============================================================================
USE ROLE SECURITYADMIN;

// dev roles
CREATE ROLE DBT_TPCH_CICD_DEV_READ_WRITE;

// test roles
CREATE ROLE DBT_TPCH_CICD_TEST_READ_WRITE;

// prod roles
CREATE ROLE DBT_TPCH_CICD_PROD_READ_WRITE;
CREATE ROLE DBT_TPCH_CICD_PROD_READ;

// grant all roles to sysadmin (always do this)
GRANT ROLE DBT_TPCH_CICD_DEV_READ_WRITE      TO ROLE SYSADMIN;
GRANT ROLE DBT_TPCH_CICD_TEST_READ_WRITE     TO ROLE SYSADMIN;
GRANT ROLE DBT_TPCH_CICD_PROD_READ_WRITE     TO ROLE SYSADMIN;
GRANT ROLE DBT_TPCH_CICD_PROD_READ           TO ROLE SYSADMIN;

// grant read access to prod to allow referencing of prod data in DEV and TEST
GRANT ROLE DBT_TPCH_CICD_PROD_READ           TO ROLE DBT_TPCH_CICD_DEV_READ_WRITE;
GRANT ROLE DBT_TPCH_CICD_PROD_READ           TO ROLE DBT_TPCH_CICD_TEST_READ_WRITE;
//=============================================================================


//=============================================================================
// create object access roles for warehouses
//=============================================================================
USE ROLE SECURITYADMIN;

// dev roles
CREATE ROLE DBT_TPCH_CICD_DEV_WH_ALL;

// grant all roles to sysadmin (always do this)
GRANT ROLE DBT_TPCH_CICD_DEV_WH_ALL TO ROLE SYSADMIN;
//=============================================================================
 

//=============================================================================
// grant privileges to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;

// dev permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE DBT_TPCH_CICD_DEV TO ROLE DBT_TPCH_CICD_DEV_READ_WRITE;
GRANT ALL PRIVILEGES ON WAREHOUSE DBT_TPCH_CICD_DEV_WH   TO ROLE DBT_TPCH_CICD_DEV_WH_ALL;

// test permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE DBT_TPCH_CICD_TEST TO ROLE DBT_TPCH_CICD_TEST_READ_WRITE;

// prod permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE DBT_TPCH_CICD_PROD TO ROLE DBT_TPCH_CICD_PROD_READ_WRITE;

// also allow read access
GRANT USAGE ON DATABASE DBT_TPCH_CICD_PROD TO ROLE DBT_TPCH_CICD_PROD_READ;
GRANT USAGE ON ALL SCHEMAS IN DATABASE DBT_TPCH_CICD_PROD  to role DBT_TPCH_CICD_PROD_READ;
GRANT SELECT ON ALL TABLES IN DATABASE DBT_TPCH_CICD_PROD to role DBT_TPCH_CICD_PROD_READ;
GRANT SELECT ON ALL VIEWS IN DATABASE DBT_TPCH_CICD_PROD to role DBT_TPCH_CICD_PROD_READ;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE DBT_TPCH_CICD_PROD  to role DBT_TPCH_CICD_PROD_READ;
GRANT SELECT ON FUTURE TABLES IN DATABASE DBT_TPCH_CICD_PROD to role DBT_TPCH_CICD_PROD_READ;
GRANT SELECT ON FUTURE VIEWS IN DATABASE DBT_TPCH_CICD_PROD to role DBT_TPCH_CICD_PROD_READ;

//=============================================================================


//=============================================================================
// create business function roles and grant access to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;
 
// transformer roles
CREATE ROLE DBT_TPCH_CICD_DEV_TRANSFORMER;
 
// grant all roles to sysadmin (always do this)
GRANT ROLE DBT_TPCH_CICD_DEV_TRANSFORMER  TO ROLE SYSADMIN;

// dev OA roles
GRANT ROLE DBT_TPCH_CICD_DEV_READ_WRITE TO ROLE DBT_TPCH_CICD_DEV_TRANSFORMER;
GRANT ROLE DBT_TPCH_CICD_DEV_WH_ALL     TO ROLE DBT_TPCH_CICD_DEV_TRANSFORMER;
-- GRANT ROLE FIVETRAN_READ_ROLE                   TO ROLE DBT_TPCH_CICD_DEV_TRANSFORMER;
GRANT ROLE RAW_READ_ROLE                    TO ROLE DBT_TPCH_CICD_DEV_TRANSFORMER;
//=============================================================================
