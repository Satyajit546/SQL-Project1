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
