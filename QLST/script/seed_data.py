"""Populate the MySQL database with sample data for the streamlined QLST scope."""
from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from typing import Dict

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    get_db_config,
    hash_password,
    print_connection_banner,
)

REQUIRED_TABLES = ("users", "customers", "transactions")

USERS = [
    {
        "username": "manager1",
        "password": "password123",
        "role": "MANAGER",
        "full_name": "Nguyen Van Manager",
        "email": "manager@example.com",
        "phone_number": "0901112233",
        "created_at": datetime(2025, 10, 1, 9, 0),
    },
    {
        "username": "customer_anna",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Pham Thi Anna",
        "email": "anna@example.com",
        "phone_number": "0911002200",
        "created_at": datetime(2025, 10, 5, 14, 15),
    },
    {
        "username": "customer_binh",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Do Quang Binh",
        "email": "binh@example.com",
        "phone_number": "0911223344",
        "created_at": datetime(2025, 10, 6, 10, 5),
    },
    {
        "username": "customer_chi",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Vu Mai Chi",
        "email": "chi@example.com",
        "phone_number": "0911334455",
        "created_at": datetime(2025, 10, 7, 16, 40),
    },
]

CUSTOMERS = [
    {
        "username": "customer_anna",
        "address": "123 Nguyen Trai, District 1, Ho Chi Minh City",
        "joined_at": datetime(2025, 10, 5, 14, 30),
    },
    {
        "username": "customer_binh",
        "address": "56 Le Loi, District 1, Ho Chi Minh City",
        "joined_at": datetime(2025, 10, 6, 10, 30),
    },
    {
        "username": "customer_chi",
        "address": "89 Tran Hung Dao, District 5, Ho Chi Minh City",
        "joined_at": datetime(2025, 10, 7, 16, 55),
    },
]

TRANSACTIONS = [
    {
        "username": "customer_anna",
        "amount": Decimal("799.99"),
        "transaction_date": datetime(2025, 10, 15, 10, 30),
        "description": "Mua TV 4K và tai nghe không dây",
    },
    {
        "username": "customer_anna",
        "amount": Decimal("120.00"),
        "transaction_date": datetime(2025, 10, 25, 9, 0),
        "description": "Phụ kiện âm thanh",
    },
    {
        "username": "customer_binh",
        "amount": Decimal("1648.00"),
        "transaction_date": datetime(2025, 10, 20, 15, 45),
        "description": "Laptop chơi game và robot hút bụi",
    },
    {
        "username": "customer_chi",
        "amount": Decimal("1579.49"),
        "transaction_date": datetime(2025, 10, 25, 11, 15),
        "description": "Tủ lạnh thông minh và tai nghe",
    },
]


def ensure_schema(cursor) -> None:
    placeholders = ", ".join(["%s"] * len(REQUIRED_TABLES))
    database = get_db_config()["database"]
    cursor.execute(
        f"""
        SELECT table_name FROM information_schema.tables
        WHERE table_schema = %s AND table_name IN ({placeholders})
        """,
        (database, *REQUIRED_TABLES),
    )
    existing = {row[0] for row in cursor.fetchall()}
    missing = set(REQUIRED_TABLES) - existing
    if missing:
        formatted = ", ".join(sorted(missing))
        raise RuntimeError(
            f"Thiếu các bảng bắt buộc: {formatted}. Vui lòng chạy create_tables.py trước."
        )


def reset_tables(cursor) -> None:
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
    for table in ("transactions", "customers", "users"):
        cursor.execute(f"TRUNCATE TABLE {table}")
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")


def insert_users(cursor) -> Dict[str, int]:
    user_ids: Dict[str, int] = {}
    for entry in USERS:
        cursor.execute(
            """
            INSERT INTO users (username, password_hash, role, full_name, email, phone_number, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                entry["username"],
                hash_password(entry["password"]),
                entry["role"],
                entry["full_name"],
                entry["email"],
                entry["phone_number"],
                entry["created_at"],
            ),
        )
        user_ids[entry["username"]] = cursor.lastrowid
    return user_ids


def insert_customers(cursor, user_ids: Dict[str, int]) -> Dict[str, int]:
    customer_ids: Dict[str, int] = {}
    for entry in CUSTOMERS:
        username = entry["username"]
        user_id = user_ids[username]
        cursor.execute(
            """
            INSERT INTO customers (user_id, full_name, email, phone_number, address, joined_at)
            SELECT %s, u.full_name, u.email, u.phone_number, %s, %s
            FROM users u
            WHERE u.id = %s
            """,
            (
                user_id,
                entry["address"],
                entry["joined_at"],
                user_id,
            ),
        )
        customer_ids[username] = cursor.lastrowid
    return customer_ids


def insert_transactions(cursor, customer_ids: Dict[str, int]) -> None:
    for entry in TRANSACTIONS:
        customer_id = customer_ids[entry["username"]]
        cursor.execute(
            """
            INSERT INTO transactions (customer_id, amount, transaction_date, description)
            VALUES (%s, %s, %s, %s)
            """,
            (
                customer_id,
                entry["amount"],
                entry["transaction_date"],
                entry["description"],
            ),
        )


def main() -> None:
    print_connection_banner()
    with db_cursor() as (_, cursor):
        ensure_schema(cursor)
        reset_tables(cursor)
        user_ids = insert_users(cursor)
        customer_ids = insert_customers(cursor, user_ids)
        insert_transactions(cursor, customer_ids)
    print("Database seeded successfully.")


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
