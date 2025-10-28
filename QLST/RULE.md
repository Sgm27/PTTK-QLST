# RULE.md - Quy tắc thiết kế và phát triển hệ thống QLST

## 📋 Tổng quan
Hướng dẫn cho AI coding assistant xây dựng hệ thống Quản lý Sàn thương mại (QLST) với giao diện đẹp, dễ sử dụng, kiến trúc 4 lớp chuẩn.

---

## 🎨 THIẾT KẾ GIAO DIỆN

### 1. Màu sắc - CHỈ 2 MÀU CHÍNH
**Xanh dương nhạt (Primary):**
- Chính: `#2563eb`
- Hover: `#3b82f6`
- Active: `#1e40af`
- Background nhạt: `#dbeafe`
- Background cực nhạt: `#eff6ff`

**Trắng (Background):**
- Trắng thuần: `#ffffff`
- Trắng xám: `#f8fafc`
- Alternate rows: `#f1f5f9`

**Màu bổ trợ (tối thiểu):**
- Text chính: `#1e293b`
- Text phụ: `#64748b`
- Border: `#e2e8f0`
- Shadow: `rgba(37, 99, 235, 0.08)`

### 2. Typography & Spacing
- Font: `Inter, Segoe UI, sans-serif`
- Sizes: 12px → 14px → 16px → 18px → 20px → 24px → 30px
- Spacing: 4px, 8px, 16px, 24px, 32px, 48px
- Border radius: 6px (nhỏ), 8px (medium), 12px (lớn)

### 3. Layout
- Container tối đa: **1200px**
- Responsive breakpoints: 640px, 768px, 1024px, 1280px
- Grid/Flexbox cho bố cục
- Khoảng cách nhất quán

---

## 🏗️ KIẾN TRÚC 4 LỚP

### 1. INTERFACE (JSP) - `src/main/webapp/jsp/`

#### Các trang cần có:

**a) login.jsp**
- Form username/password
- Link đến register
- Validation + Error messages

**b) register.jsp**
- Form: username, password, full_name, email, phone_number, address
- Checkbox chọn role (CUSTOMER/MANAGER)
- Validation đầy đủ

**c) customer_statistics.jsp** ⭐ **TÁCH RIÊNG**
- CHỈ hiển thị bảng tổng hợp doanh thu
- Form chọn khoảng thời gian
- Cột: Mã KH, Họ tên, Tổng doanh thu, Số GD, Button "Xem chi tiết"
- Sắp xếp theo doanh thu giảm dần
- Highlight row khi hover

**d) transaction_details.jsp** ⭐ **TÁCH RIÊNG**
- CHỈ hiển thị chi tiết giao dịch 1 khách hàng
- Breadcrumb navigation
- Card thông tin KH: tên, email, phone, address, tổng chi tiêu
- Bảng giao dịch: Mã GD, Ngày giờ, Mô tả, Số tiền
- Nút quay lại

**e) dashboard.jsp** (Optional)
- Tổng quan hệ thống
- Widgets thống kê

### 2. SERVLET - `src/main/java/com/qlst/servlet/`

**a) LoginServlet** - `/login`
- GET: Hiển thị form
- POST: Xác thực, session, redirect theo role

**b) RegisterServlet** - `/register`
- GET: Hiển thị form
- POST: Tạo user + customer, validate, hash password

**c) CustomerStatisticsServlet** ⭐ - `/statistics/customers`
- GET/POST: Form + bảng thống kê
- setAttribute: customerRevenue, startDate, endDate

**d) TransactionDetailsServlet** ⭐ - `/statistics/transactions`
- GET params: customerId, startDate, endDate
- setAttribute: customer, transactions, totalAmount

**e) LogoutServlet** - `/logout`
- Invalidate session, redirect

### 3. DAO - `src/main/java/com/qlst/dao/`

**a) UserDAO**
- `findByUsername()`, `save()`, `existsByEmail()`

**b) CustomerDAO**
- `findByUserId()`, `findById()`, `findAll()`, `save()`

**c) TransactionDAO** ⭐
- `findByCustomerAndDateRange()`, `save()`, `calculateTotal()`

**d) StatisticsDAO**
- `calculateCustomerRevenue(startDate, endDate)`

**Quy tắc:**
- PreparedStatement (tránh SQL Injection)
- Try-with-resources
- Return Optional<T> hoặc List<T>

### 4. ENTITY - `src/main/java/com/qlst/entity/`

**Có sẵn:** User, Customer, Transaction

