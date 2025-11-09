"""Script to verify data integrity after running generate_bulk_data.py"""
from db_utils import db_cursor, print_connection_banner, DatabaseDriverNotInstalled
from datetime import date


def verify_foreign_keys(cursor):
    """Verify all foreign key constraints."""
    print("\n🔍 Kiểm tra ràng buộc khóa ngoại...")
    
    issues = []
    
    # Check customers.user_id -> users.id
    cursor.execute("""
        SELECT c.id, c.user_id 
        FROM tblCustomers c 
        LEFT JOIN tblUsers u ON c.user_id = u.id 
        WHERE u.id IS NULL
    """)
    orphaned_customers = cursor.fetchall()
    if orphaned_customers:
        issues.append(f"❌ {len(orphaned_customers)} khách hàng không có user_id hợp lệ")
    else:
        print("   ✅ Customers.user_id -> Users.id: OK")
    
    # Check orders.customer_id -> customers.id
    cursor.execute("""
        SELECT o.id, o.customer_id 
        FROM tblOrders o 
        LEFT JOIN tblCustomers c ON o.customer_id = c.id 
        WHERE c.id IS NULL
    """)
    orphaned_orders = cursor.fetchall()
    if orphaned_orders:
        issues.append(f"❌ {len(orphaned_orders)} đơn hàng không có customer_id hợp lệ")
    else:
        print("   ✅ Orders.customer_id -> Customers.id: OK")
    
    # Check order_details.order_id -> orders.id
    cursor.execute("""
        SELECT od.order_id 
        FROM tblOrderDetails od 
        LEFT JOIN tblOrders o ON od.order_id = o.id 
        WHERE o.id IS NULL
    """)
    orphaned_order_details = cursor.fetchall()
    if orphaned_order_details:
        issues.append(f"❌ {len(orphaned_order_details)} chi tiết đơn không có order_id hợp lệ")
    else:
        print("   ✅ Order_details.order_id -> Orders.id: OK")
    
    # Check order_details.product_id -> products.id
    cursor.execute("""
        SELECT od.order_id, od.product_id 
        FROM tblOrderDetails od 
        LEFT JOIN tblProducts p ON od.product_id = p.id 
        WHERE p.id IS NULL
    """)
    orphaned_products = cursor.fetchall()
    if orphaned_products:
        issues.append(f"❌ {len(orphaned_products)} chi tiết đơn không có product_id hợp lệ")
    else:
        print("   ✅ Order_details.product_id -> Products.id: OK")
    
    return issues


def verify_unique_constraints(cursor):
    """Verify unique constraints."""
    print("\n🔍 Kiểm tra ràng buộc duy nhất...")
    
    issues = []
    
    # Check duplicate usernames
    cursor.execute("""
        SELECT username, COUNT(*) as cnt 
        FROM tblUsers 
        GROUP BY username 
        HAVING cnt > 1
    """)
    dup_usernames = cursor.fetchall()
    if dup_usernames:
        issues.append(f"❌ {len(dup_usernames)} username bị trùng")
    else:
        print("   ✅ Username unique: OK")
    
    # Check duplicate emails
    cursor.execute("""
        SELECT email, COUNT(*) as cnt 
        FROM tblUsers 
        GROUP BY email 
        HAVING cnt > 1
    """)
    dup_emails = cursor.fetchall()
    if dup_emails:
        issues.append(f"❌ {len(dup_emails)} email bị trùng")
    else:
        print("   ✅ Email unique: OK")
    
    return issues


def verify_order_totals(cursor):
    """Verify order total prices match sum of order details."""
    print("\n🔍 Kiểm tra tổng giá đơn hàng...")
    
    cursor.execute("""
        SELECT 
            o.id,
            o.total_price as order_total,
            COALESCE(SUM(od.quantity * od.price), 0) as calculated_total
        FROM tblOrders o
        LEFT JOIN tblOrderDetails od ON o.id = od.order_id
        GROUP BY o.id, o.total_price
        HAVING ABS(o.total_price - calculated_total) > 0.01
    """)
    
    mismatched_orders = cursor.fetchall()
    if mismatched_orders:
        print(f"   ❌ {len(mismatched_orders)} đơn hàng có tổng giá không khớp:")
        for order_id, order_total, calc_total in mismatched_orders[:5]:
            print(f"      - {order_id}: Lưu={order_total}, Tính={calc_total}")
        return [f"❌ {len(mismatched_orders)} đơn hàng có tổng giá không khớp"]
    else:
        print("   ✅ Tổng giá đơn hàng: OK")
        return []


