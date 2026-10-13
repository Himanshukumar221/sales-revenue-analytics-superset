CREATE DATABASE sales_analytics;

USE sales_analytics;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    signup_date DATE
);


CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);



CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);



CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


show tables;


USE sales_analytics;

INSERT INTO customers
(customer_name, email, city, signup_date)
VALUES
('Rahul Sharma', 'rahul@gmail.com', 'Patna', '2026-01-05'),
('Priya Singh', 'priya@gmail.com', 'Delhi', '2026-01-10'),
('Aman Kumar', 'aman@gmail.com', 'Bhubaneswar', '2026-01-15'),
('Neha Verma', 'neha@gmail.com', 'Patna', '2026-02-01'),
('Ravi Das', 'ravi@gmail.com', 'Cuttack', '2026-02-05'),
('Anjali Gupta', 'anjali@gmail.com', 'Delhi', '2026-02-12'),
('Vikash Kumar', 'vikash@gmail.com', 'Ranchi', '2026-02-20'),
('Sneha Patel', 'sneha@gmail.com', 'Bhubaneswar', '2026-03-01'),
('Arjun Das', 'arjun@gmail.com', 'Cuttack', '2026-03-10'),
('Pooja Mishra', 'pooja@gmail.com', 'Patna', '2026-03-15');



INSERT INTO products
(product_name, category, price)
VALUES
('Laptop', 'Electronics', 55000.00),
('Smartphone', 'Electronics', 25000.00),
('Headphones', 'Accessories', 2000.00),
('Keyboard', 'Accessories', 1500.00),
('Mouse', 'Accessories', 800.00),
('Monitor', 'Electronics', 12000.00),
('Office Chair', 'Furniture', 8500.00),
('Desk', 'Furniture', 6500.00);



INSERT INTO orders
(customer_id, order_date, status)
VALUES
(1, '2026-01-12', 'Delivered'),
(2, '2026-01-18', 'Delivered'),
(3, '2026-01-22', 'Delivered'),
(1, '2026-02-05', 'Delivered'),
(4, '2026-02-10', 'Delivered'),
(5, '2026-02-14', 'Cancelled'),
(6, '2026-02-20', 'Delivered'),
(7, '2026-02-25', 'Pending'),
(8, '2026-03-03', 'Delivered'),
(9, '2026-03-07', 'Delivered'),
(10, '2026-03-12', 'Delivered'),
(2, '2026-03-15', 'Delivered'),
(3, '2026-03-18', 'Pending'),
(5, '2026-03-20', 'Delivered'),
(1, '2026-03-25', 'Delivered');



INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 54000.00),
(1, 3, 2, 1800.00),
(2, 2, 1, 24500.00),
(2, 5, 1, 750.00),
(3, 4, 2, 1400.00),
(3, 3, 1, 1900.00),
(4, 6, 1, 11500.00),
(4, 5, 2, 750.00),
(5, 7, 1, 8200.00),
(5, 4, 1, 1400.00),
(6, 2, 1, 25000.00),
(7, 1, 1, 53000.00),
(7, 3, 1, 1800.00),
(8, 5, 3, 750.00),
(9, 8, 1, 6300.00),
(9, 4, 1, 1400.00),
(10, 2, 2, 24000.00),
(10, 3, 1, 1800.00),
(11, 6, 2, 11000.00),
(12, 1, 1, 55000.00);


SELECT * FROM customers;


SELECT * FROM products;


SELECT * FROM orders;

SELECT * FROM order_items;

-- count total
SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM order_items) AS total_order_items;
    
    
--     Your first revenue analytics query

SELECT
    order_id,
    SUM(quantity * unit_price) AS order_revenue
FROM order_items
GROUP BY order_id
ORDER BY order_revenue DESC;


-- Calculate total revenue from delivered orders only.

SELECT
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered';


-- Find which customers generated the most revenue.

SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC;


-- Monthly revenue

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

-- selling products by revenue


SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS product_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC
LIMIT 5;