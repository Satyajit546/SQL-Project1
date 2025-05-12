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



