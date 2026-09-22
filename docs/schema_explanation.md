# Schema Explanation — Olist E-Commerce Database

## Why This Schema?

The production schema is designed as a normalized (3NF) relational database based on the real Olist Brazilian E-Commerce dataset. The goal is to eliminate data redundancy, enforce referential integrity, and support both transactional reliability and downstream analytical queries.

## Tables and Design Decisions

### customers
Stores unique customer records. Olist's dataset contains two customer identifiers: `customer_id` (a per-order ID) and `unique_customer_id` (the true person-level ID). Both are retained as-is to preserve the source structure — `customer_id` is the natural primary key used across the order flow.

### sellers
Independent seller entities. Kept separate from products and orders to avoid update anomalies (a seller's city change should not require updating every order row).

### products
Product catalog. Only attributes relevant to the analytical layer are retained: category name and weight. Dimensional attributes like product dimensions are excluded as out of scope for this project.

### orders
The central fact-like entity in this transactional schema. References `customers` via FK. Contains order lifecycle timestamps and status. `order_delivered_customer_date` is intentionally nullable — undelivered orders legitimately have no delivery date, this is not a data error.

### order_items
Line items within each order. Uses a SERIAL surrogate PK (`order_item_id`) for internal referencing, while the natural composite key `(order_id, order_item_seq)` enforces business uniqueness and serves as the UPSERT conflict target in Project 2's ETL pipeline.

### payments
Supports split payments (one order can have multiple payment rows). Same surrogate + natural key pattern as order_items: `payment_id` (SERIAL PK) + `UNIQUE(order_id, payment_sequential)`.

### reviews
Olist's source `review_id` is not reliably unique (814 duplicate values confirmed during exploration). A SERIAL surrogate PK (`review_pk`) is used instead, with `review_id` retained as a non-unique indexed column for traceability.

## Relationships

- customers (1) → orders (many)
- orders (1) → order_items (many)
- products (1) → order_items (many)
- sellers (1) → order_items (many)
- orders (1) → payments (many)
- orders (1) → reviews (usually 1, occasionally more)

All foreign keys are enforced at the database level with indexes on all FK columns for query performance.

## Why 3NF?

Third Normal Form eliminates transitive dependencies — each non-key column depends only on the primary key, not on other non-key columns. This prevents update anomalies (e.g., changing a seller's city in one place updates it everywhere), reduces storage redundancy, and ensures data integrity across the transactional schema. Denormalization is intentionally deferred to the analytics layer (Project 3's star schema).

## Notes on 03_views.sql

This file is intentionally empty. No convenience views were required — all analytical queries in `04_analytical_queries.sql` operate directly on the normalized tables via JOINs, which is sufficient at this schema's complexity level.