ALTER TABLE production.orders
    ADD CONSTRAINT chk_order_status
    CHECK (order_status IN ('delivered', 'shipped', 'canceled', 'unavailable', 'invoiced', 'processing', 'created', 'approved'));

ALTER TABLE production.order_items
    ADD CONSTRAINT chk_order_items_price
    CHECK (price > 0);

ALTER TABLE production.order_items
    ADD CONSTRAINT chk_order_items_freight_value
    CHECK (freight_value >= 0);

ALTER TABLE production.order_items
    ADD CONSTRAINT uq_order_items_order_seq
    UNIQUE (order_id, order_item_seq);

ALTER TABLE production.payments
    ADD CONSTRAINT uq_payments_order_sequential
    UNIQUE (order_id, payment_sequential);

ALTER TABLE production.reviews
    ADD CONSTRAINT chk_reviews_score
    CHECK (review_score BETWEEN 1 AND 5);

CREATE INDEX idx_reviews_review_id ON production.reviews (review_id);

CREATE INDEX idx_orders_customer_id ON production.orders (customer_id);

CREATE INDEX idx_order_items_order_id ON production.order_items (order_id);
CREATE INDEX idx_order_items_product_id ON production.order_items (product_id);
CREATE INDEX idx_order_items_seller_id ON production.order_items (seller_id);

CREATE INDEX idx_payments_order_id ON production.payments (order_id);

CREATE INDEX idx_reviews_order_id ON production.reviews (order_id);