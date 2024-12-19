
-- Retail Sales Analysis --



USE retail_db;
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

-- Data Cleaning -- 
SELECT *
FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales;

-- Unique customer count --
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- unique category -- 
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


-- Data Exploration --

-- how many sale we have --
SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- How many customers we have? -- 
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- unique catrgories we have --
SELECT COUNT(DISTINCT category)
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;

-- BUSINESS QUESTIONS--

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05':
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
  
  -- 3. calculate the total sales (total_sale) for each category. --
  
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;


-- 4.find the average age of customers who purchased items from the 'Beauty' category. --
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5.find all transactions where the total_sale is greater than 1000. --
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
  
-- 6.find the total number of transactions (transaction_id) made by each gender in each category. --
SELECT category, gender, COUNT(*) AS total_trasactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- 7.calculate the average sale for each month. Find out best selling month in each year.--
WITH cte AS(
SELECT 
       EXTRACT(YEAR FROM sale_date) AS year,
	   EXTRACT(MONTH FROM sale_date) AS month,
       AVG(total_sale) AS avg_total_sales,
       RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rnk	
FROM retail_sales
GROUP BY 1,2
)

SELECT year, month, avg_total_sales
FROM cte
WHERE rnk = 1;

-- 8. find the top 5 customers based on the highest total sales . --
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 9.find the number of unique customers who purchased items from each category.--
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 10.create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) --
WITH cte AS(
SELECT 
      (CASE 
           WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
           WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
	  END) AS shift
FROM retail_sales
)
SELECT shift, 
       COUNT(*) AS total_orders
FROM cte
GROUP BY shift;

-- End of Peoject --


