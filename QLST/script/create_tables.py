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
    DROP TABLE IF EXISTS order_items, orders, transactions, products, suppliers, customers, users
    """,
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
    CREATE TABLE IF NOT EXISTS customers (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        user_id BIGINT NOT NULL,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        phone_number VARCHAR(50),
        address VARCHAR(500),
        joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_customers_user FOREIGN KEY (user_id)
            REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
        UNIQUE KEY uq_customers_user (user_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    """,
    """
    CREATE TABLE IF NOT EXISTS transactions (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        customer_id BIGINT NOT NULL,
        amount DECIMAL(12, 2) NOT NULL,
        transaction_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        description VARCHAR(500),
        CONSTRAINT fk_transactions_customer FOREIGN KEY (customer_id)
            REFERENCES customers(id) ON DELETE CASCADE ON UPDATE CASCADE,
        INDEX idx_transactions_customer (customer_id),
        INDEX idx_transactions_date (transaction_date)
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
