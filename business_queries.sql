USE fleximart;

-- =====================================================
-- Query 1: Customer Purchase History
-- =====================================================
-- Business Question:
-- Generate a detailed report showing each customer's name,
-- email, total number of orders placed, and total amount spent.
-- Include only customers who have placed at least 2 orders
-- and spent more than ₹5,000.
-- Order by total amount spent in descending order.

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
HAVING 
    COUNT(DISTINCT o.order_id) >= 2
    AND SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY total_spent DESC;



-- =====================================================
-- Query 2: Top Selling Products
-- =====================================================
-- Business Question:
-- Identify the top 5 best-selling products based on total
-- quantity sold and total revenue generated.

SELECT
    p.product_name AS product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 5;



-- =====================================================
-- Query 3: Monthly Sales Performance
-- =====================================================
-- Business Question:
-- Generate a monthly sales report showing total orders
-- and total revenue per month.

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;
