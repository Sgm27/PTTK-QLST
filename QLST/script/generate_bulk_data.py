"""Utility script to generate additional customers and transactions for QLST."""
from __future__ import annotations

import argparse
import random
from datetime import date, datetime, time, timedelta
from decimal import Decimal
from typing import Dict, List, Sequence

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    get_db_config,
    hash_password,
    print_connection_banner,
)

REQUIRED_TABLES = ("users", "customers", "transactions")
DEFAULT_END = date.today()
DEFAULT_START = date(2025, 6, 1)  
PASSWORD_DEFAULT = "customer123"

FIRST_NAMES = (
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
)
LAST_NAMES = (
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
)
STREETS = (
    "Nguyen Trai",
    "Le Loi",
    "Hai Ba Trung",
    "Dien Bien Phu",
    "Ly Thuong Kiet",
    "Ba Trieu",
    "Pham Ngu Lao",
    "Tran Hung Dao",
)
DISTRICTS = (
    "Quan 1, TP. Ho Chi Minh",
    "Quan 3, TP. Ho Chi Minh",
    "Quan 5, TP. Ho Chi Minh",
    "Quan 7, TP. Ho Chi Minh",
    "Hoan Kiem, Ha Noi",
    "Hai Ba Trung, Ha Noi",
    "Dong Da, Ha Noi",
)
DESCRIPTIONS = (
    "Mua thiết bị điện tử",
    "Thanh toán đơn hàng online",
    "Đơn hàng tại siêu thị",
    "Mua phụ kiện",
    "Gia hạn bảo hành",
    "Đặt cọc sản phẩm",
)


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Sinh thêm khách hàng và giao dịch để thử nghiệm tính năng thống kê",
    )
    parser.add_argument(
        "--customers",
        type=int,
        default=10,
        help="Số lượng khách hàng mới cần tạo.",
    )
    parser.add_argument(
        "--transactions",
        type=int,
        default=50,
        help="Số lượng giao dịch ngẫu nhiên cần tạo thêm.",
    )
    parser.add_argument(
        "--start-date",
        type=date.fromisoformat,
        default=DEFAULT_START,
        help="Ngày bắt đầu cho khoảng thời gian giao dịch (YYYY-MM-DD).",
    )
    parser.add_argument(
        "--end-date",
        type=date.fromisoformat,
        default=DEFAULT_END,
        help="Ngày kết thúc cho khoảng thời gian giao dịch (YYYY-MM-DD).",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Seed cho bộ phát số ngẫu nhiên để tái tạo dữ liệu.",
    )
    args = parser.parse_args()
    if args.customers < 0:
        parser.error("Số lượng khách hàng phải không âm.")
    if args.transactions < 0:
        parser.error("Số lượng giao dịch phải không âm.")
    if args.end_date < args.start_date:
        parser.error("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.")
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


def random_full_name() -> str:
    return f"{random.choice(LAST_NAMES)} {random.choice(FIRST_NAMES)}"


def random_address() -> str:
    return f"{random.randint(1, 200)} {random.choice(STREETS)}, {random.choice(DISTRICTS)}"


def generate_username(existing: Sequence[str], base_name: str) -> str:
    username = base_name
    index = 1
    while username in existing:
        username = f"{base_name}{index}"
        index += 1
    return username


def insert_customers(cursor, count: int) -> Dict[int, str]:
    existing_usernames = set()
    cursor.execute("SELECT username FROM users")
    existing_usernames.update(username for (username,) in cursor.fetchall())

    customer_ids: Dict[int, str] = {}
    for _ in range(count):
        full_name = random_full_name()
        base_username = full_name.lower().replace(" ", "_")
        username = generate_username(existing_usernames, base_username)
        email = f"{username}@example.com"
        phone = f"09{random.randint(10000000, 99999999)}"
        created_at = datetime.combine(date.today(), time(hour=random.randint(8, 17), minute=random.randint(0, 59)))

        cursor.execute(
            """
            INSERT INTO users (username, password_hash, role, full_name, email, phone_number, created_at)
            VALUES (%s, %s, 'CUSTOMER', %s, %s, %s, %s)
            """,
            (
                username,
                hash_password(PASSWORD_DEFAULT),
                full_name,
                email,
                phone,
                created_at,
            ),
        )
        user_id = cursor.lastrowid
        cursor.execute(
            """
            INSERT INTO customers (user_id, full_name, email, phone_number, address, joined_at)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                user_id,
                full_name,
                email,
                phone,
                random_address(),
                created_at,
            ),
        )
        customer_ids[cursor.lastrowid] = full_name
        existing_usernames.add(username)
    return customer_ids


def fetch_all_customer_ids(cursor) -> List[int]:
    cursor.execute("SELECT id FROM customers")
    return [customer_id for (customer_id,) in cursor.fetchall()]


def insert_transactions(cursor, customer_ids: Sequence[int], count: int, start: date, end: date) -> None:
    if not customer_ids or count == 0:
        return
    start_dt = datetime.combine(start, time.min)
    delta_days = (end - start).days or 1

    for _ in range(count):
        customer_id = random.choice(customer_ids)
        random_day = start_dt + timedelta(days=random.randint(0, delta_days))
        random_time = random_day + timedelta(
            hours=random.randint(8, 20),
            minutes=random.randint(0, 59),
        )
        amount = Decimal(random.randint(200_000, 5_000_000)) / Decimal("100")
        description = random.choice(DESCRIPTIONS)
        cursor.execute(
            """
            INSERT INTO transactions (customer_id, amount, transaction_date, description)
            VALUES (%s, %s, %s, %s)
            """,
            (
                customer_id,
                amount,
                random_time,
                description,
            ),
        )


def main() -> None:
    args = parse_arguments()
    if args.seed is not None:
        random.seed(args.seed)

    print_connection_banner()
    with db_cursor() as (_, cursor):
        ensure_schema(cursor)
        insert_customers(cursor, args.customers)
        all_customer_ids = fetch_all_customer_ids(cursor)
        insert_transactions(cursor, all_customer_ids, args.transactions, args.start_date, args.end_date)
    print(
        "Đã tạo thêm %s khách hàng và %s giao dịch." % (args.customers, args.transactions)
    )


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
