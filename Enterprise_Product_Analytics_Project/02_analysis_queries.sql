USE enterprise_analytics;

-- Overall KPIs
SELECT ROUND(SUM(Revenue),2) Total_Revenue, ROUND(SUM(Profit),2) Total_Profit,
SUM(Quantity) Units_Sold, COUNT(DISTINCT Customer_ID) Unique_Customers,
COUNT(DISTINCT Order_ID) Total_Orders FROM sales_transactions;

-- Monthly trend
SELECT DATE_FORMAT(Order_Date,'%Y-%m') Month, ROUND(SUM(Revenue),2) Revenue,
ROUND(SUM(Profit),2) Profit FROM sales_transactions
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m') ORDER BY Month;

-- Product performance
SELECT Product_Name, Category, ROUND(SUM(Revenue),2) Revenue,
ROUND(SUM(Profit),2) Profit, SUM(Quantity) Units_Sold
FROM sales_transactions GROUP BY Product_Name, Category ORDER BY Revenue DESC;

-- Customer value
SELECT Customer_ID, ROUND(SUM(Revenue),2) Revenue, ROUND(SUM(Profit),2) Profit,
COUNT(DISTINCT Order_ID) Orders FROM sales_transactions
GROUP BY Customer_ID ORDER BY Revenue DESC;

-- Segment, channel and region
SELECT Target_Market, ROUND(SUM(Revenue),2) Revenue, ROUND(SUM(Profit),2) Profit
FROM sales_transactions GROUP BY Target_Market ORDER BY Revenue DESC;

SELECT Sales_Channel, ROUND(SUM(Revenue),2) Revenue, ROUND(SUM(Profit),2) Profit,
COUNT(DISTINCT Order_ID) Orders FROM sales_transactions
GROUP BY Sales_Channel ORDER BY Revenue DESC;

SELECT Region, ROUND(SUM(Revenue),2) Revenue, ROUND(SUM(Profit),2) Profit,
COUNT(DISTINCT Customer_ID) Customers FROM sales_transactions
GROUP BY Region ORDER BY Revenue DESC;

-- Low-margin products
SELECT Product_Name, ROUND(SUM(Revenue),2) Revenue, ROUND(SUM(Profit),2) Profit,
ROUND(SUM(Profit)/SUM(Revenue)*100,2) Profit_Margin_Pct
FROM sales_transactions GROUP BY Product_Name ORDER BY Profit_Margin_Pct ASC;

-- Repeat customers
SELECT Customer_ID, COUNT(DISTINCT Order_ID) Order_Count
FROM sales_transactions GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID)>1 ORDER BY Order_Count DESC;