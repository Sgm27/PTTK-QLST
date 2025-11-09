-- Migration script to change ID format from numeric to custom format
-- KH001 for tblCustomers, SP001 for tblProducts, DH001 for tblOrders, ND001 for tblUsers

-- ============================================
-- STEP 1: Disable foreign key checks
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- STEP 2: Create temporary columns for new IDs
-- ============================================

-- Customers: Add new_id column
ALTER TABLE tblCustomers ADD COLUMN new_id VARCHAR(10);

-- Products: Add new_id column
ALTER TABLE tblProducts ADD COLUMN new_id VARCHAR(10);

-- Users: Add new_id column
ALTER TABLE tblUsers ADD COLUMN new_id VARCHAR(10);

-- Orders: Add new_id column
ALTER TABLE tblOrders ADD COLUMN new_id VARCHAR(10);

-- Order Details: Add new foreign key columns
ALTER TABLE tblOrderDetails ADD COLUMN new_order_id VARCHAR(10);
ALTER TABLE tblOrderDetails ADD COLUMN new_product_id VARCHAR(10);

-- Orders: Add new foreign key column
ALTER TABLE tblOrders ADD COLUMN new_customer_id VARCHAR(10);

-- Customers: Add new foreign key column
ALTER TABLE tblCustomers ADD COLUMN new_user_id VARCHAR(10);

-- ============================================
-- STEP 3: Populate new ID columns with formatted values
-- ============================================

-- Update tblCustomers with KH001, KH002, etc.
UPDATE tblCustomers SET new_id = CONCAT('KH', LPAD(id, 3, '0'));

-- Update tblProducts with SP001, SP002, etc.
UPDATE tblProducts SET new_id = CONCAT('SP', LPAD(id, 3, '0'));

-- Update tblUsers with ND001, ND002, etc.
UPDATE tblUsers SET new_id = CONCAT('ND', LPAD(id, 3, '0'));

-- Update tblOrders with DH001, DH002, etc.
UPDATE tblOrders SET new_id = CONCAT('DH', LPAD(id, 3, '0'));

-- ============================================
-- STEP 4: Update foreign key references
-- ============================================

-- Update order_details foreign keys
UPDATE tblOrderDetails od
JOIN tblOrders o ON od.order_id = o.id
SET od.new_order_id = o.new_id;

UPDATE tblOrderDetails od
JOIN tblProducts p ON od.product_id = p.id
SET od.new_product_id = p.new_id;

-- Update orders foreign key
UPDATE tblOrders o
JOIN tblCustomers c ON o.customer_id = c.id
SET o.new_customer_id = c.new_id;

-- Update customers foreign key
UPDATE tblCustomers c
JOIN tblUsers u ON c.user_id = u.id
SET c.new_user_id = u.new_id;

-- ============================================
-- STEP 5: Drop old foreign key constraints
-- ============================================

-- Drop foreign keys from order_details
ALTER TABLE tblOrderDetails DROP FOREIGN KEY order_details_ibfk_1;
ALTER TABLE tblOrderDetails DROP FOREIGN KEY order_details_ibfk_2;

-- Drop foreign key from orders
ALTER TABLE tblOrders DROP FOREIGN KEY orders_ibfk_1;

-- Drop foreign key from customers
ALTER TABLE tblCustomers DROP FOREIGN KEY customers_ibfk_1;

-- ============================================
-- STEP 6: Drop old columns and rename new ones
-- ============================================

-- Order details: drop old columns
ALTER TABLE tblOrderDetails DROP COLUMN order_id;
ALTER TABLE tblOrderDetails DROP COLUMN product_id;
ALTER TABLE tblOrderDetails CHANGE COLUMN new_order_id order_id VARCHAR(10) NOT NULL;
ALTER TABLE tblOrderDetails CHANGE COLUMN new_product_id product_id VARCHAR(10) NOT NULL;

-- Orders: drop old foreign key column
ALTER TABLE tblOrders DROP COLUMN customer_id;
ALTER TABLE tblOrders CHANGE COLUMN new_customer_id customer_id VARCHAR(10) NOT NULL;

