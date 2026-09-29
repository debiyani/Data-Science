/*
1. Row_Number() -> To give  each row unique identifying value, Find and Remove duplicate data
2. Rank() -> Ranking data -> Skips row number
3. Dense_Rank() -> Ranking dat -> doesn't skip row number -> used to find nth highest data
4. NTile(num) -> divides data
5. Lead(col_name, offset(opt..)) -> Next value
6. Lag(col_name, offset(opt..)) -> Previous value
7. Running Sum -> Sum(col_name)
8. Moving Average -> Average(col_name)
*/
select 
	*
from FraudDatabase.dbo.[Fraud Detection Dataset];

select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
	Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
	ROW_NUMBER() OVER(order by Transaction_Amount desc)
from FraudDatabase.dbo.[Fraud Detection Dataset];

select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
	Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
	ROW_NUMBER() OVER(partition by Time_of_Transaction order by Transaction_Amount desc)
from FraudDatabase.dbo.[Fraud Detection Dataset];

--To find duplicates.
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
	Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
	ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc)
from FraudDatabase.dbo.[Fraud Detection Dataset];

--Remove duplicate data
--Remove whose row number is more than 1
with fraud_duplicate_data as(
	select 
		Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
		Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
		ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc) as row_num
	from FraudDatabase.dbo.[Fraud Detection Dataset]
)
delete from fraud_duplicate_data where row_num>1;

--RANK
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	RANK() OVER(order by list_price) as rank_num
from BikeStores.production.products;

--partition in rank
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	RANK() OVER(partition by model_year order by list_price) as rank_num
from BikeStores.production.products;


--DENSE RANK
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	DENSE_RANK() OVER(order by list_price) as dense_rank_num
from BikeStores.production.products;

--find 3rd highest using dense rank
select * from(
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		DENSE_RANK() OVER(partition by model_year order by list_price) as dense_rank_num
	from BikeStores.production.products
) as data
where dense_rank_num = 3;

--NIile
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	NTile(10) OVER(order by list_price) as rank_num
from BikeStores.production.products;

--LEAD
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
	Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
	ROW_NUMBER() OVER(partition by Time_of_Transaction order by Transaction_Amount desc),
	LEAD(Payment_Method,1) Over(order by Transaction_Amount) as next_pay_method
from FraudDatabase.dbo.[Fraud Detection Dataset];

--LAG
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction, Device_Used, Location,
	Previous_Fraudulent_Transactions, Account_Age, Number_of_Transactions_Last_24H, Payment_Method,Fraudulent,
	ROW_NUMBER() OVER(partition by Time_of_Transaction order by Transaction_Amount desc),
	LAG(Payment_Method,1) Over(order by Transaction_Amount) as prev_pay_method
from FraudDatabase.dbo.[Fraud Detection Dataset];

--Running Sum
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	SUM(list_price) OVER(partition by  model_year order by list_price) as running_sum
from BikeStores.production.products;

--Moving Average
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	AVG(list_price) OVER(partition by  model_year order by list_price) as moving_year
from BikeStores.production.products;

select * from(
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		sum(list_price) OVER(order by list_price) as runnning_sum
	from BikeStores.production.products
	) as data
where model_year in (2016,2017) order by model_year asc;