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


