"""
Populate the MySQL database with representative sample data.

The inserted data covers all tables used by the QLST application so that
logins, product management, and reporting features have meaningful fixtures.
"""
from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from typing import Dict, List

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    get_db_config,
    hash_password,
    print_connection_banner,
)


REQUIRED_TABLES = ("users", "suppliers", "products", "orders", "order_items")

USERS = [
    {
        "username": "manager1",
        "password": "password123",
        "role": "MANAGER",
        "full_name": "Nguyen Van Manager",
        "email": "manager@example.com",
        "phone_number": "0901112233",
        "created_at": datetime(2024, 9, 1, 9, 0),
    },
    {
        "username": "warehouse1",
        "password": "warehouse123",
        "role": "WAREHOUSE",
        "full_name": "Le Thi Warehouse",
        "email": "warehouse@example.com",
        "phone_number": "0902223344",
        "created_at": datetime(2024, 9, 2, 8, 30),
    },
    {
        "username": "sales1",
        "password": "sales123",
        "role": "SALES",
        "full_name": "Tran Minh Sales",
        "email": "sales@example.com",
        "phone_number": "0903334455",
        "created_at": datetime(2024, 9, 3, 9, 45),
    },
    {
        "username": "customer_anna",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Pham Thi Anna",
        "email": "anna@example.com",
        "phone_number": "0911002200",
        "created_at": datetime(2024, 9, 5, 14, 15),
    },
    {
        "username": "customer_binh",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Do Quang Binh",
        "email": "binh@example.com",
        "phone_number": "0911223344",
        "created_at": datetime(2024, 9, 6, 10, 5),
    },
    {
        "username": "customer_chi",
        "password": "customer123",
        "role": "CUSTOMER",
        "full_name": "Vu Mai Chi",
        "email": "chi@example.com",
        "phone_number": "0911334455",
        "created_at": datetime(2024, 9, 7, 16, 40),
    },
]

SUPPLIERS = [
    {
        "name": "TechSource Ltd",
        "contact_name": "Pham Tuan Anh",
        "email": "contact@techsource.vn",
        "phone": "028-111-2233",
        "address": "123 Nguyen Trai, District 1, Ho Chi Minh City",
        "notes": "Primary electronics supplier",
    },
    {
        "name": "Gadget House Co",
        "contact_name": "Le Hoang Nam",
        "email": "support@gadgethouse.vn",
        "phone": "028-222-3344",
        "address": "45 Le Loi, District 1, Ho Chi Minh City",
        "notes": "Preferred for mobile accessories",
    },
    {
        "name": "SmartHome Partners",
        "contact_name": "Nguyen Thanh Long",
        "email": "sales@smarthome.vn",
        "phone": "024-333-4455",
        "address": "89 Bui Thi Xuan, Hai Ba Trung, Ha Noi",
        "notes": "Smart home appliances distributor",
    },
]

PRODUCTS = [
    {
        "name": "4K Smart TV 55 inch",
        "sku": "TV-4K-001",
        "description": "Ultra HD 4K television with HDR and built-in streaming apps.",
        "unit_price": Decimal("799.99"),
        "stock_quantity": 25,
        "supplier": "TechSource Ltd",
        "category": "Television",
        "created_at": datetime(2024, 9, 10, 9, 0),
        "updated_at": datetime(2024, 9, 18, 15, 45),
    },
    {
        "name": "Gaming Laptop 15 inch",
        "sku": "LAP-GAME-15",
        "description": "High-performance laptop with RTX graphics and 16GB RAM.",
        "unit_price": Decimal("1299.00"),
        "stock_quantity": 15,
        "supplier": "Gadget House Co",
        "category": "Computers",
        "created_at": datetime(2024, 9, 11, 10, 30),
        "updated_at": datetime(2024, 9, 19, 12, 0),
    },
    {
        "name": "Wireless Earbuds Pro",
        "sku": "EAR-WL-100",
        "description": "Noise-cancelling wireless earbuds with 24-hour battery life.",
        "unit_price": Decimal("79.99"),
        "stock_quantity": 120,
        "supplier": "Gadget House Co",
        "category": "Audio",
        "created_at": datetime(2024, 9, 12, 11, 15),
        "updated_at": datetime(2024, 9, 16, 13, 20),
    },
    {
        "name": "Smart Refrigerator 500L",
        "sku": "FRIDGE-SMART-01",
        "description": "Wi-Fi enabled refrigerator with energy saving mode.",
        "unit_price": Decimal("1499.50"),
        "stock_quantity": 8,
        "supplier": "SmartHome Partners",
        "category": "Appliances",
        "created_at": datetime(2024, 9, 13, 8, 20),
        "updated_at": datetime(2024, 9, 21, 9, 10),
    },
    {
        "name": "Robot Vacuum Cleaner",
        "sku": "VAC-ROBO-01",
        "description": "Smart vacuum with floor mapping and auto recharge.",
        "unit_price": Decimal("349.00"),
        "stock_quantity": 30,
        "supplier": "SmartHome Partners",
        "category": "Appliances",
        "created_at": datetime(2024, 9, 14, 14, 45),
        "updated_at": datetime(2024, 9, 22, 16, 5),
    },
]

