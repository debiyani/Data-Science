-- Self join is also inner join
-- Find staff name and manager names.
select * from sales.staffs;
select
	concat(s1.first_name,' ',s1.last_name) as manager_name,
	concat(s2.first_name,' ',s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

select
	*
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

--Cross join- only theoritical concept/cartesian product
select * from sales.customers
cross join sales.orders;

select * from sales.customers sc
cross join sales.orders so
where (sc.customer_id=1 and so.customer_id=1)
order by 1 desc;--orders by 1st col descending order

-- Find total staffs, total orders and total customers managed by managers.
select
	*
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;

select
	concat(s1.first_name,' ',s1.last_name) as manager_name,
	count(distinct s2.staff_id) as total_staffs,
	count(distinct so.order_id) as total_orders,
	count(distinct sc.customer_id) as total_customers
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id
join sales.orders so
on s1.staff_id = so.staff_id
join sales.customers sc
on sc.customer_id = so.customer_id
group by concat(s1.first_name,' ',s1.last_name);

--Left join
select * from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;
--Right join
select * from sales.staffs s1
 right join sales.staffs s2
on s1.staff_id = s2.manager_id;
--Outer join
select * from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id;

--Natural join (uses inner join)(compares and fetches output and do not use cross join in background)
-- mainly used for sub queries
select * from sales.customers sc, sales.orders so
where sc.customer_id = so.customer_id;

select * from sales.customers sc, sales.orders so, sales.order_items soi
where sc.customer_id = so.customer_id
and so.order_id = soi.order_id;

select 
	sc.first_name+' '+sc.last_name as customer_name,
	COUNT(so.order_id) as total_orders
from sales.customers sc, sales.orders so
where sc.customer_id = so.customer_id
group by sc.first_name+' '+sc.last_name;