def verify_date_range(cursor):
    """Verify order dates are in expected range."""
    print("\n🔍 Kiểm tra khoảng thời gian đơn hàng...")
    
    cursor.execute("""
        SELECT 
            MIN(order_date) as min_date,
            MAX(order_date) as max_date
        FROM tblOrders
    """)
    
    result = cursor.fetchone()
    if result:
        min_date, max_date = result
        print(f"   📅 Đơn hàng cũ nhất: {min_date}")
        print(f"   📅 Đơn hàng mới nhất: {max_date}")
        
        # Check if dates are reasonable (2025-01-01 to today)
        expected_start = date(2025, 1, 1)
        expected_end = date.today()
        
        if min_date.date() < expected_start:
            return [f"⚠️  Có đơn hàng trước 2025-01-01: {min_date}"]
        if max_date.date() > expected_end:
            return [f"⚠️  Có đơn hàng sau hôm nay: {max_date}"]
        
        print("   ✅ Khoảng thời gian hợp lệ")
    
    return []


def verify_customer_roles(cursor):
    """Verify all customers have role='CUSTOMER'."""
    print("\n🔍 Kiểm tra role của khách hàng...")
    
    cursor.execute("""
        SELECT u.id, u.username, u.role
        FROM tblUsers u
        JOIN tblCustomers c ON c.user_id = u.id
        WHERE u.role != 'CUSTOMER'
    """)
    
    invalid_roles = cursor.fetchall()
    if invalid_roles:
        print(f"   ❌ {len(invalid_roles)} khách hàng có role không hợp lệ:")
        for user_id, username, role in invalid_roles[:5]:
            print(f"      - {user_id} ({username}): role={role}")
        return [f"❌ {len(invalid_roles)} khách hàng có role không hợp lệ"]
    else:
        print("   ✅ Tất cả khách hàng có role='CUSTOMER': OK")
        return []


def print_statistics(cursor):
    """Print database statistics."""
    print("\n📊 Thống kê dữ liệu:")
    
    # Count managers
    cursor.execute("SELECT COUNT(*) FROM tblUsers WHERE role = 'MANAGER'")
    manager_count = cursor.fetchone()[0]
    print(f"   - Managers: {manager_count}")
    
    # Count customers
    cursor.execute("SELECT COUNT(*) FROM tblCustomers")
    customer_count = cursor.fetchone()[0]
    print(f"   - Customers: {customer_count}")
    
    # Count orders
    cursor.execute("SELECT COUNT(*) FROM tblOrders")
    order_count = cursor.fetchone()[0]
    print(f"   - Orders: {order_count}")
    
    # Count order details
    cursor.execute("SELECT COUNT(*) FROM tblOrderDetails")
    order_detail_count = cursor.fetchone()[0]
    print(f"   - Order Details: {order_detail_count}")
    
    # Average items per order
    if order_count > 0:
        avg_items = order_detail_count / order_count
        print(f"   - Trung bình sản phẩm/đơn: {avg_items:.2f}")
    
    # Total revenue
    cursor.execute("SELECT SUM(total_price) FROM tblOrders")
    total_revenue = cursor.fetchone()[0] or 0
    print(f"   - Tổng doanh thu: {total_revenue:,.0f} VNĐ")


def main():
    print("="*60)
    print("KIỂM TRA TÍNH TOÀN VẸN DỮ LIỆU")
    print("="*60)
    
    print_connection_banner()
    
    all_issues = []
    
    with db_cursor() as (_, cursor):
        # Run all verification checks
        all_issues.extend(verify_foreign_keys(cursor))
        all_issues.extend(verify_unique_constraints(cursor))
        all_issues.extend(verify_order_totals(cursor))
        all_issues.extend(verify_date_range(cursor))
        all_issues.extend(verify_customer_roles(cursor))
        
        # Print statistics
        print_statistics(cursor)
    
    # Summary
    print("\n" + "="*60)
    if all_issues:
        print("❌ KẾT QUẢ: Phát hiện các vấn đề:")
        for issue in all_issues:
            print(f"   {issue}")
        return 1
    else:
        print("✅ KẾT QUẢ: Tất cả kiểm tra đều PASS!")
        print("   Dữ liệu đảm bảo tính toàn vẹn.")
    print("="*60)
    return 0


if __name__ == "__main__":
    try:
        exit(main())
    except DatabaseDriverNotInstalled as error:
        print(error)
        raise SystemExit(1)
