"""Utility script to generate additional customers, orders, and order details for QLST."""
from __future__ import annotations

import argparse
import random
from datetime import date, datetime, time, timedelta
from decimal import Decimal
from typing import Dict, List, Sequence, Tuple

from db_utils import (
    DatabaseDriverNotInstalled,
    db_cursor,
    get_db_config,
    hash_password,
    print_connection_banner,
)

REQUIRED_TABLES = ("users", "customers", "orders", "order_details", "products")
DEFAULT_END = date.today()
DEFAULT_START = date(2025, 1, 1)  # Changed to 01/01/2025
PASSWORD_DEFAULT = "customer123"

FIRST_NAMES = (
    "Anh", "Binh", "Chi", "Dung", "Giang", "Hoa", "Khanh", "Lam", 
    "Minh", "Ngoc", "Phuong", "Quynh", "Son", "Trang", "Vy",
    "Hung", "Linh", "Hieu", "Thao", "Thanh", "Tuan", "Mai",
    "Huong", "Hai", "Long", "Duc", "Phuc", "Huy", "Quan", "Dat",
)
LAST_NAMES = (
    "Nguyen", "Tran", "Le", "Pham", "Hoang", "Vu", "Dang", "Bui", 
    "Do", "Vo", "Ngo", "Duong", "Ly", "Dinh", "Truong",
)
STREETS = (
    "Nguyen Trai", "Le Loi", "Hai Ba Trung", "Dien Bien Phu", 
    "Ly Thuong Kiet", "Ba Trieu", "Pham Ngu Lao", "Tran Hung Dao",
    "Vo Thi Sau", "Nguyen Hue", "Dong Khoi", "Le Duan",
)
DISTRICTS = (
    "Quan 1, TP. Ho Chi Minh",
    "Quan 3, TP. Ho Chi Minh",
    "Quan 5, TP. Ho Chi Minh",
    "Quan 7, TP. Ho Chi Minh",
    "Quan 10, TP. Ho Chi Minh",
    "Hoan Kiem, Ha Noi",
    "Hai Ba Trung, Ha Noi",
    "Dong Da, Ha Noi",
    "Cau Giay, Ha Noi",
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
        description="Sinh thêm khách hàng, đơn hàng và chi tiết đơn hàng để thử nghiệm",
    )
    parser.add_argument(
        "--customers",
        type=int,
        default=50,
        help="Số lượng khách hàng mới cần tạo.",
    )
    parser.add_argument(
        "--orders",
        type=int,
        default=200,
        help="Số lượng đơn hàng ngẫu nhiên cần tạo thêm.",
    )
    parser.add_argument(
        "--start-date",
        type=date.fromisoformat,
        default=DEFAULT_START,
        help="Ngày bắt đầu cho khoảng thời gian đơn hàng (YYYY-MM-DD).",
    )
    parser.add_argument(
        "--end-date",
        type=date.fromisoformat,
        default=DEFAULT_END,
        help="Ngày kết thúc cho khoảng thời gian đơn hàng (YYYY-MM-DD).",
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
    if args.orders < 0:
        parser.error("Số lượng đơn hàng phải không âm.")
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


def generate_custom_id(prefix: str, number: int) -> str:
    """Generate custom ID format like ND001, KH001, DH001, etc."""
    return f"{prefix}{number:03d}"


def get_next_id_number(cursor, table: str, prefix: str) -> int:
    """Get the next available ID number for a table."""
    cursor.execute(f"SELECT id FROM {table} ORDER BY id DESC LIMIT 1")
    result = cursor.fetchone()
    if result:
        last_id = result[0]
        # Extract number from ID like "ND111" -> 111
        last_num = int(last_id[len(prefix):])
        return last_num + 1
    return 1


def generate_username(existing: Sequence[str], base_name: str) -> str:
    username = base_name
    index = 1
    while username in existing:
        username = f"{base_name}{index}"
        index += 1
    return username


def insert_customers(cursor, count: int) -> Dict[str, str]:
    """Insert new customers and their corresponding users.
    
    Returns:
        Dict mapping customer_id to full_name
    """
    # Get existing usernames and emails
    existing_usernames = set()
    existing_emails = set()
    cursor.execute("SELECT username FROM users")
    existing_usernames.update(username for (username,) in cursor.fetchall())
    cursor.execute("SELECT email FROM users")
    existing_emails.update(email for (email,) in cursor.fetchall())

    # Get next ID numbers
    next_user_num = get_next_id_number(cursor, "users", "ND")
    next_customer_num = get_next_id_number(cursor, "customers", "KH")

    customer_ids: Dict[str, str] = {}
    
    for i in range(count):
        full_name = random_full_name()
        base_username = full_name.lower().replace(" ", "_")
        username = generate_username(existing_usernames, base_username)
        
        # Generate unique email
        email = f"{username}@example.com"
        email_index = 1
        while email in existing_emails:
            email = f"{username}{email_index}@example.com"
            email_index += 1
        
        phone = f"09{random.randint(10000000, 99999999)}"
        created_at = datetime.combine(
            date.today() - timedelta(days=random.randint(0, 300)), 
            time(hour=random.randint(8, 17), minute=random.randint(0, 59))
        )

        user_id = generate_custom_id("ND", next_user_num + i)
        
        # Insert user
        cursor.execute(
            """
            INSERT INTO users (id, username, password_hash, role, full_name, email, phone_number, created_at)
            VALUES (%s, %s, %s, 'CUSTOMER', %s, %s, %s, %s)
            """,
            (
                user_id,
                username,
                hash_password(PASSWORD_DEFAULT),
                full_name,
                email,
                phone,
                created_at,
            ),
        )
        
        customer_id = generate_custom_id("KH", next_customer_num + i)
        
        # Insert customer
        cursor.execute(
            """
            INSERT INTO customers (id, full_name, email, phone_number, address, joined_at, user_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                customer_id,
                full_name,
                email,
                phone,
                random_address(),
                created_at,
                user_id,
            ),
        )
        customer_ids[customer_id] = full_name
        existing_usernames.add(username)
        existing_emails.add(email)
        
    return customer_ids


def fetch_all_customer_ids(cursor) -> List[str]:
    """Fetch all customer IDs from database."""
    cursor.execute("SELECT id FROM customers")
    return [customer_id for (customer_id,) in cursor.fetchall()]


def fetch_all_products(cursor) -> List[Tuple[str, Decimal]]:
    """Fetch all products with their IDs and prices.
    
    Returns:
        List of tuples (product_id, price)
    """
    cursor.execute("SELECT id, price FROM products WHERE quantity > 0")
    return [(product_id, Decimal(str(price))) for product_id, price in cursor.fetchall()]


def insert_orders(cursor, customer_ids: Sequence[str], count: int, start: date, end: date) -> List[str]:
    """Insert random orders for customers.
    
    Returns:
        List of created order IDs
    """
    if not customer_ids or count == 0:
        return []
    
    start_dt = datetime.combine(start, time.min)
    delta_days = (end - start).days or 1
    
    next_order_num = get_next_id_number(cursor, "orders", "DH")
    order_ids: List[str] = []

    for i in range(count):
        customer_id = random.choice(customer_ids)
        
        # Random order date between start and end
        random_day = start_dt + timedelta(days=random.randint(0, delta_days))
        order_date = random_day + timedelta(
            hours=random.randint(8, 20),
            minutes=random.randint(0, 59),
        )
        
        order_id = generate_custom_id("DH", next_order_num + i)
        
        # Generate delivery invoice number
        date_str = order_date.strftime("%Y%m%d")
        invoice_num = f"INV-{date_str}-{next_order_num + i:04d}"
        
        # We'll calculate total_price after adding order_details
        # For now, insert with placeholder
        cursor.execute(
            """
            INSERT INTO orders (id, order_date, total_price, delivery_invoice_number, created_at, customer_id)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                order_id,
                order_date,
                Decimal("0.00"),  # Placeholder
                invoice_num,
                order_date,
                customer_id,
            ),
        )
        order_ids.append(order_id)
    
    return order_ids


