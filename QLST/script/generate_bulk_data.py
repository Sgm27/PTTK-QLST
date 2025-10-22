"""Utility to generate a large volume of realistic demo data for QLST.

The base ``seed_data.py`` script inserts a concise set of fixtures. For
performance testing or demonstrating reporting features we often need
tens or hundreds of additional customers and orders. This helper focuses
on that scenario while keeping the logic deterministic and dependency
free (no Faker required).
"""
from __future__ import annotations

import argparse
import random
from datetime import date, datetime, time, timedelta
from decimal import Decimal
from typing import Dict, Iterable, List, Sequence, Tuple

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    get_db_config,
    hash_password,
    print_connection_banner,
)
from seed_data import PRODUCTS, REQUIRED_TABLES, SUPPLIERS


DEFAULT_END = date.today()
DEFAULT_START = DEFAULT_END - timedelta(days=120)
ORDER_STATUSES = ("COMPLETED", "APPROVED", "PENDING", "CANCELLED")
ORDER_TYPES = ("ONLINE", "IN_STORE")
FIRST_NAMES = [
    "Anh",
    "Binh",
    "Chi",
    "Dung",
    "Giang",
    "Hoa",
    "Khanh",
    "Lam",
    "Minh",
    "Ngoc",
    "Phuong",
    "Quynh",
    "Son",
    "Trang",
    "Vy",
]
LAST_NAMES = [
    "Nguyen",
    "Tran",
    "Le",
    "Pham",
    "Hoang",
    "Vu",
    "Dang",
    "Bui",
    "Do",
    "Vo",
]
STREETS = [
    "Nguyen Trai",
    "Le Loi",
    "Hai Ba Trung",
    "Dien Bien Phu",
    "Ly Thuong Kiet",
    "Ba Trieu",
    "Pham Ngu Lao",
    "Tran Hung Dao",
]
DISTRICTS = [
    "Quan 1, TP. Ho Chi Minh",
    "Quan 3, TP. Ho Chi Minh",
    "Quan 5, TP. Ho Chi Minh",
    "Quan 7, TP. Ho Chi Minh",
    "Hoan Kiem, Ha Noi",
    "Hai Ba Trung, Ha Noi",
    "Dong Da, Ha Noi",
]


def non_negative_int(value: str) -> int:
    integer = int(value)
    if integer < 0:
        raise argparse.ArgumentTypeError("Giá trị phải không âm.")
    return integer


def positive_int(value: str) -> int:
    integer = int(value)
    if integer <= 0:
        raise argparse.ArgumentTypeError("Giá trị phải lớn hơn 0.")
    return integer


def parse_date(value: str) -> date:
    try:
        return date.fromisoformat(value)
    except ValueError as exc:  # pragma: no cover - defensive parsing guard
        raise argparse.ArgumentTypeError(f"Không thể phân tích ngày '{value}': {exc}") from exc


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Tạo thêm dữ liệu khách hàng và đơn hàng cho hệ thống QLST",
    )
    parser.add_argument(
        "--customers",
        type=non_negative_int,
        default=25,
        help="Số lượng khách hàng mới cần tạo (0 nếu chỉ muốn thêm đơn hàng).",
    )
    parser.add_argument(
        "--orders",
        type=non_negative_int,
        default=120,
        help="Tổng số đơn hàng ngẫu nhiên sẽ được sinh.",
    )
    parser.add_argument(
        "--min-items",
        type=positive_int,
        default=1,
        help="Số lượng mặt hàng tối thiểu trong mỗi đơn.",
    )
    parser.add_argument(
        "--max-items",
        type=positive_int,
        default=4,
        help="Số lượng mặt hàng tối đa trong mỗi đơn.",
    )
    parser.add_argument(
        "--start-date",
        type=parse_date,
        default=DEFAULT_START,
        help="Ngày bắt đầu cho thời gian tạo giao dịch (định dạng YYYY-MM-DD).",
    )
    parser.add_argument(
        "--end-date",
        type=parse_date,
        default=DEFAULT_END,
        help="Ngày kết thúc cho thời gian tạo giao dịch (định dạng YYYY-MM-DD).",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Thiết lập seed cho bộ tạo số ngẫu nhiên để tái lập dữ liệu.",
    )
    args = parser.parse_args()
    if args.end_date < args.start_date:
        parser.error("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu.")
    if args.min_items > args.max_items:
        parser.error("Giới hạn mặt hàng không hợp lệ: min phải nhỏ hơn hoặc bằng max.")
    return args


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