**DTO:** CustomerRevenue (customerId, customerName, revenue, transactionCount)

---

## 📊 DATABASE

### Schema (KHÔNG được sửa):
```
users: id, username, password_hash, role, full_name, email, phone_number, created_at
customers: id, user_id (FK), full_name, email, phone_number, address, joined_at
transactions: id, customer_id (FK), amount, transaction_date, description
```

### Quy tắc:
- Đọc `script/create_tables.py` và `script/seed_data.py`
- Match chính xác tên cột, kiểu dữ liệu
- BigDecimal cho amount (scale=2)
- LocalDateTime → Timestamp cho SQL

---

## 🎯 COMPONENTS CHUẨN

### 1. Header
- Logo QLST
- Navigation: Login/Register hoặc User info + Logout
- Hiển thị role-based menu

### 2. Form
- Label rõ ràng
- Input với validation
- Error messages
- Primary/Secondary buttons

### 3. Table
- Header với background xanh nhạt
- Hover effect
- Text-right cho số tiền
- Format currency: ₫

### 4. Card
- Header với title
- Body với content
- Footer với actions

### 5. Alert
- Success: xanh dương nhạt
- Error: đỏ nhạt

---

## 📱 RESPONSIVE

- Mobile first approach
- Breakpoints: 768px, 1024px
- Table overflow-x: auto
- Padding điều chỉnh theo screen size

---

## ✨ UX/UI PRINCIPLES

- Form validation rõ ràng
- Loading states
- Success/Error feedback
- Empty states
- Hover/Focus effects
- Breadcrumb navigation
- Keyboard support

---

## 🔒 SECURITY

### Authentication
- Filter check session cho protected routes
- Public paths: /login, /register, /assets/

### Password
- Hash với SHA-256

### SQL Injection
- LUÔN dùng PreparedStatement
- KHÔNG concat string

### XSS
- Dùng `<c:out value="${...}"/>`
- Validate input

---

## 📝 CODING STANDARDS

**Java:**
- Classes: PascalCase
- Variables/Methods: camelCase
- Constants: UPPER_SNAKE_CASE

**JSP:**
- UTF-8 encoding
- JSTL tags: c, fmt
- Include header/footer
- 4 spaces indent

**CSS:**
- BEM naming
- Utility classes
- CSS variables

---

## 🚀 WORKFLOW

### Khi tạo/sửa trang:

**BƯỚC 1: Phân tích**
1. Đọc database schema
2. Xác định entities, DAOs
3. Thiết kế flow

**BƯỚC 2: Backend**
1. Entity classes
2. DAO classes
3. Servlet classes

**BƯỚC 3: Frontend**
1. JSP structure
2. CSS (trắng + xanh dương)
3. Responsive
4. Validation

**BƯỚC 4: Integration**
1. Test flow
2. Error handling
3. Security
4. Performance

---

## 📚 CHECKLIST

Mỗi trang phải có:
- [ ] Entity/DTO (nếu cần)
- [ ] DAO methods
- [ ] Servlet (doGet/doPost)
- [ ] JSP (header/footer)
- [ ] CSS theo color scheme
- [ ] Responsive
- [ ] Validation (client + server)
- [ ] Error handling
- [ ] Messages
- [ ] Authentication
- [ ] Test với database

---

## ⚠️ ĐIỀU KIỆN BẮT BUỘC

1. **MÀU SẮC**: CHỈ trắng + xanh dương nhạt
2. **TÁCH TRANG**: Statistics ≠ Transaction Details
3. **4 LỚP**: JSP → Servlet → DAO → Entity
4. **DATABASE**: Match 100% với script/
5. **GIAO DIỆN ĐẸP**: Spacing đều, alignment chuẩn, shadow tinh tế
6. **RESPONSIVE**: Mobile/Tablet/Desktop
7. **DỄ SỬ DỤNG**: Clear navigation, feedback, error handling

---

## 📧 KẾT LUẬN

**AI Assistant phải:**
- ✅ Đọc kỹ database schema trong `script/`
- ✅ Tuân thủ color scheme
- ✅ Tách biệt trang thống kê và chi tiết giao dịch
- ✅ Áp dụng kiến trúc 4 lớp
- ✅ Ưu tiên giao diện đẹp, professional
- ✅ Đảm bảo backend match database
- ✅ Test kỹ mọi tính năng

**Mục tiêu**: Web app Java JSP/Servlet đẹp, chuyên nghiệp, dễ sử dụng, minimalist 2 màu, kiến trúc rõ ràng, code chất lượng cao.
