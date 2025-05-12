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
