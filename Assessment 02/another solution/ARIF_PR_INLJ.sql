-- INLJ: Indexed Nested Loop Join
-- Procedure_PR_INLJ.sql

create or replace PROCEDURE Pr_INLJ
IS
   --SET SERVEROUTPUT ON;
   --DECLARE
   v_customer_name   customers.customer_name%TYPE := NULL;

   v_product_name    products.product_name%TYPE := NULL;
   v_supplier_id     products.supplier_id%TYPE := NULL;
   v_supplier_name   products.supplier_name%TYPE := NULL;
   v_price           products.price%TYPE := NULL;

   v_exist           NUMBER := -1;

   v_batch_number    NUMBER := 0;
BEGIN
   DECLARE
      CURSOR cur_transaction
      IS
         SELECT *
           FROM transactions t
         ORDER BY t.transaction_id;

      TYPE transaction_table_type IS TABLE OF transactions%ROWTYPE;

      v_tranactions   transaction_table_type;
   BEGIN
      OPEN cur_transaction;

      LOOP
         FETCH cur_transaction
           BULK COLLECT INTO v_tranactions
         LIMIT 100;

         EXIT WHEN v_tranactions.COUNT = 0;

         v_batch_number := v_batch_number + 1;
         --Process contents of collection here.
         DBMS_OUTPUT.put_line (    'Processing of batch #'
                                || v_batch_number
                                || ' of '
                                || v_tranactions.COUNT
                                || ' records from '
                                || v_tranactions ( v_tranactions.FIRST ).transaction_id
                                || ' to '
                                || v_tranactions ( v_tranactions.LAST ).transaction_id );

         -- Read from the transaction cursor tuple by tuple
         FOR i IN v_tranactions.FIRST .. v_tranactions.LAST
         LOOP
            -- Getting the customer information from Customer table of Master Data with respect to customer_id exist in the transaction table
            -- And store the customer name in v_customer_name variable
            BEGIN
               SELECT c.customer_name
                 INTO v_customer_name
                 FROM customers c
                WHERE c.customer_id = v_tranactions ( i ).customer_id;
            END;

            -- Getting the product information from Products table of Master Data with respect to product_id exist in the transaction table
            -- And store the required information i.e.; product name, supplier_id, supplier_name, price in v_product_name, v_supplier_id, v_supplier_name, v_price variables respectively.
            BEGIN
               SELECT p.product_name, p.supplier_id, p.supplier_name, p.price
                 INTO v_product_name, v_supplier_id, v_supplier_name, v_price
                 FROM products p
                WHERE p.product_id = v_tranactions ( i ).product_id;
            END;

            ----------------------
            -- Pre-existing check
            ----------------------

            -- Insert new record if the customer is not exist in the d_customers dimention table
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM d_customers
                WHERE customer_id = v_tranactions ( i ).customer_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO d_customers ( customer_id, customer_name )
                  VALUES ( v_tranactions ( i ).customer_id, v_customer_name );

                  v_exist := -1;
               END IF;
            END;


            -- Insert new record if the product is not exist in the d_products dimention table
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM d_products
                WHERE product_id = v_tranactions ( i ).product_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO d_products ( product_id, product_name )
                  VALUES ( v_tranactions ( i ).product_id, v_product_name );

                  v_exist := -1;
               END IF;
            END;

            -- Insert new record if the store is not exist in the d_stores dimention table
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM d_stores
                WHERE store_id = v_tranactions ( i ).store_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO d_stores ( store_id, store_name )
                  VALUES ( v_tranactions ( i ).store_id, v_tranactions ( i ).store_name
                          );

                  v_exist := -1;
               END IF;
            END;

            -- Insert new record if the supplier is not exist in the d_suppliers dimention table
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM d_suppliers
                WHERE supplier_id = v_supplier_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO d_suppliers ( supplier_id, supplier_name )
                  VALUES ( v_supplier_id, v_supplier_name );

                  v_exist := -1;
               END IF;
            END;

            -- Insert new record if the time is not exist in the d_time dimention table
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM d_time
                WHERE time_id = v_tranactions ( i ).time_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO d_time ( time_id, cal_date, cal_day, cal_month,
                                       cal_quarter, cal_year )
                  VALUES ( v_tranactions ( i ).time_id, v_tranactions ( i ).t_date,
                           TO_CHAR ( v_tranactions ( i ).t_date, 'Day' ),
                           TO_CHAR ( v_tranactions ( i ).t_date, 'Month' ),
                           TO_CHAR ( v_tranactions ( i ).t_date, 'Q' ),
                           TO_CHAR ( v_tranactions ( i ).t_date, 'YYYY' )
                          );

                  v_exist := -1;
               END IF;
            END;

            -- Insert new record in w_fact table if the record is not already exist otherwise update the w_fact table.
            BEGIN
               SELECT COUNT ( 1 )
                 INTO v_exist
                 FROM w_facts
                WHERE transaction_id = v_tranactions ( i ).transaction_id;

               IF ( v_exist = 0 )
               THEN
                  INSERT INTO w_facts ( transaction_id, customer_id,
                                        product_id, store_id, supplier_id,
                                        time_id, quantity, price, sale )
                  VALUES ( v_tranactions ( i ).transaction_id,
                           v_tranactions ( i ).customer_id,
                           v_tranactions ( i ).product_id,
                           v_tranactions ( i ).store_id, v_supplier_id,
                           v_tranactions ( i ).time_id, v_tranactions ( i ).quantity,
                           v_price,
                           ( v_tranactions ( i ).quantity * v_price )
                          );
               END IF;
            END;

            v_exist := -1;
            v_customer_name := NULL;
            v_product_name := NULL;
            v_supplier_id := NULL;
            v_supplier_name := NULL;
            v_price := NULL;
         END LOOP;
      --DBMS_OUTPUT.PUT_LINE('These records has been inserted...');
      --DBMS_OUTPUT.PUT_LINE(v_count);

      END LOOP;

      COMMIT;

      CLOSE cur_transaction;
   END;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (    'An error was encountered - '
                             || SQLCODE
                             || ' -ERROR- '
                             || SQLERRM );
END Pr_INLJ;