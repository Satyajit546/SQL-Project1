-- Analyzing Sales Performance by Region and Category
-- 1.Analyze sales performance by category across different regions.

SELECT 
    Region,
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;
