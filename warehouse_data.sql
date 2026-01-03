USE fleximart_dw;

-- ===============================
-- DIM_DATE (30 dates: Jan–Feb 2024)
-- ===============================
INSERT INTO dim_date
(date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend)
VALUES
(20240101,'2024-01-01','Monday',1,1,'January','Q1',2024,false),
(20240102,'2024-01-02','Tuesday',2,1,'January','Q1',2024,false),
(20240103,'2024-01-03','Wednesday',3,1,'January','Q1',2024,false),
(20240104,'2024-01-04','Thursday',4,1,'January','Q1',2024,false),
(20240105,'2024-01-05','Friday',5,1,'January','Q1',2024,false),
(20240106,'2024-01-06','Saturday',6,1,'January','Q1',2024,true),
(20240107,'2024-01-07','Sunday',7,1,'January','Q1',2024,true),
(20240108,'2024-01-08','Monday',8,1,'January','Q1',2024,false),
(20240109,'2024-01-09','Tuesday',9,1,'January','Q1',2024,false),
(20240110,'2024-01-10','Wednesday',10,1,'January','Q1',2024,false),
(20240111,'2024-01-11','Thursday',11,1,'January','Q1',2024,false),
(20240112,'2024-01-12','Friday',12,1,'January','Q1',2024,false),
(20240113,'2024-01-13','Saturday',13,1,'January','Q1',2024,true),
(20240114,'2024-01-14','Sunday',14,1,'January','Q1',2024,true),
(20240115,'2024-01-15','Monday',15,1,'January','Q1',2024,false),
(20240116,'2024-01-16','Tuesday',16,1,'January','Q1',2024,false),
(20240117,'2024-01-17','Wednesday',17,1,'January','Q1',2024,false),
(20240118,'2024-01-18','Thursday',18,1,'January','Q1',2024,false),
(20240119,'2024-01-19','Friday',19,1,'January','Q1',2024,false),
(20240120,'2024-01-20','Saturday',20,1,'January','Q1',2024,true),
(20240121,'2024-01-21','Sunday',21,1,'January','Q1',2024,true),
(20240201,'2024-02-01','Thursday',1,2,'February','Q1',2024,false),
(20240202,'2024-02-02','Friday',2,2,'February','Q1',2024,false),
(20240203,'2024-02-03','Saturday',3,2,'February','Q1',2024,true),
(20240204,'2024-02-04','Sunday',4,2,'February','Q1',2024,true),
(20240205,'2024-02-05','Monday',5,2,'February','Q1',2024,false),
(20240206,'2024-02-06','Tuesday',6,2,'February','Q1',2024,false),
(20240207,'2024-02-07','Wednesday',7,2,'February','Q1',2024,false),
(20240208,'2024-02-08','Thursday',8,2,'February','Q1',2024,false),
(20240209,'2024-02-09','Friday',9,2,'February','Q1',2024,false);

-- ===============================
-- DIM_PRODUCT (15 products)
-- ===============================
INSERT INTO dim_product
(product_id, product_name, category, subcategory, unit_price)
VALUES
('P001','Laptop Pro','Electronics','Computers',85000),
('P002','Smartphone X','Electronics','Mobiles',65000),
('P003','Bluetooth Speaker','Electronics','Audio',5000),
('P004','LED TV 42','Electronics','Television',42000),
('P005','Headphones','Electronics','Audio',3000),
('P006','Office Chair','Furniture','Seating',9000),
('P007','Dining Table','Furniture','Tables',25000),
('P008','Sofa Set','Furniture','Living',55000),
('P009','Study Desk','Furniture','Tables',12000),
('P010','Bookshelf','Furniture','Storage',8000),
('P011','Running Shoes','Fashion','Footwear',4000),
('P012','Jacket','Fashion','Clothing',6000),
('P013','Jeans','Fashion','Clothing',3500),
('P014','Handbag','Fashion','Accessories',7000),
('P015','Watch','Fashion','Accessories',15000);

-- ===============================
-- DIM_CUSTOMER (12 customers)
-- ===============================
INSERT INTO dim_customer
(customer_id, customer_name, city, state, customer_segment)
VALUES
('C001','Amit Sharma','Delhi','Delhi','Consumer'),
('C002','Neha Gupta','Mumbai','Maharashtra','Corporate'),
('C003','Ravi Verma','Bangalore','Karnataka','Consumer'),
('C004','Pooja Singh','Pune','Maharashtra','Home Office'),
('C005','Arjun Mehta','Ahmedabad','Gujarat','Consumer'),
('C006','Sneha Iyer','Chennai','Tamil Nadu','Corporate'),
('C007','Karan Malhotra','Delhi','Delhi','Consumer'),
('C008','Ananya Rao','Hyderabad','Telangana','Home Office'),
('C009','Vikas Jain','Jaipur','Rajasthan','Consumer'),
('C010','Simran Kaur','Chandigarh','Punjab','Corporate'),
('C011','Mohit Bansal','Noida','UP','Consumer'),
('C012','Ritu Kapoor','Gurgaon','Haryana','Home Office');

-- ===============================
-- FACT_SALES (40 transactions)
-- ===============================
INSERT INTO fact_sales
(date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount)
VALUES
(20240106,1,1,1,85000,5000,80000),
(20240107,2,2,1,65000,3000,62000),
(20240113,3,3,2,5000,0,10000),
(20240114,4,4,1,42000,2000,40000),
(20240120,5,5,3,3000,0,9000),
(20240121,6,6,2,9000,1000,17000),
(20240106,7,7,1,25000,0,25000),
(20240107,8,8,1,55000,5000,50000),
(20240113,9,9,2,12000,2000,22000),
(20240114,10,10,1,8000,0,8000),
(20240120,11,11,2,4000,0,8000),
(20240121,12,12,1,6000,500,5500),
(20240106,13,1,3,3500,0,10500),
(20240107,14,2,1,7000,0,7000),
(20240113,15,3,1,15000,1000,14000),
(20240114,1,4,1,85000,5000,80000),
(20240120,2,5,2,65000,5000,125000),
(20240121,3,6,4,5000,0,20000),
(20240203,4,7,1,42000,2000,40000),
(20240204,5,8,2,3000,0,6000),
(20240203,6,9,1,9000,0,9000),
(20240204,7,10,1,25000,0,25000),
(20240203,8,11,1,55000,5000,50000),
(20240204,9,12,1,12000,0,12000),
(20240203,10,1,2,8000,0,16000),
(20240204,11,2,3,4000,0,12000),
(20240203,12,3,1,6000,500,5500),
(20240204,13,4,2,3500,0,7000),
(20240203,14,5,1,7000,0,7000),
(20240204,15,6,1,15000,1000,14000),
(20240203,1,7,1,85000,5000,80000),
(20240204,2,8,1,65000,3000,62000),
(20240203,3,9,3,5000,0,15000),
(20240204,4,10,1,42000,2000,40000),
(20240203,5,11,2,3000,0,6000),
(20240204,6,12,1,9000,0,9000),
(20240203,7,1,1,25000,0,25000),
(20240204,8,2,1,55000,5000,50000),
(20240203,9,3,2,12000,2000,22000),
(20240204,10,4,1,8000,0,8000);



SELECT COUNT(*) FROM dim_date;      
SELECT COUNT(*) FROM dim_product;   
SELECT COUNT(*) FROM dim_customer;  
SELECT COUNT(*) FROM fact_sales;    