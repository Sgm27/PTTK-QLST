"""
Create the relational schema required by the QLST web application.

The script drops any existing tables before creating them again, ensuring that
repeated executions always produce a consistent baseline. All definitions are
aligned with the DAO layer in ``src/main/java/com/qlst``.
"""
from __future__ import annotations

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    print_connection_banner,
)


DROP_STATEMENTS = [
    "SET FOREIGN_KEY_CHECKS = 0",
    "DROP TABLE IF EXISTS order_items",
    "DROP TABLE IF EXISTS orders",
    "DROP TABLE IF EXISTS products",
    "DROP TABLE IF EXISTS suppliers",
    "DROP TABLE IF EXISTS users",
    "SET FOREIGN_KEY_CHECKS = 1",
]


CREATE_STATEMENTS = [
    """
    CREATE TABLE IF NOT EXISTS users (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        username VARCHAR(100) NOT NULL UNIQUE,
        password_hash CHAR(64) NOT NULL,
        role VARCHAR(32) NOT NULL,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        phone_number VARCHAR(50),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS suppliers (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        contact_name VARCHAR(255),
        email VARCHAR(255),
        phone VARCHAR(50),
        address VARCHAR(500),
        notes TEXT
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS products (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        sku VARCHAR(100) NOT NULL UNIQUE,
        description TEXT,
        unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
        stock_quantity INT NOT NULL DEFAULT 0,
        supplier_id BIGINT,
        category VARCHAR(100),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
            REFERENCES suppliers(id) ON DELETE SET NULL ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS orders (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        customer_id BIGINT NOT NULL,
        status VARCHAR(50) NOT NULL,
        order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
        delivery_address VARCHAR(500),
        order_type VARCHAR(50) NOT NULL,
        CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
            REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        INDEX idx_orders_customer (customer_id),
        INDEX idx_orders_date (order_date)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS order_items (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        order_id BIGINT NOT NULL,
        product_id BIGINT NOT NULL,
        quantity INT NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
            REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
            REFERENCES products(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        INDEX idx_order_items_order (order_id),
        INDEX idx_order_items_product (product_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
]


def run_statements(statements):
    with db_cursor() as (_, cursor):
        for statement in statements:
            cursor.execute(statement)


def main():
    print_connection_banner()
    print("Dropping existing tables (if any)...")
    run_statements(DROP_STATEMENTS)
    print("Creating tables...")
    run_statements(CREATE_STATEMENTS)
    print("Database schema created successfully.")


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)

