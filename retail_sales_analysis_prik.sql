-- 1.Database Setup

CREATE DATABASE p1_retail_db;


CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--2. Data Exploration & Cleaning

--Record Count: Determine the total number of records in the dataset.
SELECT * FROM retail_sales;

--Customer Count: Find out how many unique customers are in the dataset.
SELECT COUNT(distinct customer_id) from retail_sales;

--Category Count: Identify all unique product categories in the dataset.
SELECT count(distinct category) from retail_sales;

--Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT * from retail_sales
WHERE 
sale_date is NULL
OR 
 sale_time	is NULL
OR
 customer_id is NULL
OR
 gender IS NULL
OR
 age is NULL
OR
 category is null
OR
 quantity IS NULL
OR
 price_per_unit IS NULL
OR
 cogs IS NULL
OR
 total_sale IS NULL;

DELETE FROM retail_sales
WHERE
sale_date is NULL
OR 
 sale_time	is NULL
OR
 customer_id is NULL
OR
 gender IS NULL
OR
 age is NULL
OR
 category is null
OR
 quantity IS NULL
OR
 price_per_unit IS NULL
OR
 cogs IS NULL
OR
 total_sale IS NULL;

--3. Data Analysis & Findings
--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * from retail_sales
where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
 SELECT * from retail_sales 
 where
 category = 'Clothing'
 AND
 quantity >= 4
 AND
 to_char(sale_date,'YYYY-MM')= '2022-11';

 --Write a SQL query to calculate the total sales (total_sale) for each category.:
 SELECT category,sum(total_sale) as net_sale, COUNT(*) as total_orders
 from retail_sales group by 1;

 --Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(avg(age),2) as average_age from retail_sales
where category='Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * from retail_sales where total_sale>1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category,gender,count(*)as total_transactions from retail_sales group by 1,2 order by 1,2;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--**Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT customer_id,SUM(total_sale) as total_sales from retail_sales group by 1
order by total_sales desc
limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT shift,count(*) as total_orders
from(SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
) as h1 group by shift;

 

