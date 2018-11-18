CREATE OR REPLACE PROCEDURE INLJ IS
    
  -- Declare the variables to helps to get the data in form of batches
  var_total_records number;  
  var_records_per_batch number := 100;  
  var_total_batch number;
  var_count_batch number := 1;
  var_from number := 1; 
  var_to number := var_records_per_batch;
   
  var_customer_name customers.customer_name%type := NULL; 
  var_product_name products.product_name%type := NULL;
  var_supplier_id products.supplier_id%type := NULL;
  var_supplier_name products.supplier_name%type := NULL;
  var_price products.price%type := NULL;  
  
   var_count number;
  
BEGIN
   

   /*processing total number of transactions from the transaction tabl and then assigning it to var_total_records*/
   BEGIN
      SELECT COUNT(*) 
      INTO var_total_records  
      FROM TRANSACTIONS;      
   END;
   
   var_total_batch := (var_total_records / var_records_per_batch); 
   
   WHILE var_count_batch <=  var_total_batch
   LOOP      
      
      DECLARE        
        CURSOR c_transaction_cursor IS
        SELECT *
         FROM transactions t
         WHERE t.transaction_id BETWEEN var_from AND var_to
         ORDER BY transaction_id;    
        
      BEGIN    
          
      
        /* We shall use FOR LOOP FOR TUPLE BY TUPLE RECORD*/
        FOR transaction_record IN c_transaction_cursor
        LOOP        

 /* Extracting customer data from Master data wrt customer_id in transaction table and then store customer name in var_customer */
            BEGIN         
              SELECT  c.customer_name 
              INTO var_customer_name
              FROM customers c           
              WHERE c.customer_id = transaction_record.customer_id;          
            END;
            
 /* Extracting product information from Master data wrt product_id in transaction table and then store store the required information in var_product_name, var_supplier_id, var_supplier_name, 
var_price variables respectively */
            BEGIN         
              SELECT  p.product_name, p.supplier_id, p.supplier_name, p.price 
              INTO var_product_name, var_supplier_id, var_supplier_name, var_price 
              FROM products p           
              WHERE p.product_id = transaction_record.product_id;          
            END;
           
         
    /* Adding new record if customer is not existing in d_customers */
            BEGIN
              SELECT COUNT(*) 
              INTO var_count 
              FROM d_customers 
              WHERE customer_id=transaction_record.customer_id;
              
              IF (var_count = 0) THEN
               INSERT INTO d_customers (customer_id, customer_name) values (transaction_record.customer_id, var_customer_name);               
              END IF;        
            END;  
           
            /* Adding new record if product is not existing in  d_products */
            BEGIN
              SELECT COUNT(0) 
              INTO var_count 
              FROM d_products 
              WHERE product_id=transaction_record.product_id;
              
              IF (var_count = 0) THEN
                 INSERT INTO d_products (product_id, product_name) values (transaction_record.product_id, var_product_name);                 
              END IF;
            END;
            
            
             /* Adding new record if store is not existing in  d_stores */
            BEGIN
              SELECT COUNT(1) 
              INTO var_count
              FROM d_stores 
              WHERE store_id=transaction_record.store_id;
              
              IF (var_count = 0) THEN
                 INSERT INTO d_stores (store_id, store_name) VALUES (transaction_record.store_id, transaction_record.store_name);                  
              END IF;
            END;
            
            
         /* Adding new record if supplier is not existing in  d_suppliers */
            BEGIN
              SELECT COUNT(1) 
              INTO var_count 
              FROM d_suppliers 
              WHERE supplier_id=var_supplier_id;
              
              IF (var_count = 0) THEN
                 INSERT INTO d_suppliers (supplier_id, supplier_name) values (var_supplier_id, var_supplier_name);                 
              END IF;
            END;
            
              
         /* Adding new record if time is not existing in  d_time dimention table */
            BEGIN
              SELECT COUNT(1) 
              INTO var_count 
              FROM d_time 
              WHERE time_id=transaction_record.time_id;
              
              IF (var_count = 0) THEN
                 INSERT INTO d_time (time_id, cal_date, cal_day, cal_month, cal_quarter, cal_year) VALUES (transaction_record.time_id, transaction_record.t_date, TO_CHAR(transaction_record.t_date,'Day'), TO_CHAR(transaction_record.t_date,'Month'), TO_CHAR(transaction_record.t_date,'Q'), TO_CHAR(transaction_record.t_date,'YYYY'));                 
              END IF;
            END;
            
        
        /* Adding new record in w_fact if its is not existing otherwise update w_fact */
            
            BEGIN
              SELECT COUNT(1) 
                INTO var_count
                FROM w_facts 
               WHERE transaction_id = transaction_record.transaction_id;
                     
              IF (var_count = 0) THEN
                 INSERT INTO w_facts (transaction_id, customer_id, product_id, store_id, supplier_id, time_id, quantity, price, sale)
                  VALUES (transaction_record.transaction_id, transaction_record.customer_id, transaction_record.product_id, transaction_record.store_id, var_supplier_id, transaction_record.time_id, transaction_record.quantity, var_price, (transaction_record.quantity * var_price));            
              END IF;            
            END;
                        
            var_customer_name := NULL;  
            var_product_name := NULL;
            var_supplier_id := NULL;
            var_supplier_name := NULL;
            var_price := NULL;
            var_count := 1;
            
          END LOOP;                            
        commit;              
      END;      
      var_from := var_to + 1;
      var_to := var_to + var_records_per_batch;
      var_count_batch := var_count_batch + 1;      
  END LOOP;   
    
END;

