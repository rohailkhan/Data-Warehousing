-- ImplementationStarSchema.sql

ALTER TABLE D_CUSTOMERS
 DROP PRIMARY KEY CASCADE;

DROP TABLE D_CUSTOMERS CASCADE CONSTRAINTS;

CREATE TABLE D_CUSTOMERS
(
   CUSTOMER_ID     VARCHAR2 ( 4 BYTE ),
   CUSTOMER_NAME   VARCHAR2 ( 30 BYTE ) NOT NULL,
   CONSTRAINT PK_D_CUSTOMER PRIMARY KEY ( CUSTOMER_ID ) ENABLE VALIDATE
);


ALTER TABLE D_PRODUCTS
 DROP PRIMARY KEY CASCADE;

DROP TABLE D_PRODUCTS CASCADE CONSTRAINTS;

CREATE TABLE D_PRODUCTS
(
   PRODUCT_ID     VARCHAR2 ( 6 BYTE ),
   PRODUCT_NAME   VARCHAR2 ( 30 BYTE ) NOT NULL,
   CONSTRAINT PK_D_PRODUCTS PRIMARY KEY ( PRODUCT_ID ) ENABLE VALIDATE
);


ALTER TABLE D_STORES
 DROP PRIMARY KEY CASCADE;

DROP TABLE D_STORES CASCADE CONSTRAINTS;

CREATE TABLE D_STORES
(
   STORE_ID     VARCHAR2 ( 4 BYTE ),
   STORE_NAME   VARCHAR2 ( 30 BYTE ) NOT NULL,
   CONSTRAINT PK_D_STORES PRIMARY KEY ( STORE_ID ) ENABLE VALIDATE
);


ALTER TABLE D_SUPPLIERS
 DROP PRIMARY KEY CASCADE;

DROP TABLE D_SUPPLIERS CASCADE CONSTRAINTS;

CREATE TABLE D_SUPPLIERS
(
   SUPPLIER_ID     VARCHAR2 ( 5 BYTE ),
   SUPPLIER_NAME   VARCHAR2 ( 30 BYTE ) NOT NULL,
   CONSTRAINT PK_D_SUPPLIERS PRIMARY KEY ( SUPPLIER_ID ) ENABLE VALIDATE
);


ALTER TABLE D_TIME
 DROP PRIMARY KEY CASCADE;

DROP TABLE D_TIME CASCADE CONSTRAINTS;

CREATE TABLE D_TIME
(
   TIME_ID       VARCHAR2 ( 8 BYTE ) NOT NULL,
   CAL_DATE      DATE NOT NULL,
   CAL_DAY       VARCHAR2 ( 9 BYTE ),
   CAL_MONTH     VARCHAR2 ( 9 BYTE ),
   CAL_QUARTER   VARCHAR2 ( 1 BYTE ),
   CAL_YEAR      NUMBER ( 4 ),
   CONSTRAINT PK_D_TIME PRIMARY KEY ( TIME_ID ) ENABLE VALIDATE
);


ALTER TABLE W_FACTS
 DROP PRIMARY KEY CASCADE;

DROP TABLE W_FACTS CASCADE CONSTRAINTS;

CREATE TABLE W_FACTS
(
   TRANSACTION_ID   NUMBER ( 8 ),
   CUSTOMER_ID      VARCHAR2 ( 5 BYTE ),
   PRODUCT_ID       VARCHAR2 ( 8 BYTE ),
   STORE_ID         VARCHAR2 ( 4 BYTE ),
   SUPPLIER_ID      VARCHAR2 ( 5 BYTE ),
   TIME_ID          VARCHAR2 ( 8 BYTE ) NOT NULL,
   QUANTITY         NUMBER ( 3 ) NOT NULL,
   PRICE            NUMBER ( 5, 2 ),
   SALE             NUMBER ( 6, 2 ),
   CONSTRAINT PK_W_FACTS PRIMARY KEY ( TRANSACTION_ID ) ENABLE VALIDATE,
   CONSTRAINT FK_W_FACTS_D_CUSTOMERS FOREIGN KEY
      ( CUSTOMER_ID )
       REFERENCES D_CUSTOMERS ( CUSTOMER_ID ) ON DELETE SET NULL
      ENABLE VALIDATE,
   CONSTRAINT FK_W_FACTS_D_PRODUCTS FOREIGN KEY
      ( PRODUCT_ID )
       REFERENCES D_PRODUCTS ( PRODUCT_ID ) ON DELETE SET NULL
      ENABLE VALIDATE,
   CONSTRAINT FK_W_FACTS_D_STORES FOREIGN KEY
      ( STORE_ID )
       REFERENCES D_STORES ( STORE_ID )
      ENABLE VALIDATE,
   CONSTRAINT FK_W_FACTS_D_SUPPLIERS FOREIGN KEY
      ( SUPPLIER_ID )
       REFERENCES D_SUPPLIERS ( SUPPLIER_ID ) ON DELETE SET NULL
      ENABLE VALIDATE,
   CONSTRAINT FK_W_FACTS_D_TIME FOREIGN KEY
      ( TIME_ID )
       REFERENCES D_TIME ( TIME_ID ) ON DELETE SET NULL
      ENABLE VALIDATE
);