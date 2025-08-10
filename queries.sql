-- Create Database


-- Categories Table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('M', 'F', 'Other'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Addresses Table
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('billing', 'shipping') NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    sku VARCHAR(100) UNIQUE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2),
    weight DECIMAL(8, 2),
    dimensions VARCHAR(100),
    brand VARCHAR(100),
    color VARCHAR(50),
    size VARCHAR(20),
    material VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Product Images Table
CREATE TABLE product_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(200),
    is_primary BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Inventory Table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    quantity_available INT NOT NULL DEFAULT 0,
    reserved_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 10,
    last_restocked TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Shopping Cart Table
CREATE TABLE shopping_cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    shipping_cost DECIMAL(10, 2) DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    shipping_address_id INT,
    billing_address_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES addresses(address_id)
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer', 'cash_on_delivery') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_id VARCHAR(100),
    status ENUM('pending', 'completed', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Product Reviews Table
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    review_text TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Coupons Table
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed_amount') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order_amount DECIMAL(10, 2) DEFAULT 0,
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Insert Data into Categories
INSERT INTO categories (name, description, parent_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Clothing', 'Apparel and fashion items', NULL),
('Home & Garden', 'Home improvement and garden supplies', NULL),
('Books', 'Books and educational materials', NULL),
('Sports', 'Sports and fitness equipment', NULL),
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Portable computers', 1),
('Men''s Clothing', 'Clothing for men', 2),
('Women''s Clothing', 'Clothing for women', 2),
('Furniture', 'Home furniture', 3);

-- Insert Data into Users
INSERT INTO users (first_name, last_name, email, password_hash, phone, date_of_birth, gender) VALUES
('John', 'Doe', 'john.doe@email.com', 'hashed_password_1', '+1-555-0101', '1990-05-15', 'M'),
('Jane', 'Smith', 'jane.smith@email.com', 'hashed_password_2', '+1-555-0102', '1988-09-22', 'F'),
('Michael', 'Johnson', 'michael.j@email.com', 'hashed_password_3', '+1-555-0103', '1992-03-10', 'M'),
('Sarah', 'Williams', 'sarah.w@email.com', 'hashed_password_4', '+1-555-0104', '1995-07-18', 'F'),
('David', 'Brown', 'david.brown@email.com', 'hashed_password_5', '+1-555-0105', '1987-12-05', 'M'),
('Emily', 'Davis', 'emily.davis@email.com', 'hashed_password_6', '+1-555-0106', '1993-11-28', 'F'),
('Robert', 'Miller', 'robert.miller@email.com', 'hashed_password_7', '+1-555-0107', '1989-04-14', 'M'),
('Lisa', 'Wilson', 'lisa.wilson@email.com', 'hashed_password_8', '+1-555-0108', '1991-08-30', 'F');

-- Insert Data into Addresses
INSERT INTO addresses (user_id, type, street_address, city, state, postal_code, country, is_default) VALUES
(1, 'shipping', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(1, 'billing', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(2, 'shipping', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', TRUE),
(2, 'billing', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', TRUE),
(3, 'shipping', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', TRUE),
(4, 'shipping', '321 Elm St', 'Houston', 'TX', '77001', 'USA', TRUE),
(5, 'shipping', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', TRUE),
(6, 'shipping', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', TRUE);

-- Insert Data into Products
INSERT INTO products (category_id, name, description, sku, price, cost_price, weight, brand, color, size) VALUES
(6, 'iPhone 14 Pro', 'Latest Apple smartphone with advanced camera', 'IP14PRO-128-BLK', 999.99, 750.00, 0.48, 'Apple', 'Black', '128GB'),
(6, 'Samsung Galaxy S23', 'Premium Android smartphone', 'SGS23-256-WHT', 849.99, 650.00, 0.52, 'Samsung', 'White', '256GB'),
(7, 'MacBook Air M2', '13-inch laptop with M2 chip', 'MBA-M2-13-SLV', 1199.99, 900.00, 1.24, 'Apple', 'Silver', '13-inch'),
(7, 'Dell XPS 13', 'Ultra-thin Windows laptop', 'DXS13-512-BLK', 1099.99, 850.00, 1.19, 'Dell', 'Black', '13-inch'),
(8, 'Men''s Cotton T-Shirt', 'Comfortable everyday t-shirt', 'MTSHIRT-COT-M-BLU', 19.99, 8.00, 0.20, 'BasicWear', 'Blue', 'M'),
(8, 'Men''s Jeans', 'Classic straight fit denim jeans', 'MJEANS-STR-32-IND', 59.99, 30.00, 0.75, 'DenimCo', 'Indigo', '32'),
(9, 'Women''s Summer Dress', 'Light floral print dress', 'WDRESS-FLR-M-PNK', 79.99, 35.00, 0.30, 'FashionPlus', 'Pink', 'M'),
(9, 'Women''s Sneakers', 'Comfortable walking shoes', 'WSNEAK-WHT-8', 89.99, 45.00, 0.85, 'ComfortStep', 'White', '8'),
(10, 'Office Chair', 'Ergonomic office chair with lumbar support', 'CHAIR-ERG-BLK', 199.99, 120.00, 15.00, 'OfficePro', 'Black', 'Standard'),
(4, 'The Great Gatsby', 'Classic American literature', 'BOOK-GATSBY-PB', 14.99, 6.00, 0.25, 'Penguin Classics', 'N/A', 'Paperback');

-- Insert Data into Product Images
INSERT INTO product_images (product_id, image_url, alt_text, is_primary, sort_order) VALUES
(1, '/images/iphone14pro_black_front.jpg', 'iPhone 14 Pro Black Front View', TRUE, 1),
(1, '/images/iphone14pro_black_back.jpg', 'iPhone 14 Pro Black Back View', FALSE, 2),
(2, '/images/galaxy_s23_white_front.jpg', 'Samsung Galaxy S23 White Front', TRUE, 1),
(3, '/images/macbook_air_m2_silver.jpg', 'MacBook Air M2 Silver', TRUE, 1),
(4, '/images/dell_xps13_black.jpg', 'Dell XPS 13 Black', TRUE, 1),
(5, '/images/mens_tshirt_blue.jpg', 'Men''s Blue Cotton T-Shirt', TRUE, 1);

-- Insert Data into Inventory
INSERT INTO inventory (product_id, quantity_available, reserved_quantity, reorder_level, last_restocked) VALUES
(1, 25, 3, 10, '2024-01-15 10:00:00'),
(2, 18, 2, 8, '2024-01-20 14:30:00'),
(3, 12, 1, 5, '2024-01-18 09:15:00'),
(4, 8, 0, 5, '2024-01-22 11:45:00'),
(5, 150, 5, 20, '2024-01-25 08:00:00'),
(6, 75, 8, 15, '2024-01-23 16:20:00'),
(7, 45, 3, 10, '2024-01-21 13:10:00'),
(8, 32, 2, 8, '2024-01-24 10:30:00'),
(9, 6, 1, 3, '2024-01-19 15:45:00'),
(10, 200, 12, 25, '2024-01-26 07:30:00');

-- Insert Data into Orders
INSERT INTO orders (user_id, order_number, status, total_amount, tax_amount, shipping_cost, shipping_address_id, billing_address_id) VALUES
(1, 'ORD-2024-001', 'delivered', 1079.98, 79.99, 9.99, 1, 2),
(2, 'ORD-2024-002', 'shipped', 929.98, 69.99, 10.00, 3, 4),
(3, 'ORD-2024-003', 'processing', 79.98, 5.99, 7.99, 5, 5),
(4, 'ORD-2024-004', 'confirmed', 1309.98, 99.99, 12.99, 6, 6),
(1, 'ORD-2024-005', 'pending', 169.97, 12.74, 8.99, 1, 2),
(5, 'ORD-2024-006', 'delivered', 59.99, 4.50, 5.99, 7, 7),
(6, 'ORD-2024-007', 'cancelled', 89.99, 6.75, 7.50, 8, 8);

-- Insert Data into Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 999.99, 999.99),
(1, 5, 4, 19.99, 79.99),
(2, 2, 1, 849.99, 849.99),
(2, 8, 1, 89.99, 89.99),
(3, 7, 1, 79.99, 79.99),
(4, 3, 1, 1199.99, 1199.99),
(4, 9, 1, 199.99, 199.99),
(5, 6, 2, 59.99, 119.98),
(5, 10, 3, 14.99, 44.97),
(6, 6, 1, 59.99, 59.99),
(7, 8, 1, 89.99, 89.99);

-- Insert Data into Payments
INSERT INTO payments (order_id, payment_method, amount, transaction_id, status, processed_at) VALUES
(1, 'credit_card', 1079.98, 'TXN001234567', 'completed', '2024-01-15 14:30:00'),
(2, 'paypal', 929.98, 'PP987654321', 'completed', '2024-01-16 11:20:00'),
(3, 'debit_card', 79.98, 'TXN001234568', 'completed', '2024-01-17 16:45:00'),
(4, 'credit_card', 1309.98, 'TXN001234569', 'pending', NULL),
(5, 'cash_on_delivery', 169.97, NULL, 'pending', NULL),
(6, 'bank_transfer', 59.99, 'BT123456789', 'completed', '2024-01-18 09:15:00'),
(7, 'credit_card', 89.99, 'TXN001234570', 'cancelled', NULL);

-- Insert Data into Product Reviews
INSERT INTO product_reviews (product_id, user_id, rating, title, review_text, is_verified_purchase) VALUES
(1, 1, 5, 'Excellent phone!', 'The iPhone 14 Pro exceeded my expectations. Camera quality is outstanding and battery life is great.', TRUE),
(2, 2, 4, 'Great Android phone', 'Samsung Galaxy S23 is a solid choice. Good performance and display quality.', TRUE),
(5, 1, 5, 'Perfect fit', 'The t-shirt fits perfectly and the material is very comfortable.', TRUE),
(6, 5, 4, 'Good quality jeans', 'Well-made jeans with good fit. Slightly expensive but worth it.', TRUE),
(7, 3, 5, 'Beautiful dress', 'Love the floral print and the fabric quality. Perfect for summer.', TRUE),
(1, 3, 4, 'Good but expensive', 'The phone is great but quite pricey. Camera is the standout feature.', FALSE),
(8, 2, 5, 'Super comfortable', 'These sneakers are incredibly comfortable for walking. Highly recommend!', TRUE);

-- Insert Data into Shopping Cart
INSERT INTO shopping_cart (user_id, product_id, quantity) VALUES
(3, 4, 1),
(4, 5, 2),
(4, 6, 1),
(5, 10, 5),
(6, 7, 1),
(6, 8, 1);

-- Insert Data into Coupons
INSERT INTO coupons (code, description, discount_type, discount_value, minimum_order_amount, usage_limit, start_date, end_date) VALUES
('WELCOME10', 'Welcome discount for new customers', 'percentage', 10.00, 50.00, 1000, '2024-01-01', '2024-12-31'),
('SAVE20', 'Save $20 on orders over $100', 'fixed_amount', 20.00, 100.00, 500, '2024-01-01', '2024-06-30'),
('SUMMER15', 'Summer sale 15% off', 'percentage', 15.00, 75.00, NULL, '2024-06-01', '2024-08-31'),
('FREESHIP', 'Free shipping on orders over $50', 'fixed_amount', 10.00, 50.00, NULL, '2024-01-01', '2024-12-31');
-- 1. List all products with price above $500, ordered by price (highest first)
SELECT product_id, name, price
FROM products
WHERE price > 500
ORDER BY price DESC;

-- 2. Total sales per category
SELECT c.name AS category_name, SUM(oi.total_price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;


-- INNER JOIN: Orders with customer names
SELECT o.order_number, CONCAT(u.first_name, ' ', u.last_name) AS customer_name, o.total_amount
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id;

-- LEFT JOIN: All customers and their orders (including those without orders)
SELECT u.user_id, CONCAT(u.first_name, ' ', u.last_name) AS customer_name, o.order_number
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

-- RIGHT JOIN: All orders and related customers (note: RIGHT JOIN less common)
SELECT o.order_number, CONCAT(u.first_name, ' ', u.last_name) AS customer_name
FROM users u
RIGHT JOIN orders o ON u.user_id = o.user_id;


-- Customers who spent above average total_amount
SELECT user_id, CONCAT(first_name, ' ', last_name) AS customer_name
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders
    )
);


-- Average order value
SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- Total revenue
SELECT SUM(total_amount) AS total_revenue
FROM orders;


-- View: Monthly sales
CREATE VIEW monthly_sales AS
SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY DATE_FORMAT(created_at, '%Y-%m');

-- View: Product sales summary
CREATE VIEW product_sales_summary AS
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_units_sold, SUM(oi.total_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name;


-- Index on order_date for faster date filtering
CREATE INDEX idx_order_created_at ON orders(created_at);

-- Index on product_id for faster joins in order_items
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Index on category_id for faster category queries
CREATE INDEX idx_products_category_id ON products(category_id);



