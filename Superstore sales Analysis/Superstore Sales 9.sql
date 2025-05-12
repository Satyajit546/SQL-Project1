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
