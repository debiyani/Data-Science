/*
set statistics time on;
select * from sales.customers;
set statistics time off;

set statistics time on; --used to check time of execution
set nocount on; --to disable showing no. of rows affected
select customer_id, first_name, last_name, phone, email, street, city, state, zip_code
from sales.customers;
set statistics time off;
*/

--Concat Function and concatenation operator (+)

select concat(first_name,' ', last_name) -- can be used to concat string and integer
as customer_name from sales.customers;

select (first_name + ' ' + last_name) as customer_name -- can't be used to concat string and integer
from sales.customers;

-- Substring, left, right
-- Extracting specific range of letters from text
/*
substring(col_name, start_value, number_of_values_to_extract) --start value is len

left(col_name, no_of_values_to_extract)
right(col_name, no_of_values_to_extract)
*/

select first_name, 
substring(first_name, 2, 3)as extracted_letters,
left(first_name, 3) as first_3,
right(first_name,3) as last_3
from sales.customers;

select CONCAT(customer_id, '-',SUBSTRING(first_name,2,3),'-',right(last_name,2)) 
as unique_customer_id
from sales.customers;

-- Date Functions
select order_date, YEAR(order_date) as y_date, MONTH(order_date) as m_date, DAY(order_date) as o_date,
DATEPART(WEEK, order_date) as week_number,
DATEPART(WEEKDAY,order_date) as weekday_num,
DATEPART(QUARTER, order_date) as quarter_num,
DATENAME(MONTH,order_date) as m_name,
DATENAME(WEEKDAY, order_date) as d_name,
FORMAT(order_date, 'MMMM') as m_name,--extracts full month name
FORMAT(order_date, 'MMM') as m_name_half,--extracts half month name
FORMAT(order_date, 'MM') as m_num,--extracts month num only
FORMAT(order_date, 'dddd') as m_name,--extracts full day name
FORMAT(order_date, 'ddd') as m--extracts full day name
from sales.orders;

select order_date, required_date, shipped_date,
DATEDIFF(DAY, order_date, shipped_date) as day_diff
from sales.orders

select shipped_date, ISNULL(shipped_date, GETDATE()),
DATEDIFF(Day, order_date, ISNULL(shipped_date, GETDATE())) as day_diff -- filling null value
from sales.orders

-- Another method for filling null value using coalesce
select shipped_date, ISNULL(shipped_date, GETDATE()) as filled_date,
coalesce(shipped_date, getdate()) as date_info
from sales.orders


select order_date, required_date, isnull(shipped_date,getdate()) as shipped_date,
DATEDIFF(DAY, order_date, isnull(shipped_date, getdate())) as day_diff,
dateadd(day, 2, required_date) as date_added
from sales.orders

select order_date, required_date, isnull(shipped_date,getdate()) as shipped_date,
DATEDIFF(DAY, order_date, isnull(shipped_date, getdate())) as day_diff
from sales.orders

