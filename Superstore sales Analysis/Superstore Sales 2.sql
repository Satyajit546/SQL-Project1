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
