CREATE SCHEMA IF NOT EXISTS production;

CREATE TABLE production.customers (
    customer_id         VARCHAR PRIMARY KEY,
    unique_customer_id   VARCHAR,
    customer_city        VARCHAR,
    customer_state       CHAR(2)
);

CREATE TABLE production.sellers (
    seller_id    VARCHAR PRIMARY KEY,
    seller_city  VARCHAR,
    seller_state CHAR(2)
);

CREATE TABLE production.products (
    product_id             VARCHAR PRIMARY KEY,
    product_category_name  VARCHAR,
    product_weight_g       NUMERIC
);

CREATE TABLE production.orders (
    order_id                        VARCHAR PRIMARY KEY,
    customer_id                     VARCHAR NOT NULL REFERENCES production.customers(customer_id),
    order_status                    VARCHAR NOT NULL,
    order_purchase_timestamp        TIMESTAMP NOT NULL,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP NOT NULL
);

CREATE TABLE production.order_items (
    order_item_id   SERIAL PRIMARY KEY,
    order_id        VARCHAR NOT NULL REFERENCES production.orders(order_id),
    order_item_seq  INT NOT NULL,
    product_id      VARCHAR NOT NULL REFERENCES production.products(product_id),
    seller_id       VARCHAR NOT NULL REFERENCES production.sellers(seller_id),
    price           NUMERIC(10,2) NOT NULL,
    freight_value   NUMERIC(10,2) NOT NULL
);

CREATE TABLE production.payments (
    payment_id           SERIAL PRIMARY KEY,
    order_id              VARCHAR NOT NULL REFERENCES production.orders(order_id),
    payment_sequential    INT NOT NULL,
    payment_type          VARCHAR NOT NULL,
    payment_installments  INT NOT NULL,
    payment_value         NUMERIC(10,2) NOT NULL
);

CREATE TABLE production.reviews (
    review_pk     SERIAL PRIMARY KEY,
    review_id     VARCHAR NOT NULL,
    order_id      VARCHAR NOT NULL REFERENCES production.orders(order_id),
    review_score  SMALLINT NOT NULL
);