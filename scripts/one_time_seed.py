import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
DB_HOST = "127.0.0.1"
DB_PORT = "5433"
DB_NAME = "ecommerce"

engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")

def load_customers():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_customers_dataset.csv"))
    df = df.rename(columns={"customer_unique_id": "unique_customer_id"})
    df = df[["customer_id", "unique_customer_id", "customer_city", "customer_state"]]
    df.to_sql("customers", engine, schema="production", if_exists="append", index=False)
    print(f"customers: {len(df)} rows loaded")

def load_sellers():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_sellers_dataset.csv"))
    df = df[["seller_id", "seller_city", "seller_state"]]
    df.to_sql("sellers", engine, schema="production", if_exists="append", index=False)
    print(f"sellers: {len(df)} rows loaded")

def load_products():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_products_dataset.csv"))
    df = df[["product_id", "product_category_name", "product_weight_g"]]
    df.to_sql("products", engine, schema="production", if_exists="append", index=False)
    print(f"products: {len(df)} rows loaded")

def load_orders():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_orders_dataset.csv"))
    df = df[["order_id", "customer_id", "order_status", "order_purchase_timestamp",
             "order_delivered_customer_date", "order_estimated_delivery_date"]]
    df.to_sql("orders", engine, schema="production", if_exists="append", index=False)
    print(f"orders: {len(df)} rows loaded")

def load_order_items():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_order_items_dataset.csv"))
    df = df.rename(columns={"order_item_id": "order_item_seq"})
    df = df[["order_id", "order_item_seq", "product_id", "seller_id", "price", "freight_value"]]
    df.to_sql("order_items", engine, schema="production", if_exists="append", index=False)
    print(f"order_items: {len(df)} rows loaded")

def load_payments():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_order_payments_dataset.csv"))
    df = df[["order_id", "payment_sequential", "payment_type", "payment_installments", "payment_value"]]
    df.to_sql("payments", engine, schema="production", if_exists="append", index=False)
    print(f"payments: {len(df)} rows loaded")

def load_reviews():
    df = pd.read_csv(os.path.join(DATA_DIR, "olist_order_reviews_dataset.csv"))
    df = df[["review_id", "order_id", "review_score"]]
    df.to_sql("reviews", engine, schema="production", if_exists="append", index=False)
    print(f"reviews: {len(df)} rows loaded")

def main():
    load_customers()
    load_sellers()
    load_products()
    load_orders()
    load_order_items()
    load_payments()
    load_reviews()

if __name__ == "__main__":
    main()
