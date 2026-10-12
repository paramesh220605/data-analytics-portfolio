-- ============================================================
-- E-COMMERCE DATA ANALYTICS PROJECT: SQL SCRIPT
-- Domain: Revenue, Customer RFM, Product & Platform Metrics
-- ============================================================

-- 1. Monthly Revenue & Average Order Value (AOV) Analysis
SELECT 
    DATE_TRUNC('month', order_date) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(unit_price * quantity) AS gross_gmv,
    SUM((unit_price * quantity) * (1 - discount_pct)) AS net_revenue,
    SUM((unit_price * quantity) * (1 - discount_pct)) / NULLIF(COUNT(DISTINCT order_id), 0) AS average_order_value
FROM ecommerce_orders
WHERE status = 'Completed'
GROUP BY 1
ORDER BY order_month ASC;

-- 2. Customer RFM Segmentation Analysis
WITH customer_rfm AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM((unit_price * quantity) * (1 - discount_pct)) AS total_monetary_val
    FROM ecommerce_orders
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    customer_id,
    ('2026-09-01'::DATE - last_order_date) AS recency_days,
    total_orders AS frequency,
    total_monetary_val AS monetary,
    NTILE(4) OVER (ORDER BY ('2026-09-01'::DATE - last_order_date) DESC) AS r_score,
    NTILE(4) OVER (ORDER BY total_orders ASC) AS f_score,
    NTILE(4) OVER (ORDER BY total_monetary_val ASC) AS m_score
FROM customer_rfm;

-- 3. Product Performance and Category Return Rates
SELECT 
    category,
    COUNT(order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    SUM((unit_price * quantity) * (1 - discount_pct)) AS net_sales,
    COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS returned_orders,
    ROUND(CAST(COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS NUMERIC) / COUNT(order_id) * 100, 2) AS return_rate_pct
FROM ecommerce_orders
GROUP BY category
ORDER BY net_sales DESC;

-- 4. Logistics & Fulfillment Performance Analysis
SELECT 
    fulfillment_type,
    COUNT(order_id) AS total_orders,
    COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS returned_orders,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled_orders,
    ROUND(CAST(COUNT(CASE WHEN status = 'Returned' THEN 1 END) AS NUMERIC) / COUNT(order_id) * 100, 2) AS return_rate_pct
FROM ecommerce_orders
GROUP BY fulfillment_type;
