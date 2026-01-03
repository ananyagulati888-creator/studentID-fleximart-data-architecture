-- =====================================================
-- FlexiMart Data Warehouse: Star Schema Implementation
-- =====================================================

CREATE DATABASE IF NOT EXISTS fleximart_dw;
USE fleximart_dw;

-- =========================
-- DIMENSION TABLE: dim_date
-- =========================
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,              -- YYYYMMDD
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10),
    month INT,
    month_name VARCHAR(15),
    quarter VARCHAR(2),
    year INT,
    is_weekend BOOLEAN
);

-- ============================
-- DIMENSION TABLE: dim_product
-- ============================
CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(20),
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    price_band VARCHAR(20)
);

-- ==============================
-- DIMENSION TABLE: dim_customer
-- ==============================
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    customer_type VARCHAR(20),
    registration_date DATE
);

-- =========================
-- FACT TABLE: fact_sales
-- =========================
CREATE TABLE fact_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    date_key INT,
    product_key INT,
    customer_key INT,
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    total_amount DECIMAL(12,2),

    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- dim_date
INSERT INTO dim_date VALUES
(20240115, '2024-01-15', 'Monday', 1, 'January', 'Q1', 2024, FALSE),
(20240210, '2024-02-10', 'Saturday', 2, 'February', 'Q1', 2024, TRUE);

-- dim_product
INSERT INTO dim_product (product_id, product_name, category, brand, price_band) VALUES
('P001', 'Laptop', 'Electronics', 'Dell', 'High'),
('P002', 'Headphones', 'Electronics', 'Sony', 'Medium');

-- dim_customer
INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_type, registration_date) VALUES
('C001', 'John Doe', 'Mumbai', 'Maharashtra', 'Retail', '2023-12-01'),
('C002', 'Priya Sharma', 'Delhi', 'Delhi', 'Retail', '2024-01-05');

-- fact_sales
INSERT INTO fact_sales
(date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount)
VALUES
(20240115, 1, 1, 2, 50000, 0, 100000),
(20240210, 2, 2, 1, 3000, 500, 2500);

-- =====================================================
-- ANALYTICAL QUERIES (OLAP)
-- =====================================================

-- 1. Total Sales by Month
SELECT
    d.month_name,
    d.year,
    SUM(f.total_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- 2. Sales by Product Category
SELECT
    p.category,
    SUM(f.total_amount) AS category_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY category_sales DESC;

-- 3. Top Customers by Revenue
SELECT
    c.customer_name,
    SUM(f.total_amount) AS total_spent
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 4. Drill-down Example: Daily Sales for January 2024
SELECT
    d.full_date,
    SUM(f.total_amount) AS daily_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
WHERE d.month = 1 AND d.year = 2024
GROUP BY d.full_date
ORDER BY d.full_date;