def ensure_suppliers(cursor) -> Dict[str, int]:
    cursor.execute("SELECT id, name FROM suppliers")
    suppliers = {name: supplier_id for supplier_id, name in cursor.fetchall()}
    for entry in SUPPLIERS:
        if entry["name"] not in suppliers:
            cursor.execute(
                """
                INSERT INTO suppliers (name, contact_name, email, phone, address, notes)
                VALUES (%s, %s, %s, %s, %s, %s)
                """,
                (
                    entry["name"],
                    entry["contact_name"],
                    entry["email"],
                    entry["phone"],
                    entry["address"],
                    entry["notes"],
                ),
            )
            suppliers[entry["name"]] = cursor.lastrowid
    return suppliers


def ensure_products(cursor, supplier_ids: Dict[str, int]) -> List[Dict[str, object]]:
    cursor.execute("SELECT id, sku, unit_price FROM products")
    existing = {sku: (product_id, Decimal(str(price))) for product_id, sku, price in cursor.fetchall()}
    for entry in PRODUCTS:
        sku = entry["sku"]
        if sku in existing:
            continue
        supplier_name = entry["supplier"]
        if supplier_name not in supplier_ids:
            raise KeyError(
                f"Nhà cung cấp '{supplier_name}' không tồn tại, không thể thêm sản phẩm '{sku}'."
            )
        cursor.execute(
            """
            INSERT INTO products (name, sku, description, unit_price, stock_quantity, supplier_id,
                                  category, created_at, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (
                entry["name"],
                sku,
                entry["description"],
                entry["unit_price"],
                entry["stock_quantity"],
                supplier_ids[supplier_name],
                entry["category"],
                entry["created_at"],
                entry["updated_at"],
            ),
        )
        existing[sku] = (cursor.lastrowid, Decimal(str(entry["unit_price"])))

    cursor.execute("SELECT id, sku, unit_price FROM products")
    return [
        {"id": product_id, "sku": sku, "unit_price": Decimal(str(price))}
        for product_id, sku, price in cursor.fetchall()
    ]


def random_datetime(start: date, end: date) -> datetime:
    start_dt = datetime.combine(start, time.min)
    end_dt = datetime.combine(end, time.max.replace(microsecond=0))
    total_seconds = int((end_dt - start_dt).total_seconds())
    if total_seconds <= 0:
        return start_dt
    offset = random.randint(0, total_seconds)
    return start_dt + timedelta(seconds=offset)


def generate_phone_number() -> str:
    return "0" + "9" + "".join(str(random.randint(0, 9)) for _ in range(8))


def generate_address() -> str:
    street = random.choice(STREETS)
    number = random.randint(12, 999)
    district = random.choice(DISTRICTS)
    return f"{number} {street}, {district}"


def create_customers(cursor, count: int, start_date: date, end_date: date) -> List[int]:
    if count <= 0:
        return []
    cursor.execute("SELECT username FROM users")
    existing_usernames = {row[0] for row in cursor.fetchall()}
    new_ids: List[int] = []
    for index in range(count):
        base_username = f"customer_bulk_{index + 1}"
        username = base_username
        suffix = 1
        while username in existing_usernames:
            suffix += 1
            username = f"{base_username}_{suffix}"
        existing_usernames.add(username)
        first = random.choice(FIRST_NAMES)
        last = random.choice(LAST_NAMES)
        full_name = f"{last} {first}"
        created_at = random_datetime(start_date - timedelta(days=30), end_date)
        cursor.execute(
            """
            INSERT INTO users (username, password_hash, role, full_name, email, phone_number, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                username,
                hash_password("customer123"),
                "CUSTOMER",
                full_name,
                f"{username}@bulk.example.com",
                generate_phone_number(),
                created_at,
            ),
        )
        new_ids.append(cursor.lastrowid)
    return new_ids


