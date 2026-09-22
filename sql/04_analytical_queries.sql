SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    c.customer_city,
    c.customer_state,
    p.product_category_name,
    oi.price,
    oi.freight_value,
    s.seller_city,
    s.seller_state
FROM production.orders o
JOIN production.customers c ON o.customer_id = c.customer_id
JOIN production.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.sellers s ON oi.seller_id = s.seller_id
ORDER BY o.order_purchase_timestamp DESC
LIMIT 100;


WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        SUM(oi.price) AS total_revenue
    FROM production.orders o
    JOIN production.order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    order_month,
    total_revenue
FROM monthly_revenue
ORDER BY order_month;


WITH product_sales AS (
    SELECT
        p.product_category_name,
        p.product_id,
        SUM(oi.price) AS total_sales,
        RANK() OVER (PARTITION BY p.product_category_name ORDER BY SUM(oi.price) DESC) AS category_rank
    FROM production.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name, p.product_id
)
SELECT
    product_category_name,
    product_id,
    total_sales
FROM product_sales
WHERE category_rank = 1
ORDER BY total_sales DESC;


SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))) AS avg_delivery_days,
    AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date))) AS avg_delay_days
FROM production.orders o
JOIN production.customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delay_days DESC;