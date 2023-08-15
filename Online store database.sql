-- Create a new database
CREATE DATABASE OnlineECommerce;

-- Switch to the newly created database
USE OnlineECommerce;

-- Create a table to store user information
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a table for user profiles
CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    full_name VARCHAR(100),
    address VARCHAR(200),
    phone_number VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create a table for products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Create a table for orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create a table for order items
CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert data into the 'users' table
INSERT INTO users (username, email, password)
VALUES
    ('john_doe', 'john@example.com', 'hashed_password'),
    ('jane_smith', 'jane@example.com', 'hashed_password');

-- Insert data into the 'user_profiles' table
INSERT INTO user_profiles (user_id, full_name, address, phone_number)
VALUES
    (1, 'John Doe', '123 Main St, City, Country', '123-456-7890'),
    (2, 'Jane Smith', '456 Elm St, Town, Country', '987-654-3210');

-- Insert data into the 'products' table
INSERT INTO products (name, description, price, stock_quantity)
VALUES
    ('Product A', 'Description of Product A', 19.99, 100),
    ('Product B', 'Description of Product B', 29.99, 50),
    ('Product C', 'Description of Product C', 9.99, 200);

-- Insert data into the 'orders' table
INSERT INTO orders (user_id, total_amount)
VALUES
    (1, 49.98),
    (2, 39.98);

-- Insert data into the 'order_items' table
INSERT INTO order_items (order_id, product_id, quantity, item_price)
VALUES
    (1, 1, 2, 19.99),
    (1, 2, 1, 29.99),
    (2, 3, 4, 9.99);

-- Queries

SELECT u.user_id, u.username, u.email, COUNT(o.order_id) AS order_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username, u.email;


SELECT product_id, name, stock_quantity
FROM products
WHERE stock_quantity < 10;


SELECT u.username, SUM(oi.quantity * oi.item_price) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.username;


SELECT u.username
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;


SELECT u.username, o.order_id, o.order_date, oi.quantity, p.name AS product_name
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date = (
    SELECT MAX(order_date)
    FROM orders
    WHERE user_id = u.user_id
);


