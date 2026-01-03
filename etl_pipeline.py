# etl_pipeline.py
# Complete ETL Pipeline for FlexiMart
# Uses CSV + JSON, cleans data, loads into MySQL, generates data quality report
import os
print("Current working directory:", os.getcwd())

import pandas as pd
import mysql.connector
import json
import re

print("ETL started")

# ================== DATABASE CONFIG ==================
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "YOUR_MYSQL_PASSWORD",   # 🔴 change this
    "database": "fleximart"
}

# ================== DATA QUALITY REPORT ==================
report = {
    "customers": {"processed": 0, "duplicates": 0, "missing": 0, "loaded": 0},
    "products": {"processed": 0, "duplicates": 0, "missing": 0, "loaded": 0},
    "sales": {"processed": 0, "duplicates": 0, "missing": 0, "loaded": 0}
}

# ================== HELPER FUNCTIONS ==================
def standardize_phone(phone):
    if pd.isna(phone):
        return None
    digits = re.sub(r"\D", "", str(phone))
    if len(digits) >= 10:
        return "+91-" + digits[-10:]
    return None

def standardize_date(date):
    try:
        return pd.to_datetime(date, dayfirst=True).strftime("%Y-%m-%d")
    except:
        return None

def standardize_category(cat):
    if pd.isna(cat):
        return "Misc"
    return str(cat).strip().capitalize()

# ================== EXTRACT ==================
customers = pd.read_csv("customers_raw.csv")
products_csv = pd.read_csv("products_raw.csv")
sales = pd.read_csv("sales_raw.csv")

with open("products_catalog.json", "r", encoding="utf-8") as f:
    products_json = json.load(f)

# ================== TRANSFORM: CUSTOMERS ==================
report["customers"]["processed"] = len(customers)

report["customers"]["duplicates"] = customers.duplicated().sum()
customers.drop_duplicates(inplace=True)

report["customers"]["missing"] = customers.isna().sum().sum()

customers["email"].fillna("not_provided@email.com", inplace=True)
customers["phone"] = customers["phone"].apply(standardize_phone)
customers["registration_date"] = customers["registration_date"].apply(standardize_date)

# ================== TRANSFORM: PRODUCTS (CSV) ==================
report["products"]["processed"] = len(products_csv)

report["products"]["duplicates"] = products_csv.duplicated().sum()
products_csv.drop_duplicates(inplace=True)

report["products"]["missing"] = products_csv.isna().sum().sum()

products_csv["price"].fillna(products_csv["price"].median(), inplace=True)
products_csv["stock_quantity"].fillna(0, inplace=True)
products_csv["category"] = products_csv["category"].apply(standardize_category)

# ================== TRANSFORM: PRODUCTS (JSON) ==================
products_json_df = pd.DataFrame([
    {
        "product_code": p["product_id"],
        "product_name": p["name"],
        "category": p["category"],
        "price": p["price"],
        "stock_quantity": p["stock"]
    }
    for p in products_json
])

# Merge CSV + JSON products
products = pd.concat([
    products_csv.rename(columns={"product_id": "product_code"}),
    products_json_df
], ignore_index=True)

products.drop_duplicates(subset=["product_code"], inplace=True)

# ============== TRANSFORM: SALES =================

# Remove duplicate transactions
sales = sales.drop_duplicates(subset=["transaction_id"])

# Remove rows with missing customer/product
sales = sales.dropna(subset=["customer_id", "product_id"])

# Standardize transaction date
sales["transaction_date"] = sales["transaction_date"].apply(standardize_date)
sales = sales.dropna(subset=["transaction_date"])

# ================== LOAD ==================
try:
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    # -------- LOAD CUSTOMERS --------
    for _, r in customers.iterrows():
        cursor.execute("""
            INSERT INTO customers
            (customer_code, first_name, last_name, email, phone, city, registration_date)
            VALUES (%s,%s,%s,%s,%s,%s,%s)
        """, (
            r["customer_code"],
            r["first_name"],
            r["last_name"],
            r["email"],
            r["phone"],
            r["city"],
            r["registration_date"]
        ))
        report["customers"]["loaded"] += 1

    # -------- LOAD PRODUCTS --------
    for _, r in products.iterrows():
        cursor.execute("""
            INSERT INTO products
            (product_code, product_name, category, price, stock_quantity)
            VALUES (%s,%s,%s,%s,%s)
        """, (
            r["product_code"],
            r["product_name"],
            r["category"],
            r["price"],
            r["stock_quantity"]
        ))
        report["products"]["loaded"] += 1

    # -------- LOAD SALES --------
    for _, r in sales.iterrows():
        cursor.execute("""
            INSERT INTO sales
            (transaction_id, customer_code, product_code, quantity, unit_price, sale_date, status)
            VALUES (%s,%s,%s,%s,%s,%s,%s)
        """, (
            r["transaction_id"],
            r["customer_code"],
            r["product_code"],
            r["quantity"],
            r["unit_price"],
            r["sale_date"],
            r["status"]
        ))
        report["sales"]["loaded"] += 1

    conn.commit()

except Exception as e:
    print("Database Error:", e)

finally:
    cursor.close()
    conn.close()

# ================== DATA QUALITY REPORT ==================
print("Writing report file")
with open("data_quality_report.txt", "w") as f:
    for table, stats in report.items():
        f.write(f"{table.upper()}\n")
        f.write(f"Records processed: {stats['processed']}\n")
        f.write(f"Duplicates removed: {stats['duplicates']}\n")
        f.write(f"Missing values handled: {stats['missing']}\n")
        f.write(f"Records loaded: {stats['loaded']}\n")
        f.write("-" * 30 + "\n")

print("ETL Pipeline executed successfully.")
# ===== FORCE DATA QUALITY REPORT CREATION =====
print("Force writing data quality report...")

with open("data_quality_report.txt", "w") as f:
    for table, stats in report.items():
        f.write(f"{table.upper()}\n")
        f.write(f"Records processed: {stats['processed']}\n")
        f.write(f"Duplicates removed: {stats['duplicates']}\n")
        f.write(f"Missing values handled: {stats['missing']}\n")
        f.write(f"Records loaded: {stats['loaded']}\n")
        f.write("-" * 30 + "\n")

print("Data quality report created successfully.")
