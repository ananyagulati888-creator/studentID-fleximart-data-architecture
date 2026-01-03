# FlexiMart Database Schema Documentation

## 1. Entity–Relationship Description

### ENTITY: customers
**Purpose:** Stores customer information for all registered users.

**Attributes:**
- customer_id: Unique identifier for each customer (Primary Key)
- customer_code: Business identifier used in transactions
- first_name: Customer’s first name
- last_name: Customer’s last name
- email: Customer’s email address
- phone: Contact number of the customer
- city: City of residence
- registration_date: Date when the customer registered

**Relationships:**
- One customer can place MANY orders  
  (1 : M relationship with orders table)

---

### ENTITY: products
**Purpose:** Stores product catalog details available for sale.

**Attributes:**
- product_id: Unique identifier for each product (Primary Key)
- product_code: Business identifier for the product
- product_name: Name of the product
- category: Product category (e.g., Electronics, Grocery)
- price: Unit price of the product
- stock_quantity: Available stock units

**Relationships:**
- One product can appear in MANY order items  
  (1 : M relationship with order_items table)

---

### ENTITY: orders
**Purpose:** Stores high-level order transaction details.

**Attributes:**
- order_id: Unique identifier for each order (Primary Key)
- customer_id: References customers.customer_id (Foreign Key)
- order_date: Date when the order was placed
- total_amount: Total monetary value of the order
- status: Order status (Pending, Completed, Cancelled)

**Relationships:**
- One order belongs to ONE customer  
- One order can contain MANY order items

---

### ENTITY: order_items
**Purpose:** Stores item-level details for each order.

**Attributes:**
- order_item_id: Unique identifier (Primary Key)
- order_id: References orders.order_id (Foreign Key)
- product_id: References products.product_id (Foreign Key)
- quantity: Number of units ordered
- unit_price: Price per unit at time of sale
- subtotal: quantity × unit_price

**Relationships:**
- Many order items belong to ONE order  
- Many order items reference ONE product

---

## 2. Normalization Explanation (Third Normal Form)

The FlexiMart database schema is designed in Third Normal Form (3NF) to ensure data integrity, eliminate redundancy, and prevent anomalies.

Each table satisfies First Normal Form (1NF) as all attributes contain atomic values with no repeating groups. Second Normal Form (2NF) is achieved because all non-key attributes are fully functionally dependent on the primary key of their respective tables. For example, in the products table, attributes like product_name, category, price, and stock_quantity depend entirely on product_id.

Third Normal Form (3NF) is satisfied as there are no transitive dependencies. Non-key attributes do not depend on other non-key attributes. For instance, customer email or phone depends only on customer_id and not on city or registration_date.

Functional dependencies include:
- customer_id → customer details
- product_id → product details
- order_id → order details
- order_item_id → item-level details

This design avoids update anomalies by ensuring data is stored in one place only. Insert anomalies are avoided as entities can be added independently. Delete anomalies are prevented because deleting an order does not remove customer or product information.

---

## 3. Sample Data Representation

### customers
| customer_id | first_name | last_name | email                  | city      |
|------------|------------|-----------|------------------------|-----------|
| 1          | Rahul      | Sharma    | rahul@gmail.com        | Delhi     |
| 2          | Priya      | Mehta     | priya@yahoo.com        | Mumbai    |

### products
| product_id | product_name | category     | price | stock_quantity |
|-----------|--------------|--------------|-------|----------------|
| 101       | Laptop       | Electronics  | 55000 | 10             |
| 102       | Headphones   | Electronics  | 2500  | 50             |

### orders
| order_id | customer_id | order_date | total_amount | status     |
|---------|-------------|------------|--------------|------------|
| 1001    | 1           | 2023-06-01 | 57500        | Completed  |
| 1002    | 2           | 2023-06-03 | 2500         | Pending    |

### order_items
| order_item_id | order_id | product_id | quantity | unit_price | subtotal |
|--------------|----------|------------|----------|------------|----------|
| 1            | 1001     | 101        | 1        | 55000      | 55000    |
| 2            | 1002     | 102        | 1        | 2500       | 2500     |