ORDERS = [
    {
        "customer": "customer_anna",
        "status": "COMPLETED",
        "order_date": datetime(2024, 9, 15, 10, 30),
        "delivery_address": "123 Nguyen Trai, District 1, Ho Chi Minh City",
        "order_type": "ONLINE",
        "items": [
            {"sku": "TV-4K-001", "quantity": 1, "unit_price": Decimal("799.99")},
            {"sku": "EAR-WL-100", "quantity": 2, "unit_price": Decimal("79.99")},
        ],
    },
    {
        "customer": "customer_binh",
        "status": "APPROVED",
        "order_date": datetime(2024, 9, 20, 15, 45),
        "delivery_address": "56 Le Loi, District 1, Ho Chi Minh City",
        "order_type": "IN_STORE",
        "items": [
            {"sku": "LAP-GAME-15", "quantity": 1, "unit_price": Decimal("1299.00")},
            {"sku": "VAC-ROBO-01", "quantity": 1, "unit_price": Decimal("349.00")},
        ],
    },
    {
        "customer": "customer_chi",
        "status": "PENDING",
        "order_date": datetime(2024, 9, 25, 11, 15),
        "delivery_address": "89 Tran Hung Dao, District 5, Ho Chi Minh City",
        "order_type": "ONLINE",
        "items": [
            {"sku": "FRIDGE-SMART-01", "quantity": 1, "unit_price": Decimal("1499.50")},
            {"sku": "EAR-WL-100", "quantity": 1, "unit_price": Decimal("79.99")},
        ],
    },
]


def ensure_schema(cursor) -> None:
    """Verify that all required tables exist before attempting to seed data."""
    database = get_db_config()["database"]
    placeholders = ", ".join(["%s"] * len(REQUIRED_TABLES))
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
            f"Missing required tables: {formatted}. "
            "Run create_tables.py before seeding data."
        )


def truncate_tables(cursor) -> None:
    cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
    for table in ("order_items", "orders", "products", "suppliers", "users"):
        cursor.execute(f"TRUNCATE TABLE {table}")
    cursor.execute("SET FOREIGN_KEY_CHECKS = 1")


def insert_users(cursor) -> Dict[str, int]:
    user_ids: Dict[str, int] = {}
    sql = """
        INSERT INTO users (username, password_hash, role, full_name, email, phone_number, created_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    for entry in USERS:
        cursor.execute(
            sql,
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


def insert_suppliers(cursor) -> Dict[str, int]:
    supplier_ids: Dict[str, int] = {}
    sql = """
        INSERT INTO suppliers (name, contact_name, email, phone, address, notes)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    for entry in SUPPLIERS:
        cursor.execute(
            sql,
            (
                entry["name"],
                entry["contact_name"],
                entry["email"],
                entry["phone"],
                entry["address"],
                entry["notes"],
            ),
        )
        supplier_ids[entry["name"]] = cursor.lastrowid
    return supplier_ids


def insert_products(cursor, supplier_ids: Dict[str, int]) -> Dict[str, int]:
    product_ids: Dict[str, int] = {}
    sql = """
        INSERT INTO products (name, sku, description, unit_price, stock_quantity, supplier_id,
                              category, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    for entry in PRODUCTS:
        supplier_name = entry["supplier"]
        if supplier_name not in supplier_ids:
            raise KeyError(f"Supplier '{supplier_name}' referenced by product '{entry['sku']}' is missing.")
        cursor.execute(
            sql,
            (
                entry["name"],
                entry["sku"],
                entry["description"],
                entry["unit_price"],
                entry["stock_quantity"],
                supplier_ids[supplier_name],
                entry["category"],
                entry["created_at"],
                entry["updated_at"],
            ),
        )
        product_ids[entry["sku"]] = cursor.lastrowid
    return product_ids


def insert_orders(cursor, user_ids: Dict[str, int], product_ids: Dict[str, int]) -> int:
    order_sql = """
        INSERT INTO orders (customer_id, status, order_date, total_amount, delivery_address, order_type)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    item_sql = """
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (%s, %s, %s, %s)
    """
    inserted_orders = 0
    for order in ORDERS:
        customer_username = order["customer"]
        if customer_username not in user_ids:
            raise KeyError(f"Customer '{customer_username}' referenced by order is missing.")
        total_amount = sum(item["unit_price"] * item["quantity"] for item in order["items"])
        cursor.execute(
            order_sql,
            (
                user_ids[customer_username],
                order["status"],
                order["order_date"],
                total_amount,
                order["delivery_address"],
                order["order_type"],
            ),
        )
        order_id = cursor.lastrowid
        inserted_orders += 1

        for item in order["items"]:
            sku = item["sku"]
            if sku not in product_ids:
                raise KeyError(f"Product '{sku}' referenced in order is missing.")
            cursor.execute(
                item_sql,
                (order_id, product_ids[sku], item["quantity"], item["unit_price"]),
            )
    return inserted_orders


def main():
    print_connection_banner()
    with db_cursor() as (_, cursor):
        ensure_schema(cursor)
        truncate_tables(cursor)

        user_ids = insert_users(cursor)
        supplier_ids = insert_suppliers(cursor)
        product_ids = insert_products(cursor, supplier_ids)
        order_count = insert_orders(cursor, user_ids, product_ids)

    print(f"Inserted {len(user_ids)} users.")
    print(f"Inserted {len(supplier_ids)} suppliers.")
    print(f"Inserted {len(product_ids)} products.")
    print(f"Inserted {order_count} orders and related order items.")
    print("Sample data loaded successfully.")


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
    except Exception as exc:
        print(f"Failed to seed data: {exc}")
        raise SystemExit(1)

