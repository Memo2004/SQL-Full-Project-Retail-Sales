-- -- Data Cleaning
select*from sales_data
where
ï»¿transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or
cogs is null
or
total_sale is null
;

delete from sales_data
where
ï»¿transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or
cogs is null
or
total_sale is null
;


-- Data Exploration

-- How many sales we have?
select count(*) as total_sales from sales_data;
-- How many uniuque customers we have ?
select count( distinct customer_id)as uniuque_customers from sales_data;
-- what is category names ?
select distinct category from sales_data;



-- Data Analysis & Business Key Problems & Answers


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from sales_data
where sale_date= '2022-11-06';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *from sales_data
where
category='Clothing'
AND
year(sale_date)=2022
AND
month(sale_date)=11
AND
quantiy>=4
;

-- Write a SQL query to calculate the total sales (total_sale) for each category.

select category,
sum(total_sale)as net_sales,
count(*) as total_orders
 from sales_data
group by category ;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select category,avg(age) as avg_age from sales_data
where category='Beauty' 
group by 1;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *from sales_data
where total_sale>1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,
       gender,
       count(*) as total_trans
 from sales_data
 group by category,gender
 order by category,gender;
 
 -- Write a SQL query to calculate the average sales for each month.
 
select 
       extract(year from sale_date) as Year,
       extract(month from sale_date) as Month,
       avg(total_sale) as avg_sales
       from sales_data
       group by 1,2
       order by 1,2
       ;
       
-- Find out best selling month in each year

select 
         Year,Month,avg_sales
from
(select 
       extract(year from sale_date) as Year,
       extract(month from sale_date) as Month,
       avg(total_sale) as avg_sales,
       rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Ranking
       from sales_data
       group by 1,2
       
)as t1
where ranking=1;

--  Write a SQL query to find the top 5 customers based on the highest total sales 

 select customer_id,
 sum(total_sale)  as total_sales
 from sales_data
 group by 1
 order by 2 desc
 limit 5 ;
 
 -- Write a SQL query to find the number of unique customers who purchased items from each category.
 
 select category,count(distinct customer_id) as Cnt_unique_cs
 from sales_data
 group by 1;
 
 -- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
 
with Cte_hourly_sales as
( select*,
         case
         when extract(hour from sale_time)<12 then 'Morning'
         when extract(hour from sale_time) between 12 and 17 then 'Afternoon '
         else 'Evening'
         end as Shift
 from sales_data)
 select Shift,
 count(ï»¿transactions_id) Total_orders
 from Cte_hourly_sales
 group by Shift;
 