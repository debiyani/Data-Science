/*
sub-query
--------------------------
1. Single Row Subquery 
	-If inner query provides with single row and single column data.
	-Comparision operator

2. Multi Row Subquery
	-If inner query provides with multiple row and single column data.
	-In(for discrete or categorical data), Any(for continuous data), All(for continuous data)

3. Correlated Subquery
	-It is also used with multi row subquery.
	-If required use Exists(exists- mainly used for store procedure to check if a data exists).

Syntax
---------------------------
select * from table_name where col_name = (	--Outer Query
	select col_name from table_name where col_name = data --Inner Query
	);
*/

--Single Row Subquery
--Find all order item details whose list price is less than average list price.
select * from sales.order_items where list_price <(
	select AVG(list_price) from sales.order_items
	);

--Find the second highest list price from order items.
select * from sales.order_items where list_price = (
	select max(list_price) from sales.order_items where list_price<(
		select max(list_price) from sales.order_items
	)
);

--Find 3rd day order from customer orders.
select * from sales.orders where order_date=(
	select min(order_date) from sales.orders where order_date>(
		select min(order_date) from sales.orders where order_date>(
			select min(order_date) from sales.orders)
			)
);

--Multi Row Subquery
--Find all the orders whose status is rejected or pending using subquery.
select * from sales.orders where order_status in(
select order_status from sales.orders where order_status in (1,3)
);

--subquery is faster as it is default distinct so only gives unique values without using distinct
----Find all the customer details whose status is rejected or pending using subquery.
select
	customer_id, first_name, last_name, email, state, street from sales.customers
where customer_id in (
	select customer_id from sales.orders where order_status in(1,3)
);