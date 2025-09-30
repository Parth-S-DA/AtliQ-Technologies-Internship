-- Question 1: How many unique customers are in the city of 'Surat'?
SELECT 
	count(distinct customer_name) as distinct_customers
FROM dim_customers
where city = "Surat"

-- Question 2: What are the minimum and maximum order quantities for each product?

SELECT p.product_name, 
min(o.order_qty) as min,
max(o.order_qty) as max
FROM gdb080.dim_products p
JOIN fact_order_lines o 
on p.product_id= o.product_id
group by product_name

-- Question 3: Generate a report with month_name and number of unfullfilled_orders(i.e order_qty - delivery_qty) in that respective month.

SELECT 
monthname(order_placement_date) as mon,
sum(order_qty-delivery_qty) as unfulfiled_orders
FROM gdb080.fact_order_lines
GROUP BY mon
ORDER BY unfulfiled_orders desc


-- Question 4: What is the percentage breakdown of order_qty by category?  
-- The final output includes the following fields:
--   - category
--   - order_qty_pct.

SELECT p.category, 
	round(sum(o.order_qty)/(select sum(order_qty) from fact_order_lines)*100,2) as pct

FROM gdb080.dim_products p
JOIN fact_order_lines o 
on p.product_id= o.product_id
GROUP BY p.category
ORDER BY pct DESC




-- Question 5: Generate a report that includes the customer ID, customer name, ontime_target_pct, and percentage_category. 

-- The percentage category is divided into four types: 'Above 90' if the  ontime_target_pct is greater than 90, 'Above 80' if it is greater than 80, 'Above 70' if it is greater than 70, and 'Less than 70' for all other cases.


SELECT t.customer_id, c.customer_name, t.ontime_target_pct,
	CASE 
		WHEN ontime_target_pct> 90 THEN "Above 90"
        WHEN ontime_target_pct> 80 THEN "Above 80"
        WHEN ontime_target_pct> 70 THEN "Above 70"
        ELSE "Below 70" 
	END as category_pct

FROM gdb080.dim_targets_orders t
JOIN dim_customers c
on t.customer_id=c.customer_id



-- Question 6: Generate a report that lists all the product categories, along with the product names and total count of products in each category.
-- The output should have three columns: 
-- category, products, and product_count.

SELECT category, GROUP_CONCAT(product_name) as products, count(*) as cnt
FROM gdb080.dim_products
GROUP BY category


-- Question 7: What are the top 3 most demanded products in the 'Dairy' category, and their respective order quantity in millions? 
-- The final output includes the following fields:
--              - product name
--              - order_qty_mln. 


SELECT p.product_name, round(sum(f.order_qty)/1000000,2) as qty_mln

FROM gdb080.fact_order_lines f
JOIN dim_products p
on f.product_id= p.product_id
WHERE p.category='dairy'
GROUP BY product_name
ORDER BY qty_mln DESC 
LIMIT 3


-- Question 8: Calculate the OTIF % for a customer named Vijay Stores
-- The final output should contain these fields,
--                  customer_name
--                  OTIF_percentage

SELECT c.customer_name, 
	round((sum(otif)/count(*)*100),2) as otif_pct

FROM gdb080.fact_orders_aggregate f
JOIN dim_customers c
on f.customer_id= c.customer_id
where c.customer_name = 'Vijay stores'


-- Question 9: What is the percentage of 'in full' for each product and which product has the highest percentage, based on the data from the 'fact_order_lines' and 'dim_products' tables?


SELECT p.product_name, round(sum(f.In_Full)*100/count(*),2) as pct

FROM gdb080.fact_order_lines f
JOIN dim_products p
on f.product_id= p.product_id
GROUP BY p.product_name
ORDER BY pct DESC 




