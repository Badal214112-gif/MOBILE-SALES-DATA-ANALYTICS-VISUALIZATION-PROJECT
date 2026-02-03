create database mobile_sales_db;

-- ==========================
-- MOBILE SALES SQL ANALYSIS
-- ==========================

-- 1) Select Database
USE mobile_sales_db;

-- 2) Basic Checks
SHOW TABLES;

SELECT * FROM sales_data LIMIT 10;

DESCRIBE sales_data;

SELECT COUNT(*) AS total_rows FROM sales_data;

-- ==========================
-- 3) KPI QUERIES
-- ==========================

-- Total Sales
SELECT ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data;

-- Total Units Sold
SELECT SUM(`Units Sold`) AS total_units_sold
FROM sales_data;

-- Total Transactions
SELECT COUNT(*) AS total_transactions
FROM sales_data;

-- Average Price Per Unit
SELECT ROUND(AVG(`Price Per Unit`), 2) AS avg_price_per_unit
FROM sales_data;

-- Average Customer Rating
SELECT ROUND(AVG(`Customer Ratings`), 2) AS avg_customer_rating
FROM sales_data;

-- ==========================
-- 4) SALES ANALYTICS
-- ==========================

-- Total Sales by Brand
SELECT Brand, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY Brand
ORDER BY total_sales DESC;

-- Total Units Sold by City
SELECT City, SUM(`Units Sold`) AS total_units
FROM sales_data
GROUP BY City
ORDER BY total_units DESC;

-- Top 5 Mobile Models by Sales
SELECT `Mobile Model`, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY `Mobile Model`
ORDER BY total_sales DESC
LIMIT 5;

-- Payment Method wise Sales
SELECT `Payment Method`, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY `Payment Method`
ORDER BY total_sales DESC;

-- Rating Status Distribution
SELECT Rating_Status, COUNT(*) AS total_transactions
FROM sales_data
GROUP BY Rating_Status
ORDER BY total_transactions DESC;

-- ==========================
-- 5) TIME ANALYSIS
-- ==========================

-- Sales by Year
SELECT Year, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY Year
ORDER BY Year;

-- Sales by Month
SELECT Month, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY Month
ORDER BY Month;

-- Sales by Day Name
SELECT `Day Name`, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY `Day Name`
ORDER BY total_sales DESC;

-- ==========================
-- 6) EXTRA INSIGHTS
-- ==========================

-- City + Brand Sales (Top 10)
SELECT City, Brand, ROUND(SUM(Total_Sale), 2) AS total_sales
FROM sales_data
GROUP BY City, Brand
ORDER BY total_sales DESC
LIMIT 10;

-- Best Brand by Units Sold
SELECT Brand, SUM(`Units Sold`) AS total_units
FROM sales_data
GROUP BY Brand
ORDER BY total_units DESC;

-- Best Mobile Model by Units Sold
SELECT `Mobile Model`, SUM(`Units Sold`) AS total_units
FROM sales_data
GROUP BY `Mobile Model`
ORDER BY total_units DESC
LIMIT 10;
