-- 1. Which product generated maximum sales in September, 2017?

SELECT d_products.product_name,
       SUM ( w_facts.sale ) sale,
       DENSE_RANK ( ) OVER (ORDER BY SUM ( w_facts.sale ) DESC NULLS LAST)
          RANK
  FROM w_facts,
       d_products,
       (SELECT d_time.time_id
          FROM d_time
         WHERE cal_month = 'September' AND cal_year = 2017) v_dt
 WHERE w_facts.product_id = d_products.product_id
   AND w_facts.time_id = v_dt.time_id
GROUP BY d_products.product_name;

-- 2. Determine top three supplier names based on highest sales of their products.

SELECT *
  FROM (SELECT DENSE_RANK ( )
                  OVER (ORDER BY SUM ( w_facts.sale ) DESC NULLS LAST)
                  RANK,
               d_suppliers.supplier_name,
               SUM ( w_facts.sale ) sale
          FROM w_facts, d_suppliers
         WHERE w_facts.supplier_id = d_suppliers.supplier_id
        GROUP BY d_suppliers.supplier_name)
 WHERE RANK < 4;

-- 3. Determine the top 3 store names who generated highest sales in September, 2017.

SELECT *
  FROM (SELECT DENSE_RANK ( )
                  OVER (ORDER BY SUM ( w_facts.sale ) DESC NULLS LAST)
                  RANK,
               d_stores.store_name,
               SUM ( w_facts.sale ) sale
          FROM w_facts,
               d_stores,
               (SELECT d_time.time_id
                  FROM d_time
                 WHERE cal_month = 'September' AND cal_year = 2017) v_dt
         WHERE w_facts.time_id = v_dt.time_id
           AND w_facts.store_id = d_stores.store_id
        GROUP BY store_name)
 WHERE RANK < 4;


-- 4. Presents the quarterly sales analysis for all stores using drill down query concepts.

SELECT d_stores.store_name,
       SUM ( DECODE ( d_time.cal_quarter, 1, w_facts.sale, 0 ) ) q1_2017,
       SUM ( DECODE ( d_time.cal_quarter, 2, w_facts.sale, 0 ) ) q2_2017,
       SUM ( DECODE ( d_time.cal_quarter, 3, w_facts.sale, 0 ) ) q3_2017,
       SUM ( DECODE ( d_time.cal_quarter, 4, w_facts.sale, 0 ) ) q4_2017
  FROM w_facts, d_stores, d_time
 WHERE d_stores.store_id = w_facts.store_id
   AND d_time.time_id = w_facts.time_id
GROUP BY d_stores.store_name
ORDER BY d_stores.store_name;

-- 5. Create a materialised view with name “STORE_PRODUCT_ANALYSIS” that presents store
-- AND product wise sales. THE results should be ordered BY STORE NAME AND THEN product
-- name.

SELECT * FROM w_facts;

SELECT d_stores.store_name,
       d_products.product_name,
       SUM ( w_facts.sale ) Sale
  FROM w_facts, d_stores, d_products
 WHERE d_stores.store_id = w_facts.store_id
   AND d_products.product_id = w_facts.product_id
GROUP BY d_stores.store_name, d_products.product_name
ORDER BY d_stores.store_name, d_products.product_name;

CREATE MATERIALIZED VIEW STORE_PRODUCT_ANALYSIS
TABLESPACE USERS
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH ROWID
AS
SELECT d_stores.store_name,
       d_products.product_name,
       SUM ( w_facts.sale ) Sale
  FROM w_facts, d_stores, d_products
 WHERE d_stores.store_id = w_facts.store_id
   AND d_products.product_id = w_facts.product_id
GROUP BY d_stores.store_name, d_products.product_name
ORDER BY d_stores.store_name, d_products.product_name;


-- 6. Create a materialised view with name “MONTH_STORE_ANALYSIS” that presents month
-- AND STORE wise sales. THE results should be ordered BY MONTH NAME AND THEN STORE name.

SELECT * FROM w_facts;


SELECT d_time.cal_month month, d_stores.store_name, SUM ( w_facts.sale ) sale
  FROM w_facts, d_stores, d_time
 WHERE d_stores.store_Id = w_facts.store_id
   AND d_time.time_id = w_facts.time_id
GROUP BY d_time.cal_month, d_stores.store_name
ORDER BY d_time.cal_month, d_stores.store_name;

CREATE MATERIALIZED VIEW MONTH_STORE_ANALYSIS 
TABLESPACE USERS
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS 
SELECT d_time.cal_month month, d_stores.store_name, SUM ( w_facts.sale ) sale
  FROM w_facts, d_stores, d_time
 WHERE d_stores.store_Id = w_facts.store_id
   AND d_time.time_id = w_facts.time_id
GROUP BY d_time.cal_month, d_stores.store_name
ORDER BY d_time.cal_month, d_stores.store_name;