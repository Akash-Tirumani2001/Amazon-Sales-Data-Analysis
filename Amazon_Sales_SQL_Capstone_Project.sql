CREATE DATABASE AmazonSales;
USE AmazonSales;

CREATE TABLE Amazon_sales_data (
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6,4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT(11,9) NOT NULL,
    gross_income DECIMAL(10, 2) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
);

-- Add Feature Engineered Columns--
 -- 1.Add timeofday Column-- 
 
ALTER TABLE amazon_sales_data 
ADD COLUMN timeofday VARCHAR(20);

UPDATE amazon_sales_data
SET timeofday = CASE 
    WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END;
-- 2.Add dayname Column-- 
ALTER TABLE sales_data 
ADD COLUMN dayname VARCHAR(10);

UPDATE sales_data
SET dayname = DAYNAME(date);

-- Add monthname Column-- 
ALTER TABLE sales_data 
ADD COLUMN monthname VARCHAR(10);

UPDATE sales_data
SET monthname = MONTHNAME(date);


--  Exploratory Data Analysis (EDA)--

-- 1.What is the count of distinct cities in the dataset?-- 
SELECT COUNT(DISTINCT product_line) AS distinct_product_lines
FROM Amazon_sales_data;

-- 2.For each branch, what is the corresponding city?-- 
SELECT DISTINCT branch, city
FROM Amazon_sales_data
ORDER BY branch;

-- 3.What is the count of distinct product lines in the dataset?-- 
Select Count(Distinct Product_line) as  distinct_product_line_count 
From Amazon_Sales_Data;

-- 4.Which payment method occurs most frequently?-- 
SELECT payment_method, COUNT(*) AS method_count
FROM Amazon_sales_data
GROUP BY payment_method
ORDER BY method_count DESC
LIMIT 1;
-- -5.hich product line has the highest sales?-- 
Select Product_line,Sum(Total) as Total_Sales
 From Amazon_sales_data
Group By Product_line
 Order by Total_Sales Desc Limit 1;

-- 6.How much revenue is generated each month?-- 
SELECT 
  MONTHNAME(date) AS month,
  SUM(total) AS monthly_revenue
FROM Amazon_sales_data
GROUP BY month
ORDER BY STR_TO_DATE(month, '%M');


-- 7.In which month did the cost of goods sold reach its peak?-- 
SELECT 
  MONTHNAME(date) AS month,
  SUM(cogs) AS total_cogs
FROM Amazon_sales_data
GROUP BY month
ORDER BY total_cogs DESC
LIMIT 1;

-- 8.Which product line generated the highest revenue-- 
SELECT 
  product_line, 
  SUM(total) AS total_revenue
FROM Amazon_sales_data
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- 9.In which city was the highest revenue recorded?-- 
SELECT 
  city, 
  SUM(total) AS total_revenue
FROM Amazon_sales_data
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- 10 Which product line incurred the highest Value Added Tax?-- 
SELECT 
  product_line, 
  SUM(vat) AS total_vat
FROM Amazon_sales_data
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
-- Step 1: Calculate average sales across all product lines
SELECT AVG(total_sales) AS avg_sales
FROM (
    SELECT product_line, SUM(total) AS total_sales
    FROM Amazon_sales_Data
    GROUP BY product_line
) AS product_sales;

-- Step 2: Use the average in a CASE statement
SELECT 
product_line, 
SUM(total) AS total_sales,
    CASE 
        WHEN SUM(total) > (
		SELECT AVG(total_sales)
            FROM (
                SELECT product_line, SUM(total) AS total_sales
                FROM Amazon_sales_Data
                GROUP BY product_line
            ) AS avg_calc
        ) THEN 'Good'
        ELSE 'Bad'
    END AS performance
FROM Amazon_sales_Data
GROUP BY product_line; 

-- 12 Identify the branch that exceeded the average number of products sold.-- 
SELECT 
    branch,SUM(quantity) AS total_products_sold
