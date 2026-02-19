SELECT * FROM sqlanalyst.customers;
-- 1 customers from mumbai
select * from customers
where city = 'mumbai';

-- 2 count no of customers
select count(*) as no_of_customers
from customers;

-- 3 display all city
select distinct city
from customers;

-- 4 display price greater then 3000
select * from products
where price > 3000;

-- 5 count total orders
select count(*) as total_orders
from orders;

-- 6 display max & min price
select max(price) as max_price,min(price) as min_price
from products ;

-- 7 top 10 products
select *
from products
order by price desc
limit 10;

-- 8 display only IT department
select * from employees 
where department = 'IT';

-- 9 avg of salary
select avg(salary) as avg_salary
from employees;

-- 10 high paid employees
select * from employees
order by salary desc;

-- 11 sum of amount
select sum(total_amount) as sales_amount
from orders;

-- 12 count order per customers
select customer_id,count(*) as total_orders
from orders
group by customer_id;

-- 13 product wise sales
select p.product_name,sum(o.total_amount) as revenue
from orders o join products p on o.product_id = p.product_id
group by p.product_name;

-- 14 customers mote then 5 orders
select customer_id,count(*) as total_orders
from orders
group by customer_id
having count(*) > 5;

-- 15 top 5 seeling products
select product_id,sum(quantity) as best_selling
from orders
group by product_id
order by best_selling desc
limit 5;

-- 16 monthly sales
select month(order_date) as months,sum(total_amount) as revenue
from orders
group by month(order_date)
order by months ;

-- 17 orders in last 30 days
SELECT *
FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
select * from orders
where order_date >= date_sub(curdate(),interval 30 day);

-- 18 emp hire after 2023
select * from employees
where year(hire_date) > 2023;

-- 19 dept wise avg salary
select department, avg(salary) as avg_salary
from employees
group by department;

-- 20 second higest salary
select * from employees
order by salary desc
limit 1
offset 1;

select max(salary) as second_salary
from employees
where salary < (select max(salary) from employees);

-- 21 customer with orders
select c.customer_name,o.order_id
from customers c left join orders o on c.customer_id = o.customer_id;

-- 22 product name with total sales
select p.product_name,sum(o.total_amount) as total_sales
from products p join orders o on p.product_id = o.product_id
group by p.product_name;

-- 23 customers with no orders
select c.*
from customers c left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- 24 product never sold
select p.* 
from products p left join orders o on p.product_id = o.product_id
where o.order_id is null;

-- 25 customer who spend most amount
select c.customer_name,sum(o.total_amount) as revenue
from customers c left join orders o on c.customer_id = o.customer_id
group by c.customer_name
order by revenue desc
limit 3;

-- 26 category wise revenue
select p.category,sum(o.total_amount) as revenue
from products p join orders o on p.product_id = o.product_id
group by p.category;

-- 27 full orders details
select c.customer_name,p.product_name,o.order_id,o.quantity,o.total_amount
from customers c join orders o on c.customer_id = o.customer_id 
join products p on p.product_id = o.product_id;

-- 28 rank employees by salary
select employee_name,salary,
dense_rank() over(order by salary ) as rnk
from employees;

-- 29 running total of sales
select total_amount,order_date,
sum(total_amount) over(order by order_date desc) as running_total
from orders;

-- 30 top 3 customers by spending(type 1)
select *
from(select c.customer_id, c.customer_name, sum(o.total_amount) as revenue,
      dense_rank() over( order by sum(o.total_amount) desc) as rnk
      from orders o join customers c on o.customer_id = c.customer_id
      group by c.customer_id,c.customer_name)t     
where rnk <=3;
-- 3 products(type 2)
select * 
from ( select product_id,product_name , sum(price) as Total_price,
rank() over(order by sum(price) desc) as rnk
from products
group by product_id,product_name)t
where rnk <=2;

-- with out window function top 3 customers(type 3)
select c.customer_id,c.customer_name,sum(o.total_amount) as revenue
from customers c join orders o on c.customer_id = o. customer_id
group by c.customer_id,c.customer_name
order by revenue desc
limit 3;

-- 31 duplicate cites
select city,count(*) as city_count
from customers
group by city
having count(*) >1;

-- 32 higest order values
select * from orders
order by total_amount desc
limit 1;

-- 33 day with higest sales
select order_date,round(sum(total_amount),2) as total_sale
from orders
group by order_date
order by sum(total_amount) desc
limit 2;

-- 34 % contribution of product
select product_id,sum(total_amount) as revenue,
sum(total_amount) * 100.0 / sum(sum(total_amount)) over() as percentage
from orders
group by product_id;

-- 35 month over month sales
select months,sales,sales-lag(sales) over(order by months) as growth
from(
select month(order_date) as months,
sum(total_amount) as sales
from orders 
group by month(order_date)
)t