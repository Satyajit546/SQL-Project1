-- Daily Forecast Accuracy problem Statement:
-- 1. Calculate the daily forecast error for each product and return only days with major deviations.

WITH Forecast_Error AS (
    SELECT 
        Date,
        Product_ID,
        Round(ABS(Demand_Forecast - Units_Sold),2) AS Error,
        Units_Sold,
        Demand_Forecast
    FROM retail_inventory
)
SELECT *
FROM Forecast_Error
WHERE Error > 10

-- Running Total of Units Sold per Product:
-- 2.Track the running total of units sold for each product over time.

SELECT 
	Date,
    Product_ID,
    Units_Sold,
    SUM(Units_Sold) OVER (PARTITION BY Product_ID ORDER BY Date) AS Running_Total_Units_Sold
FROM retail_inventory;

-- Identify Restocking Needs Based on Sales Trend:
-- 3.Identify products whose average 7-day sales exceed inventory level, signaling restocking needs.

WITH Rolling_Avg_Sales AS (
    SELECT 
        Date,
        Product_ID,
        Inventory_Level,
        AVG(Units_Sold) OVER (PARTITION BY Product_ID ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Avg_7Day_Sales
    FROM retail_inventory
)
SELECT *
FROM Rolling_Avg_Sales
WHERE Avg_7Day_Sales > Inventory_Level;


-- Demand Forecasting Problem Statement:
-- 4. What is the average forecast error per product and region?

SELECT 
  Product_ID,
  Region,
  Round(AVG(ABS(Demand_Forecast - Units_Sold)),2) AS Avg_Forecast_Error
FROM retail_inventory
GROUP BY Product_ID, Region;

-- Demand Forecasting Problem Statement:
-- 5.Which weather conditions lead to the highest variance in demand?

SELECT 
  Weather_Condition,
  Round(STDDEV(Units_Sold),2) AS Demand_Variability
FROM retail_inventory
GROUP BY Weather_Condition;

-- Dynamic Pricing Problem Statement:
-- 6.During which holidays or promotions did demand spike significantly?

SELECT 
  Holiday_Promotion,
  Category,
  Round(AVG(Units_Sold),0) AS Avg_Units_Sold
FROM retail_inventory
WHERE Holiday_Promotion IS NOT NULL
GROUP BY Holiday_Promotion, Category;

-- Dynamic Pricing Problem Statement:
-- 7.Can we find high-demand products under specific weather or regional conditions?

SELECT 
  Product_ID,
  Region,
  Weather_Condition,
  Round(AVG(Units_Sold),0) AS Avg_Sales
FROM retail_inventory
GROUP BY Product_ID, Region, Weather_Condition
ORDER BY Avg_Sales DESC;

-- Inventory Optimization Problem Statement:
-- 8.Which products frequently had stockouts (units sold equal to or greater than inventory)?

SELECT 
  Date,
  Store_ID,
  Product_ID,
  Inventory_Level,
  Units_Sold
FROM retail_inventory
WHERE Units_Sold >= Inventory_Level;

-- Inventory Optimization Problem Statement:
-- 6.How often does actual demand exceed forecast, leading to understock?

SELECT 
  Product_ID,
  COUNT(*) AS Understock_Days
FROM retail_inventory
WHERE Units_Sold > Demand_Forecast
GROUP BY Product_ID
ORDER BY Understock_Days DESC;

-- Impact of Discounts on Demand and Revenue:
-- 7.How do different discount levels influence product demand and revenue across categories?

SELECT 
    Category,
    Discount,
    Round(AVG(Units_Sold),2) AS Avg_Demand,
    Round(AVG(Price * Units_Sold),2) AS Avg_Revenue
FROM retail_inventory
GROUP BY Category, Discount
ORDER BY Category, Discount;

-- Identify Optimal Price Ranges Based on Revenue:
-- 8.What price ranges generate the highest revenue per product category?

SELECT 
    Category,
    CASE
        WHEN Price < 10 THEN 'Low'
        WHEN Price BETWEEN 10 AND 50 THEN 'Mid'
        WHEN Price > 50 THEN 'High'
    END AS Price_Range,
    Round(AVG(Price * Units_Sold),0) AS Avg_Revenue
FROM retail_inventory
GROUP BY Category, Price_Range
ORDER BY Avg_Revenue DESC;

-- Pricing Efficiency vs Competitor Pricing Problem Statement:
-- 9.Are we pricing products competitively?
SELECT 
    Product_ID,
    ROUND(AVG(Price), 2) AS Avg_Our_Price,
    ROUND(AVG(Competitor_Pricing), 2) AS Avg_Competitor_Price,
    ROUND(AVG(Price) - AVG(Competitor_Pricing), 2) AS Price_Difference
FROM retail_inventory
GROUP BY Product_ID
ORDER BY Price_Difference DESC;


-- Pricing Efficiency vs Competitor Pricing Problem Statement:
-- 10.Are we losing sales when our prices exceed those of competitors?

SELECT 
    CASE 
        WHEN Price > Competitor_Pricing THEN 'Above Competitor'
        WHEN Price < Competitor_Pricing THEN 'Below Competitor'
        ELSE 'Equal to Competitor'
    END AS Price_Comparison,
    COUNT(*) AS Transactions,
    SUM(Units_Sold) AS Total_Units_Sold,
    ROUND(AVG(Units_Sold), 2) AS Avg_Units_Sold
FROM retail_inventory
GROUP BY Price_Comparison;

-- Pricing Efficiency vs Competitor Pricing Problem Statement:
-- 11.Which categories are most affected by higher pricing?

SELECT 
    Category,
    CASE 
        WHEN Price > Competitor_Pricing THEN 'Above Competitor'
        ELSE 'At or Below Competitor'
    END AS Price_Position,
    ROUND(AVG(Units_Sold), 2) AS Avg_Units_Sold
FROM retail_inventory
GROUP BY Category, Price_Position
ORDER BY Category, Price_Position;

-- Revenue Lost Due to Underpricing (High Demand, Low Price):
-- 12.Are we underpricing high-demand products, resulting in lost revenue opportunities?

SELECT 
    Product_ID,
    Round(AVG(Units_Sold),0) AS Avg_Units_Sold,
    Round(AVG(Price),2) AS Avg_Price,
    Round(AVG(Price * Units_Sold),0) AS Avg_Revenue,
    COUNT(*) AS High_Demand_Days
FROM retail_inventory
WHERE Units_Sold > Demand_Forecast AND Price < Competitor_Pricing
GROUP BY Product_ID
ORDER BY Avg_Revenue DESC;

-- Forecasting Revenue Based on Price Sensitivity:
-- 13.How does revenue fluctuate when prices are adjusted up or down relative to demand?

SELECT 
    Product_ID,
    ROUND(Price, 0) AS Rounded_Price,
    Round(AVG(Units_Sold),0) AS Avg_Units_Sold,
    Round(AVG(Price * Units_Sold),2) AS Avg_Revenue
FROM retail_inventory
GROUP BY Product_ID, Rounded_Price
ORDER BY Product_ID, Rounded_Price;











