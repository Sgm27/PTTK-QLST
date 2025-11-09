-- Migration script to change ID format from numeric to custom format
-- KH001 for customers, SP001 for products, DH001 for orders, ND001 for users

-- ============================================
-- STEP 1: Disable foreign key checks
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- STEP 2: Create temporary columns for new IDs
-- ============================================

-- Customers: Add new_id column
ALTER TABLE customers ADD COLUMN new_id VARCHAR(10);

-- Products: Add new_id column
ALTER TABLE products ADD COLUMN new_id VARCHAR(10);

-- Users: Add new_id column
ALTER TABLE users ADD COLUMN new_id VARCHAR(10);

-- Orders: Add new_id column
ALTER TABLE orders ADD COLUMN new_id VARCHAR(10);

-- Order Details: Add new foreign key columns
ALTER TABLE order_details ADD COLUMN new_order_id VARCHAR(10);
ALTER TABLE order_details ADD COLUMN new_product_id VARCHAR(10);

-- Orders: Add new foreign key column
ALTER TABLE orders ADD COLUMN new_customer_id VARCHAR(10);

-- Customers: Add new foreign key column
ALTER TABLE customers ADD COLUMN new_user_id VARCHAR(10);

-- ============================================
-- STEP 3: Populate new ID columns with formatted values
-- ============================================

-- Update customers with KH001, KH002, etc.
UPDATE customers SET new_id = CONCAT('KH', LPAD(id, 3, '0'));

-- Update products with SP001, SP002, etc.
UPDATE products SET new_id = CONCAT('SP', LPAD(id, 3, '0'));

-- Update users with ND001, ND002, etc.
UPDATE users SET new_id = CONCAT('ND', LPAD(id, 3, '0'));

-- Update orders with DH001, DH002, etc.
UPDATE orders SET new_id = CONCAT('DH', LPAD(id, 3, '0'));

-- ============================================
-- STEP 4: Update foreign key references
-- ============================================

-- Update order_details foreign keys
UPDATE order_details od
JOIN orders o ON od.order_id = o.id
SET od.new_order_id = o.new_id;

UPDATE order_details od
JOIN products p ON od.product_id = p.id
SET od.new_product_id = p.new_id;

-- Update orders foreign key
UPDATE orders o
JOIN customers c ON o.customer_id = c.id
SET o.new_customer_id = c.new_id;

-- Update customers foreign key
UPDATE customers c
JOIN users u ON c.user_id = u.id
SET c.new_user_id = u.new_id;

-- ============================================
-- STEP 5: Drop old foreign key constraints
-- ============================================

-- Drop foreign keys from order_details
ALTER TABLE order_details DROP FOREIGN KEY order_details_ibfk_1;
ALTER TABLE order_details DROP FOREIGN KEY order_details_ibfk_2;

-- Drop foreign key from orders
ALTER TABLE orders DROP FOREIGN KEY orders_ibfk_1;

-- Drop foreign key from customers
ALTER TABLE customers DROP FOREIGN KEY customers_ibfk_1;

-- ============================================
-- STEP 6: Drop old columns and rename new ones
-- ============================================

-- Order details: drop old columns
ALTER TABLE order_details DROP COLUMN order_id;
ALTER TABLE order_details DROP COLUMN product_id;
ALTER TABLE order_details CHANGE COLUMN new_order_id order_id VARCHAR(10) NOT NULL;
ALTER TABLE order_details CHANGE COLUMN new_product_id product_id VARCHAR(10) NOT NULL;

-- Orders: drop old foreign key column
ALTER TABLE orders DROP COLUMN customer_id;
ALTER TABLE orders CHANGE COLUMN new_customer_id customer_id VARCHAR(10) NOT NULL;

-- Customers: drop old foreign key column
ALTER TABLE customers DROP COLUMN user_id;
ALTER TABLE customers CHANGE COLUMN new_user_id user_id VARCHAR(10) NOT NULL;

-- Drop old primary key columns and make new_id the primary key
ALTER TABLE order_details DROP COLUMN id;

ALTER TABLE orders DROP PRIMARY KEY;
ALTER TABLE orders DROP COLUMN id;
ALTER TABLE orders CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE orders ADD PRIMARY KEY (id);

ALTER TABLE products DROP PRIMARY KEY;
ALTER TABLE products DROP COLUMN id;
ALTER TABLE products CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE products ADD PRIMARY KEY (id);

ALTER TABLE customers DROP PRIMARY KEY;
ALTER TABLE customers DROP COLUMN id;
ALTER TABLE customers CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE customers ADD PRIMARY KEY (id);

ALTER TABLE users DROP PRIMARY KEY;
ALTER TABLE users DROP COLUMN id;
ALTER TABLE users CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE users ADD PRIMARY KEY (id);

-- ============================================
-- STEP 7: Re-create foreign key constraints
-- ============================================

-- Add foreign keys to order_details
ALTER TABLE order_details 
ADD CONSTRAINT fk_order_details_orders 
FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

ALTER TABLE order_details 
ADD CONSTRAINT fk_order_details_products 
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;

-- Add foreign key to orders
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customers 
FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;

-- Add foreign key to customers
ALTER TABLE customers 
ADD CONSTRAINT fk_customers_users 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Add unique constraint back to customers.user_id
ALTER TABLE customers ADD UNIQUE KEY unique_user_id (user_id);

-- ============================================
-- STEP 8: Create triggers for auto-generating new IDs
-- ============================================

DELIMITER //

-- Trigger for users table
CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    -- Get the highest numeric part from existing IDs
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM users;
    
    -- Generate new ID with format ND001, ND002, etc.
    SET new_custom_id = CONCAT('ND', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for customers table
CREATE TRIGGER before_insert_customers
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM customers;
    
    SET new_custom_id = CONCAT('KH', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for products table
CREATE TRIGGER before_insert_products
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM products;
    
    SET new_custom_id = CONCAT('SP', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for orders table
CREATE TRIGGER before_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM orders;
    
    SET new_custom_id = CONCAT('DH', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

DELIMITER ;

-- ============================================
-- STEP 9: Re-enable foreign key checks
-- ============================================
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- Verification queries
-- ============================================
SELECT 'Migration completed!' as status;
SELECT 'Customers' as table_name, COUNT(*) as count FROM customers;
SELECT 'Products' as table_name, COUNT(*) as count FROM products;
SELECT 'Users' as table_name, COUNT(*) as count FROM users;
SELECT 'Orders' as table_name, COUNT(*) as count FROM orders;
SELECT 'Order Details' as table_name, COUNT(*) as count FROM order_details;
