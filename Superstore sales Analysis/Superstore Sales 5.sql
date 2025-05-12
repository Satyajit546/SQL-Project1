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