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

--  Use window function to get previous year's order count
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