def fetch_customer_pool(cursor) -> List[Tuple[int, str]]:
    cursor.execute("SELECT id, full_name FROM users WHERE role = 'CUSTOMER'")
    return [(row[0], row[1]) for row in cursor.fetchall()]


def choose_products(products: Sequence[Dict[str, object]], count: int) -> Iterable[Dict[str, object]]:
    if not products:
        return []
    if count >= len(products):
        return random.sample(products, len(products))
    return random.sample(products, count)


def create_orders(
    cursor,
    customers: Sequence[Tuple[int, str]],
    products: Sequence[Dict[str, object]],
    order_count: int,
    start_date: date,
    end_date: date,
    min_items: int,
    max_items: int,
) -> Tuple[int, int]:
    if order_count <= 0 or not customers or not products:
        return 0, 0
    inserted_orders = 0
    inserted_items = 0
    order_sql = (
        "INSERT INTO orders (customer_id, status, order_date, total_amount, delivery_address, order_type) "
        "VALUES (%s, %s, %s, %s, %s, %s)"
    )
    item_sql = (
        "INSERT INTO order_items (order_id, product_id, quantity, unit_price) "
        "VALUES (%s, %s, %s, %s)"
    )
    for _ in range(order_count):
        customer_id, _ = random.choice(customers)
        order_date = random_datetime(start_date, end_date)
        status = random.choice(ORDER_STATUSES)
        order_type = random.choice(ORDER_TYPES)
        item_total = Decimal("0")
        selected_products = choose_products(
            products,
            random.randint(min_items, max_items),
        )
        order_items = []
        for product in selected_products:
            quantity = random.randint(1, 4)
            unit_price = Decimal(product["unit_price"])
            item_total += unit_price * quantity
            order_items.append((product["id"], quantity, unit_price))
        cursor.execute(
            order_sql,
            (customer_id, status, order_date, item_total, generate_address(), order_type),
        )
        order_id = cursor.lastrowid
        inserted_orders += 1
        for product_id, quantity, unit_price in order_items:
            cursor.execute(item_sql, (order_id, product_id, quantity, unit_price))
            inserted_items += 1
    return inserted_orders, inserted_items


def main() -> None:
    args = parse_arguments()
    if args.seed is not None:
        random.seed(args.seed)

    print_connection_banner()
    with db_cursor() as (_, cursor):
        ensure_schema(cursor)
        supplier_ids = ensure_suppliers(cursor)
        products = ensure_products(cursor, supplier_ids)
        new_customers = create_customers(cursor, args.customers, args.start_date, args.end_date)
        customer_pool = fetch_customer_pool(cursor)
        orders_inserted, items_inserted = create_orders(
            cursor,
            customer_pool,
            products,
            args.orders,
            args.start_date,
            args.end_date,
            args.min_items,
            args.max_items,
        )

    print(
        "Đã tạo thêm {cust} khách hàng mới.".format(cust=len(new_customers))
    )
    print("Hiện có {total} khách hàng trong hệ thống.".format(total=len(customer_pool)))
    print("Đã thêm {orders} đơn hàng với {items} dòng chi tiết.".format(
        orders=orders_inserted,
        items=items_inserted,
    ))
    print("Hoàn tất việc sinh dữ liệu mẫu mở rộng.")


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
    except Exception as exc:  # pragma: no cover - top-level defensive guard
        print(f"Không thể sinh dữ liệu: {exc}")
        raise SystemExit(1)
