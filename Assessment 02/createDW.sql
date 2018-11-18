--------------------------------------------------------
-- Drop existing tables from Data Warehouse
--------------------------------------------------------

DROP TABLE w_facts;
DROP TABLE d_customers;
DROP TABLE d_products;
DROP TABLE d_stores;
DROP TABLE d_suppliers;
DROP TABLE d_time;

--------------------------------------------------------
-- Drop existing materialized views from Data Warehouse
--------------------------------------------------------

DROP MATERIALIZED VIEW STORE_PRODUCT_ANALYSIS;
DROP MATERIALIZED VIEW MONTH_STORE_ANALYSIS;

--------------------------------------------------------
--  DDL statement for D_CUSTOMERS Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE D_CUSTOMERS(
    CUSTOMER_ID VARCHAR2(4) PRIMARY KEY, 
    CUSTOMER_NAME VARCHAR2(30) NOT NULL);

    
--------------------------------------------------------
--  DDL statement for D_PRODUCTS Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE D_PRODUCTS(
    PRODUCT_ID VARCHAR2(6) PRIMARY KEY, 
    PRODUCT_NAME VARCHAR2(30) NOT NULL);

--------------------------------------------------------
--  DDL statement for D_STORES Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE D_STORES(
    STORE_ID VARCHAR2(4) PRIMARY KEY, 
    STORE_NAME VARCHAR2(30) NOT NULL);

--------------------------------------------------------
--  DDL statement for D_SUPPLIERS Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE D_SUPPLIERS(
    SUPPLIER_ID VARCHAR2(5) PRIMARY KEY, 
    SUPPLIER_NAME VARCHAR2(30) NOT NULL);

--------------------------------------------------------
--  DDL statement for D_TIME Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE D_TIME(
    TIME_ID VARCHAR2(8) PRIMARY KEY, 
    CAL_DATE DATE NOT NULL,
    CAL_DAY VARCHAR2(9) NOT NULL,
    CAL_MONTH VARCHAR2(9) NOT NULL,
    CAL_QUARTER VARCHAR2(1) NOT NULL,
    CAL_YEAR NUMBER(4,0) NOT NULL);

--------------------------------------------------------
--  DDL statement for W_FACTS Table (DATA WAREHOUSE)
--------------------------------------------------------
 CREATE TABLE W_FACTS(
    TRANSACTION_ID VARCHAR2(8) PRIMARY KEY, 
    CUSTOMER_ID VARCHAR2(5) NOT NULL,
    PRODUCT_ID VARCHAR2(8) NOT NULL,
    STORE_ID VARCHAR2(4) NOT NULL,
    SUPPLIER_ID VARCHAR2(5) NOT NULL,
    TIME_ID VARCHAR2(8) NOT NULL,
    QUANTITY NUMBER(2,0) NOT NULL,
    PRICE NUMBER(5,2) NOT NULL,
    SALE NUMBER(6,2) NOT NULL,    
    CONSTRAINT "D_CUSTOMER_ID_FK" FOREIGN KEY (CUSTOMER_ID) REFERENCES D_CUSTOMERS(CUSTOMER_ID),
    CONSTRAINT "D_PRODUCT_ID_FK" FOREIGN KEY (PRODUCT_ID) REFERENCES D_PRODUCTS(PRODUCT_ID),
    CONSTRAINT "D_STORE_ID_FK" FOREIGN KEY (STORE_ID) REFERENCES D_STORES(STORE_ID),
    CONSTRAINT "D_SUPPLIER_ID_FK" FOREIGN KEY (SUPPLIER_ID) REFERENCES D_SUPPLIERS(SUPPLIER_ID),
    CONSTRAINT "D_TIME_ID_FK" FOREIGN KEY (TIME_ID) REFERENCES D_TIME(TIME_ID));
