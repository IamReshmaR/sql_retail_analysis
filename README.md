
# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_db`

This project focuses on designing and analyzing a retail sales database using SQL to uncover actionable insights into sales trends, customer demographics, and product performance. By developing advanced SQL queries, key performance indicators (KPIs) such as total sales by category, average monthly sales, and top customer contributions were calculated. The analysis identified peak sales periods, high-value transactions, and customer spending patterns, providing data-driven recommendations for optimizing retail strategies.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieving all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Retrieving all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
```

3. **Calculation of the total sales (total_sale) for each category.**:
```sql
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;
```

4. **Finding the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. ** Viewing all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
```

6. **Total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1
```

7. **Calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_cs
FROM retail_sales
GROUP BY category
```

10. **Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset reflects a diverse customer base across various age groups, with sales spanning categories like Clothing and Beauty.
- **High-Value Transactions**: Multiple transactions exceed a total sale value of 1000, highlighting instances of premium purchases.
- **Sales Trends**: A monthly sales analysis reveals fluctuations, providing insights into peak seasons.
- **Customer Insights**: The analysis uncovers top-spending customers and identifies the most popular product categories.
## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

