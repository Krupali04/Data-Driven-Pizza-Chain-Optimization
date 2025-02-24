CREATE DATABASE pizza_db;

CREATE TABLE pizza_sales
(pizza_id int, 
order_id int, 
pizza_name_id varchar(50), 
quantity int, 
order_date date, 
order_time time, 
unit_price float, 
total_price float,
pizza_size varchar(50),
pizza_category varchar(50),
pizza_ingredients varchar(200),
pizza_name varchar(50)
);

SELECT * FROM pizza_sales;

-- KPI

-- Total Revenue
SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_sales;


-- Average Order Value
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS AVG_Order_Val
FROM pizza_sales;


-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold
FROM pizza_sales;


-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales;


-- Average Pizzas Per Order
SELECT SUM(quantity)/ COUNT(DISTINCT order_id) AS Avg_pizza_per_Order
FROM pizza_sales;


-- Chart Requirement


-- Hourly Trend for Total Pizzas Sold:
SELECT HOUR(order_time) AS Order_Hour, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY Order_Hour
ORDER BY Order_Hour;


-- Weekly Trend for Total Orders
SELECT WEEK(order_date,3) AS Week_number, YEAR(order_date) AS Order_Year, COUNT(DISTINCT order_id) as Total_orders
FROM pizza_sales
GROUP BY Week_number,Order_Year
ORDER BY Week_number,Order_Year;


-- Percentage of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100/ (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS Percentage_of_sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Percentage_of_sales DESC;

-- Percentage of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales,CAST(SUM(total_price) * 100/ (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS Percentage_of_sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_of_sales DESC;


-- Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS Total_Pizza_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Pizza_sold DESC;


-- Top 5 Best Sellers by Revenue
SELECT pizza_name,SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue DESC
LIMIT 5;


-- Top 5 Best Sellers by Total_quantity
SELECT pizza_name,SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity DESC
LIMIT 5;


-- Top 5 Best Sellers by Total_Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_order DESC
LIMIT 5;


-- Bottom 5 Best Sellers by Revenue
SELECT pizza_name,SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue 
LIMIT 5;


-- Bottom 5 Best Sellers by Total_quantity
SELECT pizza_name,SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity 
LIMIT 5;


-- Bottom 5 Best Sellers by Total_Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_order 
LIMIT 5;

-- Rolling 7-Day Average of Total Revenue
SELECT 
    order_date, 
    SUM(total_price) AS Daily_Revenue,
    AVG(SUM(total_price)) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_7_Day_Avg_Revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date;

-- Year-over-Year (YoY) Comparison of Sales Revenue
SELECT 
    pizza_category, 
    YEAR(order_date) AS Order_Year,
    SUM(total_price) AS Total_Sales,
    LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date)) AS Previous_Year_Sales,
    (SUM(total_price) - LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date))) / 
    LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date)) * 100 AS YoY_Growth_Percentage
FROM pizza_sales
GROUP BY pizza_category, YEAR(order_date)
ORDER BY pizza_category, Order_Year;

-- Customer Retention Rate (Repeat Customers)
SELECT 
    pizza_category, 
    YEAR(order_date) AS Order_Year,
    SUM(total_price) AS Total_Sales,
    LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date)) AS Previous_Year_Sales,
    (SUM(total_price) - LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date))) / 
    LAG(SUM(total_price), 1) OVER (PARTITION BY pizza_category ORDER BY YEAR(order_date)) * 100 AS YoY_Growth_Percentage
FROM pizza_sales
GROUP BY pizza_category, YEAR(order_date)
ORDER BY pizza_category, Order_Year;