def insert_order_details(cursor, order_ids: Sequence[str], products: List[Tuple[str, Decimal]]) -> None:
    """Insert order details for each order and update order total_price."""
    if not order_ids or not products:
        return
    
    for order_id in order_ids:
        # Each order has 1-5 different products
        num_items = random.randint(1, min(5, len(products)))
        selected_products = random.sample(products, num_items)
        
        total_price = Decimal("0.00")
        
        for product_id, unit_price in selected_products:
            quantity = random.randint(1, 10)
            line_price = unit_price * Decimal(str(quantity))
            total_price += line_price
            
            cursor.execute(
                """
                INSERT INTO order_details (order_id, product_id, quantity, price)
                VALUES (%s, %s, %s, %s)
                """,
                (
                    order_id,
                    product_id,
                    quantity,
                    unit_price,
                ),
            )
        
        # Update order total_price
        cursor.execute(
            """
            UPDATE orders SET total_price = %s WHERE id = %s
            """,
            (total_price, order_id),
        )


def main() -> None:
    args = parse_arguments()
    if args.seed is not None:
        random.seed(args.seed)

    print_connection_banner()
    with db_cursor() as (_, cursor):
        ensure_schema(cursor)
        
        # Create new customers
        print(f"Tạo {args.customers} khách hàng mới...")
        new_customer_ids = insert_customers(cursor, args.customers)
        
        # Get all customer IDs (including existing ones)
        all_customer_ids = fetch_all_customer_ids(cursor)
        
        # Get all available products
        products = fetch_all_products(cursor)
        if not products:
            print("⚠️  Không có sản phẩm nào trong database. Vui lòng thêm sản phẩm trước.")
            return
        
        # Create orders
        print(f"Tạo {args.orders} đơn hàng...")
        order_ids = insert_orders(cursor, all_customer_ids, args.orders, args.start_date, args.end_date)
        
        # Create order details
        print(f"Tạo chi tiết đơn hàng...")
        insert_order_details(cursor, order_ids, products)
        
    print(f"\n✅ Hoàn thành!")
    print(f"   - Đã tạo {args.customers} khách hàng mới")
    print(f"   - Đã tạo {args.orders} đơn hàng")
    print(f"   - Thời gian đơn hàng: {args.start_date} đến {args.end_date}")


if __name__ == "__main__":
    try:
        main()
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
