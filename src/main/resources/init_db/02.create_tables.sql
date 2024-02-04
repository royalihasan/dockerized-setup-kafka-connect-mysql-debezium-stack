USE
demo;
create table CUSTOMERS
(
    id          INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(50),
    gender      VARCHAR(50),
    club_status VARCHAR(8),
    comments    VARCHAR(90),
    create_ts   timestamp DEFAULT CURRENT_TIMESTAMP,
    update_ts   timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 1 . Product Table
CREATE TABLE PRODUCTS
(
    product_id     INT PRIMARY KEY,
    product_name   VARCHAR(100),
    category       VARCHAR(50),
    price          DECIMAL(10, 2),
    stock_quantity INT
);
-- 2.Orders Table
CREATE TABLE ORDERS
(
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    order_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS (id)
);

CREATE TABLE ORDER_ITEMS
(
    item_id    INT PRIMARY KEY,
    order_id   INT,
    product_id INT,
    quantity   INT,
    subtotal   DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES ORDERS (order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id)
);

CREATE TABLE EMPLOYEES
(
    employee_id INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    hire_date   DATE,
    position    VARCHAR(50),
    salary      DECIMAL(10, 2)
);

CREATE TABLE SUPPLIERS
(
    supplier_id    INT PRIMARY KEY,
    supplier_name  VARCHAR(100),
    contact_person VARCHAR(50),
    email          VARCHAR(50),
    phone_number   VARCHAR(20)
);

CREATE TABLE CATEGORIES
(
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE PAYMENTS
(
    payment_id     INT PRIMARY KEY,
    order_id       INT,
    payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount         DECIMAL(10, 2),
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES ORDERS (order_id)
);

CREATE TABLE REVIEWS
(
    review_id   INT PRIMARY KEY,
    product_id  INT,
    customer_id INT,
    rating      INT,
    comment     TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS (id)
);

CREATE TABLE COUPONS
(
    coupon_id           INT PRIMARY KEY,
    coupon_code         VARCHAR(20),
    discount_percentage DECIMAL(5, 2),
    expiration_date     DATE
);

CREATE TABLE EVENTS
(
    event_id   INT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE,
    venue      VARCHAR(100),
    organizer  VARCHAR(100)
);
