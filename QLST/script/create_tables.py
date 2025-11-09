"""Create the relational schema required by the simplified QLST web application."""
from __future__ import annotations

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    print_connection_banner,
)


DROP_STATEMENTS = [
    "SET FOREIGN_KEY_CHECKS = 0",
    """
    DROP TABLE IF EXISTS tblOrderDetails, tblOrders, tblProducts, tblTransactions, tblCustomers, tblUsers
    """,
    "SET FOREIGN_KEY_CHECKS = 1",
]

CREATE_STATEMENTS = [
    """
    CREATE TABLE IF NOT EXISTS tblUsers (
        id VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
        username VARCHAR(100) COLLATE utf8mb4_unicode_ci NOT NULL,
        password_hash CHAR(64) COLLATE utf8mb4_unicode_ci NOT NULL,
        role VARCHAR(32) COLLATE utf8mb4_unicode_ci NOT NULL,
        full_name VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        email VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        phone_number VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        UNIQUE KEY uq_tblUsers_username (username),
        UNIQUE KEY uq_tblUsers_email (email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS tblCustomers (
        id VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
        full_name VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        email VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        phone_number VARCHAR(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
        address VARCHAR(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
        joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        user_id VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
        PRIMARY KEY (id),
        UNIQUE KEY unique_user_id (user_id),
        CONSTRAINT fk_customers_users FOREIGN KEY (user_id)
            REFERENCES tblUsers (id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS tblProducts (
        id VARCHAR(10) NOT NULL,
        name VARCHAR(255) NOT NULL,
        price DECIMAL(12,2) NOT NULL,
        quantity INT NOT NULL DEFAULT 0,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS tblOrders (
        id VARCHAR(10) NOT NULL,
        order_date DATETIME NOT NULL,
        total_price DECIMAL(12,2) NOT NULL,
        delivery_invoice_number VARCHAR(100) DEFAULT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        customer_id VARCHAR(10) COLLATE utf8mb4_unicode_ci NOT NULL,
        PRIMARY KEY (id),
        KEY idx_orders_customer_date (order_date),
        KEY fk_orders_customers (customer_id),
        CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
            REFERENCES tblCustomers (id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS tblOrderDetails (
        quantity INT NOT NULL,
        price DECIMAL(12,2) NOT NULL,
        order_id VARCHAR(10) NOT NULL,
        product_id VARCHAR(10) NOT NULL,
        KEY fk_order_details_orders (order_id),
        KEY fk_order_details_products (product_id),
        CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id)
            REFERENCES tblOrders (id) ON DELETE CASCADE,
        CONSTRAINT fk_order_details_products FOREIGN KEY (product_id)
            REFERENCES tblProducts (id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS tblTransactions (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        customer_id VARCHAR(10) NOT NULL,
        amount DECIMAL(12,2) NOT NULL,
        transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        description VARCHAR(500),
        CONSTRAINT fk_transactions_customers FOREIGN KEY (customer_id)
            REFERENCES tblCustomers (id) ON DELETE CASCADE
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
