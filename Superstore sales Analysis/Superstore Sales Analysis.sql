-- Analyzing Sales Performance by Region and Category
-- 1.Analyze sales performance by category across different regions.

SELECT 
    Region,
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;

-- Analyzing Sales Performance by Region and Category.
-- 2.Determine which category performs best in each region based on total sales and profit.

WITH RegionCategorySales AS (
    SELECT 
        Region,
        Category,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Region, Category
),
RankedSales AS (
    SELECT *,
        RANK() OVER (PARTITION BY Region ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM RegionCategorySales
)
SELECT 
    Region,
    Category,
    Total_Sales
FROM RankedSales
WHERE Sales_Rank = 1;

-- Customer Purchase Patterns Over Time
-- 3.Identify repeat customers and calculate the average time between their purchases.

WITH CustomerOrders AS (
    SELECT 
        Customer_ID, 
        COUNT(DISTINCT Order_ID) AS Order_Count
    FROM superstore
    GROUP BY Customer_ID
)
SELECT * 
FROM CustomerOrders
WHERE Order_Count > 1
ORDER BY Order_Count DESC;

-- Customer Purchase Patterns Over Time
-- 4.Evaluate how often customers return to place new orders and find customers with increasing order frequency over time.

WITH CustomerYearlyOrders AS (
    SELECT 
        Customer_ID,
        YEAR(STR_TO_DATE(Order_Date, '%d/%m/%Y')) AS Order_Year,
        COUNT(DISTINCT Order_ID) AS Orders_In_Year
    FROM superstore
    GROUP BY Customer_ID, Order_Year
),

--    get previous year's order count
CustomerGrowth AS (
    SELECT 
        Customer_ID,
        Order_Year,
        Orders_In_Year,
        LAG(Orders_In_Year) OVER (PARTITION BY Customer_ID ORDER BY Order_Year) AS Previous_Year_Orders
    FROM CustomerYearlyOrders
)

--  Select customers with increasing order frequency
SELECT 
    Customer_ID,
    Order_Year,
    Orders_In_Year,
    Previous_Year_Orders,
    (Orders_In_Year - Previous_Year_Orders) AS Growth
FROM CustomerGrowth
WHERE Previous_Year_Orders IS NOT NULL
  AND Orders_In_Year > Previous_Year_Orders
ORDER BY Customer_ID, Order_Year;


-- Ranking Products by Popularity and Profit
-- 5.Rank products within each category based on sales volume and profitability. 

SELECT 
    Category,
    Product_Name,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore
GROUP BY Category, Product_Name
ORDER BY Category, Sales_Rank;


-- Ranking Products by Popularity and Profit
-- 6.Find the top 3 best-selling  products in each category.

WITH ProductSales AS (
    SELECT
        Category,
        "Product Name",
        ROUND(SUM(Sales),2) AS Total_Sales
    FROM Superstore
    GROUP BY Category, "Product Name"
),
RankedSales AS (
    SELECT *,
           RANK() OVER (PARTITION BY Category ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM ProductSales
)
SELECT 
    Category,
    "Product Name",
    Total_Sales
FROM RankedSales
WHERE Sales_Rank <= 3
ORDER BY Category, Sales_Rank;


-- Year-over-Year Sales Growth.
-- 7.calculate the year-over-year growth in sales and profit at a regional level.
WITH YearlySales AS (
    SELECT 
        Region,
        YEAR(STR_TO_DATE(Order_Date, '%d/%m/%Y')) AS Year,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY Region, Year
),
SalesGrowth AS (
    SELECT *,
        LAG(Total_Sales) OVER (PARTITION BY Region ORDER BY Year) AS Previous_Year_Sales,
        (Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Region ORDER BY Year)) * 100.0 / 
        LAG(Total_Sales) OVER (PARTITION BY Region ORDER BY Year) AS YoY_Growth_Percent
    FROM YearlySales
)
SELECT * FROM SalesGrowth;


-- Order Shipping Efficiency.
-- 8.to calculate shipping duration for each order. 

SELECT 
    Order_ID,
    Ship_Mode,
    DATEDIFF(STR_TO_DATE(Ship_Date, '%d/%m/%Y'), STR_TO_DATE(Order_Date, '%d/%m/%Y')) AS Shipping_Days
FROM superstore;

-- Average Shipping Days.
SELECT
    Region,
    Ship_Mode,
    ROUND(AVG(DATEDIFF(STR_TO_DATE(Ship_Date, '%d/%m/%Y'), STR_TO_DATE(Order_Date, '%d/%m/%Y')))) AS Avg_Shipping_Duration_Days
FROM Superstore
GROUP BY Region, Ship_Mode
ORDER BY Region, Ship_Mode;


-- Order Shipping Efficiency.
-- 9.Compute the average shipping time by shipping mode and identify delayed shipments compared to the average.

WITH AvgShipping AS (
    SELECT 
        Ship_Mode,
        AVG(DATEDIFF(STR_TO_DATE(Ship_Date, '%d/%m/%Y'), STR_TO_DATE(Order_Date, '%d/%m/%Y'))) AS Avg_Shipping_Days
    FROM superstore
    GROUP BY Ship_Mode
)

SELECT 
    s.Order_ID,
    s.Ship_Mode,
    STR_TO_DATE(s.Order_Date, '%d/%m/%Y') AS Order_Date,
    STR_TO_DATE(s.Ship_Date, '%d/%m/%Y') AS Ship_Date,
    DATEDIFF(STR_TO_DATE(s.Ship_Date, '%d/%m/%Y'), STR_TO_DATE(s.Order_Date, '%d/%m/%Y')) AS Shipping_Days,
    a.Avg_Shipping_Days,
    CASE 
        WHEN DATEDIFF(STR_TO_DATE(s.Ship_Date, '%d/%m/%Y'), STR_TO_DATE(s.Order_Date, '%d/%m/%Y')) > a.Avg_Shipping_Days 
        THEN 'Delayed'
        ELSE 'On Time'
    END AS Shipping_Status
FROM superstore s
JOIN AvgShipping a ON s.Ship_Mode = a.Ship_Mode;


-- Top Customers by Lifetime Value.
-- 10.Identify the top 10% of customers who contribute the most to the business.
-- Top 10 Customers by Total Sales.
SELECT 
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


-- 11. Calculate customer lifetime value (total sales per customer) and rank them accordingly.


WITH CustomerSales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Customer_Lifetime_Value
    FROM Superstore
    GROUP BY Customer_ID, Customer_Name
),
RankedCLV AS (
    SELECT *,
           RANK() OVER (ORDER BY Customer_Lifetime_Value DESC) AS CLV_Rank
    FROM CustomerSales
)
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Lifetime_Value,
    CLV_Rank
FROM RankedCLV
ORDER BY CLV_Rank;







