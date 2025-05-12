-- 11. Calculate customer lifetime value (total sales per customer) and rank them accordingly.


WITH CustomerSales AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Sales) AS Customer_Lifetime_Value
    FROM Superstore
    GROUP BY Customer_ID, Customer_Name
),
RankedCLV AS (
    SELECT *,
           RANK() OVER (ORDER BY Customer_Lifetime_Value DESC) AS CLV_Rank
    FROM CustomerSales
)
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Lifetime_Value,
    CLV_Rank
FROM RankedCLV
ORDER BY CLV_Rank;