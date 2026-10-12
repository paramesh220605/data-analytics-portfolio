-- Customer Retention, Churn & LTV Analytics Platform
-- SQL practice script
-- Compatible with MySQL-style SQL with minor adjustments.

CREATE TABLE customer_churn_ltv (
    Customer_ID VARCHAR(20),
    Age INT,
    Gender VARCHAR(10),
    Tenure_Months INT,
    Contract_Type VARCHAR(20),
    Payment_Method VARCHAR(30),
    Support_Tickets INT,
    Login_Frequency_Monthly INT,
    Discount_Percent DECIMAL(5,2),
    Satisfaction_Score INT,
    Monthly_Charges DECIMAL(10,2),
    Total_Spend DECIMAL(12,2),
    Purchase_Frequency INT,
    Churn VARCHAR(5),
    Churn_Flag INT,
    Estimated_Annual_Revenue DECIMAL(12,2),
    Simple_LTV DECIMAL(14,2),
    Retention_Rate DECIMAL(5,2),
    Risk_Category VARCHAR(10)
);

-- 1. Total customers
SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM customer_churn_ltv;

-- 2. Churn rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
    AS Churn_Rate_Percent
FROM customer_churn_ltv;

-- 3. Retention rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) / COUNT(*), 2)
    AS Retention_Rate_Percent
FROM customer_churn_ltv;

-- 4. Churn by contract
SELECT
    Contract_Type,
    COUNT(*) AS Customers,
    ROUND(100.0 * AVG(Churn_Flag), 2) AS Churn_Rate_Percent
FROM customer_churn_ltv
GROUP BY Contract_Type
ORDER BY Churn_Rate_Percent DESC;

-- 5. Average LTV by contract
SELECT
    Contract_Type,
    ROUND(AVG(Simple_LTV), 2) AS Average_LTV
FROM customer_churn_ltv
GROUP BY Contract_Type
ORDER BY Average_LTV DESC;

-- 6. Churn by satisfaction score
SELECT
    Satisfaction_Score,
    COUNT(*) AS Customers,
    ROUND(100.0 * AVG(Churn_Flag), 2) AS Churn_Rate_Percent
FROM customer_churn_ltv
GROUP BY Satisfaction_Score
ORDER BY Satisfaction_Score;

-- 7. High-value customers
SELECT
    Customer_ID,
    Contract_Type,
    Monthly_Charges,
    Tenure_Months,
    Simple_LTV,
    Churn,
    Risk_Category
FROM customer_churn_ltv
WHERE Simple_LTV >= (SELECT AVG(Simple_LTV) FROM customer_churn_ltv)
ORDER BY Simple_LTV DESC
LIMIT 20;

-- 8. High-risk customers
SELECT
    Customer_ID,
    Satisfaction_Score,
    Support_Tickets,
    Login_Frequency_Monthly,
    Simple_LTV,
    Risk_Category
FROM customer_churn_ltv
WHERE Risk_Category = 'High'
ORDER BY Simple_LTV DESC;

-- 9. Retained vs churned customer value
SELECT
    Churn,
    COUNT(*) AS Customers,
    ROUND(SUM(Simple_LTV), 2) AS Customer_Value
FROM customer_churn_ltv
GROUP BY Churn;