-- Customers: drop old foreign key column
ALTER TABLE tblCustomers DROP COLUMN user_id;
ALTER TABLE tblCustomers CHANGE COLUMN new_user_id user_id VARCHAR(10) NOT NULL;

-- Drop old primary key columns and make new_id the primary key
ALTER TABLE tblOrderDetails DROP COLUMN id;

ALTER TABLE tblOrders DROP PRIMARY KEY;
ALTER TABLE tblOrders DROP COLUMN id;
ALTER TABLE tblOrders CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE tblOrders ADD PRIMARY KEY (id);

ALTER TABLE tblProducts DROP PRIMARY KEY;
ALTER TABLE tblProducts DROP COLUMN id;
ALTER TABLE tblProducts CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE tblProducts ADD PRIMARY KEY (id);

ALTER TABLE tblCustomers DROP PRIMARY KEY;
ALTER TABLE tblCustomers DROP COLUMN id;
ALTER TABLE tblCustomers CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE tblCustomers ADD PRIMARY KEY (id);

ALTER TABLE tblUsers DROP PRIMARY KEY;
ALTER TABLE tblUsers DROP COLUMN id;
ALTER TABLE tblUsers CHANGE COLUMN new_id id VARCHAR(10) NOT NULL;
ALTER TABLE tblUsers ADD PRIMARY KEY (id);

-- ============================================
-- STEP 7: Re-create foreign key constraints
-- ============================================

-- Add foreign keys to order_details
ALTER TABLE tblOrderDetails 
ADD CONSTRAINT fk_order_details_orders 
FOREIGN KEY (order_id) REFERENCES tblOrders(id) ON DELETE CASCADE;

ALTER TABLE tblOrderDetails 
ADD CONSTRAINT fk_order_details_products 
FOREIGN KEY (product_id) REFERENCES tblProducts(id) ON DELETE CASCADE;

-- Add foreign key to orders
ALTER TABLE tblOrders 
ADD CONSTRAINT fk_orders_customers 
FOREIGN KEY (customer_id) REFERENCES tblCustomers(id) ON DELETE CASCADE;

-- Add foreign key to customers
ALTER TABLE tblCustomers 
ADD CONSTRAINT fk_customers_users 
FOREIGN KEY (user_id) REFERENCES tblUsers(id) ON DELETE CASCADE;

-- Add unique constraint back to customers.user_id
ALTER TABLE tblCustomers ADD UNIQUE KEY unique_user_id (user_id);

-- ============================================
-- STEP 8: Create triggers for auto-generating new IDs
-- ============================================

DELIMITER //

-- Trigger for users table
CREATE TRIGGER before_insert_users
BEFORE INSERT ON tblUsers
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    -- Get the highest numeric part from existing IDs
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM tblUsers;
    
    -- Generate new ID with format ND001, ND002, etc.
    SET new_custom_id = CONCAT('ND', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for customers table
CREATE TRIGGER before_insert_customers
BEFORE INSERT ON tblCustomers
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM tblCustomers;
    
    SET new_custom_id = CONCAT('KH', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for products table
CREATE TRIGGER before_insert_products
BEFORE INSERT ON tblProducts
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM tblProducts;
    
    SET new_custom_id = CONCAT('SP', LPAD(next_id, 3, '0'));
    SET NEW.id = new_custom_id;
END//

-- Trigger for orders table
CREATE TRIGGER before_insert_orders
BEFORE INSERT ON tblOrders
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    DECLARE new_custom_id VARCHAR(10);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(id, 3) AS UNSIGNED)), 0) + 1 INTO next_id
    FROM tblOrders;
    
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
SELECT 'tblCustomers' as table_name, COUNT(*) as count FROM tblCustomers;
SELECT 'tblProducts' as table_name, COUNT(*) as count FROM tblProducts;
SELECT 'tblUsers' as table_name, COUNT(*) as count FROM tblUsers;
SELECT 'tblOrders' as table_name, COUNT(*) as count FROM tblOrders;
SELECT 'tblOrderDetails' as table_name, COUNT(*) as count FROM tblOrderDetails;
