//=============================================================================
// create warehouses
//=============================================================================
USE ROLE SYSADMIN;

// test warehouse
CREATE WAREHOUSE
    DBT_TPCH_CICD_TEST_WH
    COMMENT='Warehouse for powering CI test activities for the jaffle shop project'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;
//=============================================================================


//=============================================================================
// create object access roles for warehouses
//=============================================================================
USE ROLE SECURITYADMIN;

// test for ci (not for humans)
CREATE ROLE DBT_TPCH_CICD_TEST_WH_USAGE;

// grant all roles to sysadmin (always do this)
GRANT ROLE DBT_TPCH_CICD_TEST_WH_USAGE TO ROLE SYSADMIN;
//=============================================================================


//=============================================================================
// grant privileges to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;

// test permissions
GRANT USAGE ON WAREHOUSE DBT_TPCH_CICD_TEST_WH TO ROLE DBT_TPCH_CICD_TEST_WH_USAGE;
//=============================================================================


//=============================================================================
// create business function roles and grant access to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;
 
// transformer roles
CREATE ROLE DBT_TPCH_CICD_TEST_TRANSFORMER;
 
// grant all roles to sysadmin (always do this)
GRANT ROLE DBT_TPCH_CICD_TEST_TRANSFORMER TO ROLE SYSADMIN;

// test OA roles
GRANT ROLE DBT_TPCH_CICD_TEST_READ_WRITE TO ROLE DBT_TPCH_CICD_TEST_TRANSFORMER;
GRANT ROLE DBT_TPCH_CICD_TEST_WH_USAGE   TO ROLE DBT_TPCH_CICD_TEST_TRANSFORMER;
GRANT ROLE FIVETRAN_READ_ROLE                    TO ROLE DBT_TPCH_CICD_TEST_TRANSFORMER;
GRANT ROLE RAW_READ_ROLE                      TO ROLE DBT_TPCH_CICD_TEST_TRANSFORMER;
//=============================================================================


//=============================================================================
// create service account
//=============================================================================
USE ROLE SECURITYADMIN;
 
// create service account
CREATE USER 
  DBT_DBT_TPCH_CICD_TEST_SERVICE_ACCOUNT
  PASSWORD = 'my cool password here' // use your own password 
  COMMENT = 'Service account for DBT CI/CD in the test environment of the jaffle shop project.'
  DEFAULT_WAREHOUSE = DBT_TPCH_CICD_TEST_WH
  DEFAULT_ROLE = DBT_TPCH_CICD_TEST_TRANSFORMER
  MUST_CHANGE_PASSWORD = FALSE;

// grant permissions to service account
GRANT ROLE DBT_TPCH_CICD_TEST_TRANSFORMER TO USER DBT_DBT_TPCH_CICD_TEST_SERVICE_ACCOUNT;