FROM Amazon_sales_Data
GROUP BY branch
HAVING SUM(quantity) > (
    SELECT AVG(total_quantity)
    FROM (
        SELECT branch, SUM(quantity) AS total_quantity
        FROM Amazon_sales_Data
        GROUP BY branch
    ) AS branch_totals
);

-- 13. Which product line is most frequently associated with each gender?-- 
SELECT gender, product_line, total_count
FROM (
    SELECT gender, product_line,
	COUNT(*) AS total_count,
	ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rn
    FROM Amazon_Sales_Data
    GROUP BY gender, product_line
) AS ranked
WHERE rn = 1;

-- 14.Calculate the average rating for each product line.--
Select Product_line ,Round(Avg( Rating),2) As Avg_rating From Amazon_Sales_Data
Group By Product_Line Order BY Avg_Rating; 

-- 15.Count the sales occurrences for each time of day on every weekday.-- 
SELECT
    dayname,
    timeofday,
    COUNT(*) AS sales_count
FROM
   Amazon_Sales_Data
GROUP BY
    dayname, timeofday
ORDER BY
    FIELD(dayname, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    FIELD(timeofday, 'Morning', 'Afternoon', 'Evening');
    
-- 16.Identify the customer type contributing the highest revenue.--
Select Customer_Type ,Sum( Total) AS highest_revenue
From Amazon_Sales_Data 
Group By Customer_TyPE
Order By highest_revenue DESC Limit 1;

-- 17.Determine the city with the highest VAT percentage.-- 
Select City , Round(Avg(VAT), 4) As Avg_Vat
 From Amazon_sales_Data
Group By City Order By Avg_Vat DESC 
Limit 1;

 -- 19.What is the count of distinct customer types in the dataset?-- 
Select count(Distinct Customer_Type) AS
 Distinct_Customers From Amazon_Sales_Data;
 
 -- 20.What is the count of distinct payment methods in the dataset?-- 
 Select Count(Distinct Payment_Method) As Distinct_Payment_Methods
 From Amazon_Sales_Data;
 
-- 21.Which customer type occurs most frequently?--
Select Customer_Type, Count(*) As count 
From Amazon_Sales_Data
Group By Customer_Type
Order By count Desc Limit 1;

-- 22.Identify the customer type with the highest purchase frequency.--
SELECT customer_type, COUNT(*) AS purchase_frequency
FROM Amazon_Sales_Data
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;

-- 23.Determine the predominant gender among customers.
SELECT gender, COUNT(*) AS gender_count
FROM Amazon_Sales_Data
GROUP BY gender
ORDER BY gender_count DESC	
LIMIT 1;

-- 24.Examine the distribution of genders within each branch.--
SELECT branch,gender, COUNT(*) AS count
FROM Amazon_Sales_Data
GROUP BY branch, gender
ORDER BY branch, gender;

-- 25.Identify the time of day when customers provide the most ratings.-- 
SELECT timeofday, COUNT(rating) AS rating_count
FROM  Amazon_Sales_Data
GROUP BY timeofday
ORDER BY rating_count DESC
LIMIT 1;

-- 26.Determine the time of day with the highest customer ratings for each branch.-- 
SELECT branch,timeofday, avg_rating
FROM (
    SELECT branch,timeofday,
        ROUND(AVG(rating), 2) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn
    FROM Amazon_Sales_DATA
    GROUP BY branch, timeofday
) AS ranked
WHERE rn = 1;

-- 27.Identify the day of the week with the highest average ratings.-- 
SELECT dayname, ROUND(AVG(rating), 2) AS avg_rating
FROM Amazon_Sales_DATA
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;

-- 28.Determine the day of the week with the highest average ratings for each branch.-- 
SELECT branch, dayname, avg_rating
FROM (
    SELECT 
        branch,
        dayname,
        ROUND(AVG(rating), 2) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn
    FROM amazon_sales_data
    GROUP BY branch, dayname
) AS ranked
WHERE rn = 1;





