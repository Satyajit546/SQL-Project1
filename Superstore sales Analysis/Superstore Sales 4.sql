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
