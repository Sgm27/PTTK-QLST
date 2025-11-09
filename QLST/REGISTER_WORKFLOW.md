# QUY TRÌNH ĐĂNG KÝ THÀNH VIÊN (MEMBER REGISTRATION WORKFLOW)

## Tổng quan
Module "Khách hàng đăng ký thành viên" cho phép người dùng tạo tài khoản mới trong hệ thống QLST. Quy trình này tuân theo kiến trúc MVC với các lớp Servlet, DAO, và Model được tổ chức rõ ràng.

---

## LUỒNG XỬ LÝ CHI TIẾT

### **Bước 1: Người dùng truy cập trang đăng ký**

**Hành động của người dùng:**
- Người dùng truy cập trang web và nhấn vào liên kết "Đăng ký" trên thanh điều hướng
- URL được gọi: `GET /register`

**Xử lý:**
- Request được chuyển đến `RegisterServlet` (đã đăng ký trong `web.xml` với pattern `/register`)
- Servlet xử lý phương thức `doGet()`
- Phương thức `doGet()` đơn giản chỉ forward request đến trang JSP

**Kết quả:**
- Servlet forward request đến JSP: `/jsp/FillInformation.jsp`

---

### **Bước 2: Hiển thị giao diện đăng ký (FillInformation.jsp)**

**Mô tả:**
JSP `FillInformation.jsp` được render để hiển thị form đăng ký với các trường thông tin cần thiết.

**Cấu trúc form:**
- **Table ID:** `tblInputInformation`
- **Các trường dữ liệu:**
  1. **Họ và tên** (`name`) - Bắt buộc
  2. **Mật khẩu** (`password`) - Bắt buộc, tối thiểu 8 ký tự
  3. **Email** (`email`) - Bắt buộc
  4. **Địa chỉ** (`address`) - Tùy chọn
  5. **Số điện thoại** (`phone`) - Tùy chọn

**Các thành phần hiển thị:**
- Header với logo QLST và menu điều hướng
- Tiêu đề trang: "Điền thông tin thành viên"
- Form HTML với action trỏ đến `/register` và method `POST`
- Nút submit có ID là `btnRegister` với text "Gửi yêu cầu"
- Link "Đã có tài khoản" chuyển về trang login

**Xử lý lỗi (nếu có):**
- Hiển thị danh sách lỗi từ attribute `errors` trong alert box màu đỏ
- Giữ lại dữ liệu đã nhập từ attribute `formData` để người dùng không phải nhập lại

---

### **Bước 3: Người dùng điền thông tin và submit form**

**Hành động:**
- Người dùng điền đầy đủ thông tin vào các trường (họ tên, mật khẩu, email, địa chỉ, số điện thoại)
- Nhấn nút "Gửi yêu cầu" (có ID là `btnRegister`)
- Browser gửi request `POST /register` với dữ liệu form dưới dạng form parameters

---

### **Bước 4: RegisterServlet xử lý POST request**

**Phương thức xử lý:** `doPost()` của `RegisterServlet`

#### **4.1. Thiết lập encoding UTF-8**
- Servlet đặt character encoding của request thành UTF-8
- Điều này đảm bảo xử lý đúng các ký tự tiếng Việt

#### **4.2. Trích xuất dữ liệu form**
- Lấy tham số password từ request dưới dạng chuỗi gốc (chưa hash)
- Gọi phương thức `extractFormData()` để lấy các thông tin khác

**Phương thức `extractFormData()`:**
- Lấy các parameter từ request (name, email, address, phone)
- Trim (loại bỏ) khoảng trắng thừa ở đầu và cuối
- Đối với các trường bắt buộc: convert null thành chuỗi rỗng
- Đối với các trường tùy chọn: giữ null nếu rỗng
- Tạo đối tượng `Member` để lưu dữ liệu form đã được làm sạch

#### **4.3. Chuẩn bị danh sách lỗi và lưu form data**
- Tạo một danh sách `errors` để lưu các thông báo lỗi validation
- Lưu đối tượng `formData` vào request attribute để có thể hiển thị lại khi có lỗi

---

### **Bước 5: Validation dữ liệu - Kiểm tra trường bắt buộc**

**Phương thức:** `validateRequiredFields()` nhận vào dữ liệu form, mật khẩu và danh sách lỗi

**Các kiểm tra được thực hiện:**

1. **Họ và tên không được để trống:**
   - Kiểm tra xem trường name có blank (null hoặc rỗng) không
   - Nếu blank, thêm lỗi "Ho va ten khong duoc de trong." vào danh sách errors

2. **Mật khẩu không được để trống và phải ≥ 8 ký tự:**
   - Kiểm tra xem password có blank không
   - Nếu blank, thêm lỗi "Mat khau khong duoc de trong."
   - Nếu có giá trị nhưng độ dài nhỏ hơn 8 ký tự, thêm lỗi "Mat khau phai co it nhat 8 ky tu."

3. **Email không được để trống:**
   - Kiểm tra xem email có blank không
   - Nếu blank, thêm lỗi "Email khong duoc de trong."

**Lưu ý:** Địa chỉ và số điện thoại là các trường tùy chọn, không cần validation.

---

### **Bước 6: Validation dữ liệu - Kiểm tra tính duy nhất**

**Điều kiện:** Chỉ kiểm tra nếu validation trường bắt buộc thành công (danh sách errors rỗng)

**Phương thức:** `validateUniqueness()` nhận vào dữ liệu form và danh sách lỗi

**Sử dụng UserDAO để kiểm tra trong database:**

1. **Kiểm tra username đã tồn tại chưa:**
   - Gọi phương thức `findByUsername()` của UserDAO với tên người dùng
   - Phương thức này query bảng tblUsers để tìm user có username trùng
   - Nếu tìm thấy (trả về Optional có giá trị), thêm lỗi "Ten dang nhap da ton tai. Vui long chon ten khac."

2. **Kiểm tra email đã được sử dụng chưa:**
   - Gọi phương thức `findByEmail()` của UserDAO với email
   - Phương thức này query bảng tblUsers để tìm user có email trùng
   - Nếu tìm thấy (trả về Optional có giá trị), thêm lỗi "Email da duoc su dung."

**Cách hoạt động của UserDAO:**
- `findByUsername()`: Thực thi câu SQL SELECT để tìm user theo username trong bảng tblUsers
- `findByEmail()`: Thực thi câu SQL SELECT để tìm user theo email trong bảng tblUsers
- Cả hai phương thức đều trả về Optional: có giá trị User nếu tìm thấy, empty nếu không tìm thấy

---

### **Bước 7: Xử lý khi có lỗi validation**

**Điều kiện:** `if (!errors.isEmpty())`

**Xử lý:**
```java
req.setAttribute("errors", errors);
forwardToForm(req, resp);
return;
```

**Kết quả:**
- Set attribute `errors` chứa danh sách lỗi
- Forward lại về `FillInformation.jsp`
- JSP hiển thị:
  - Danh sách lỗi trong alert box
  - Giữ lại dữ liệu đã nhập từ `${formData}`
- Người dùng sửa lỗi và submit lại (quay lại Bước 3)

---

### **Bước 8: Chuẩn bị dữ liệu để lưu database**

**Điều kiện:** Validation thành công (không có lỗi)

**Phương thức:** `buildMemberToPersist(Member formData, String rawPassword)`

**Xử lý:**

1. **Tạo đối tượng Member mới:**
```java
Member member = new Member();
```

2. **Copy dữ liệu từ formData:**
```java
member.setName(formData.getName());
member.setEmail(formData.getEmail());
member.setAddress(formData.getAddress());
member.setPhone(formData.getPhone());
```

3. **Hash mật khẩu sử dụng PasswordUtil:**
```java
member.setPassword(PasswordUtil.hashPassword(rawPassword));
```

**PasswordUtil.hashPassword():**
- Sử dụng thuật toán SHA-256
- Convert password thành byte array (UTF-8)
- Hash và chuyển thành chuỗi hex
```java
MessageDigest digest = MessageDigest.getInstance("SHA-256");
byte[] hashed = digest.digest(plainPassword.getBytes(StandardCharsets.UTF_8));
// Convert byte array to hex string
```

**Kết quả:** Đối tượng `Member` sẵn sàng để persist vào database

---

### **Bước 9: Lưu thông tin vào database qua MemberDAO**

**Khởi tạo MemberDAO:**
```java
try (MemberDAO memberDAO = new MemberDAO()) {
    savedSuccessfully = memberDAO.saveInformation(memberToPersist);
}
```

**Phương thức:** `MemberDAO.saveInformation(Member member)`

#### **9.1. Bắt đầu transaction**
```java
boolean originalAutoCommit = con.getAutoCommit();
con.setAutoCommit(false);  // Tắt auto-commit để quản lý transaction thủ công
```

#### **9.2. Insert vào bảng tblUsers**

**Phương thức:** `insertUser(Member member)`

**SQL Statement:**
```sql
INSERT INTO tblUsers (username, password_hash, role, full_name, email, phone_number, created_at) 
VALUES (?, ?, ?, ?, ?, ?, ?)
```

**Mapping dữ liệu:**
```java
statement.setString(1, member.getName());        // username
statement.setString(2, member.getPassword());    // password_hash (đã được hash)
statement.setString(3, "CUSTOMER");              // role
statement.setString(4, member.getName());        // full_name
statement.setString(5, member.getEmail());       // email
statement.setString(6, member.getPhone());       // phone_number
statement.setTimestamp(7, Timestamp.valueOf(createdAt)); // created_at
```

**Lấy generated key:**
```java
try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
    if (generatedKeys.next()) {
        return generatedKeys.getString(1);  // Trả về user ID vừa tạo
    }
}
```

#### **9.3. Chuyển đổi Member sang Customer**

**Phương thức:** `toCustomer(Member member, String userId)`

```java
Customer customer = new Customer();
customer.setName(member.getName());
customer.setEmail(member.getEmail());
customer.setPhone(member.getPhone());
customer.setAddress(member.getAddress());
customer.setUserAccountId(userId);        // Link với user vừa tạo
customer.setJoinedAt(LocalDateTime.now()); // Thời gian tham gia
return customer;
```

**Model Customer:**
- Kế thừa từ `Member` (có các field: id, name, email, phone, address)
- Thêm 2 field riêng:
  - `userAccountId`: Foreign key tới tblUsers
  - `joinedAt`: Thời gian đăng ký

#### **9.4. Insert vào bảng tblCustomers**

**Gọi:** `customerDAO.save(con, customer)`

**SQL Statement:**
```sql
INSERT INTO tblCustomers (user_id, full_name, email, phone_number, address, joined_at) 
VALUES (?, ?, ?, ?, ?, ?)
```

**Mapping dữ liệu:**
```java
statement.setString(1, customer.getUserAccountId()); // user_id
statement.setString(2, customer.getName());           // full_name
statement.setString(3, customer.getEmail());          // email
statement.setString(4, customer.getPhone());          // phone_number
statement.setString(5, customer.getAddress());        // address
statement.setTimestamp(6, Timestamp.valueOf(joinedAt)); // joined_at
```

**Lấy generated customer ID:**
```java
try (ResultSet keys = statement.getGeneratedKeys()) {
    if (keys.next()) {
        customer.setId(keys.getString(1));  // Set customer ID
    }
}
```

#### **9.5. Commit transaction**
```java
con.commit();
member.setId(customer.getId());
return true;
```

#### **9.6. Xử lý lỗi (rollback nếu có exception)**
```java
catch (SQLException ex) {
    con.rollback();  // Hoàn tác tất cả thay đổi
    throw ex;
} finally {
    con.setAutoCommit(originalAutoCommit);  // Khôi phục auto-commit
}
```

**Lợi ích của transaction:**
- Đảm bảo tính toàn vẹn dữ liệu
- Insert vào cả 2 bảng thành công hoặc không insert gì cả
- Tránh trường hợp có user nhưng không có customer profile

---

### **Bước 10: Xử lý kết quả lưu database**

#### **10.1. Trường hợp lỗi SQL**
```java
catch (SQLException e) {
    log("Unable to persist member registration", e);
    errors.add("Khong the tao tai khoan moi. Vui long thu lai sau.");
    req.setAttribute("errors", errors);
    forwardToForm(req, resp);
    return;
}
```
- Log lỗi ra server
- Thêm thông báo lỗi cho người dùng
- Forward lại về form để người dùng thử lại

#### **10.2. Trường hợp save không thành công**
```java
if (!savedSuccessfully) {
    errors.add("Khong the tao tai khoan moi. Vui long thu lai sau.");
    req.setAttribute("errors", errors);
    forwardToForm(req, resp);
    return;
}
```
- Xử lý tương tự như lỗi SQL

---

### **Bước 11: Đăng ký thành công - Redirect đến trang login**

**Điều kiện:** `savedSuccessfully == true`

**Xử lý:**
```java
resp.sendRedirect(req.getContextPath() + "/login?registered=true");
```

**Kết quả:**
- Browser redirect (HTTP 302) đến URL: `/login?registered=true`
- Query parameter `registered=true` có thể được sử dụng để hiển thị thông báo thành công
- Người dùng có thể đăng nhập bằng tài khoản vừa tạo

---

## SƠ ĐỒ TỔNG QUAN

```
[Người dùng] 
    ↓ (1) Click "Đăng ký"
    ↓ GET /register
[RegisterServlet.doGet()]
    ↓ (2) Forward
[FillInformation.jsp] 
    ↓ (3) Hiển thị form
[Người dùng điền thông tin]
    ↓ (4) Submit form
    ↓ POST /register
[RegisterServlet.doPost()]
    ↓ (5) Extract form data
    ↓ (6) Validate required fields
    ↓ (7) Validate uniqueness via UserDAO
    ├─→ Có lỗi? → Set errors → Forward to JSP → Hiển thị lỗi (quay lại 3)
    ↓ Không lỗi
    ↓ (8) Hash password (PasswordUtil)
    ↓ (9) Build Member object
[MemberDAO.saveInformation()]
    ↓ (10) Begin transaction
    ↓ (11) Insert tblUsers → Get userId
    ↓ (12) Create Customer object
    ↓ (13) Insert tblCustomers (CustomerDAO)
    ↓ (14) Commit transaction
    ├─→ SQLException? → Rollback → Throw exception → Forward to JSP (quay lại 3)
    ↓ Success
[RegisterServlet]
    ↓ (15) Redirect to /login?registered=true
[Trang đăng nhập]
    └─→ Người dùng đăng nhập với tài khoản mới
```

---

## CÁC LỚP VÀ TRÁCH NHIỆM

### **1. Lớp View (Presentation Layer)**
- **FillInformation.jsp**
  - Hiển thị form đăng ký
  - Render dữ liệu từ `${formData}` và `${errors}`
  - Submit form đến `/register`

### **2. Lớp Controller (Servlet Layer)**
- **RegisterServlet**
  - `doGet()`: Điều hướng đến JSP
  - `doPost()`: Xử lý logic đăng ký
  - Validation dữ liệu đầu vào
  - Điều phối giữa View và Model
  - Quản lý request/response

### **3. Lớp DAO (Data Access Layer)**
- **MemberDAO**
  - `saveInformation()`: Lưu member với transaction
  - Quản lý insert vào tblUsers và tblCustomers
  - Xử lý transaction (commit/rollback)

- **UserDAO**
  - `findByUsername()`: Kiểm tra username tồn tại
  - `findByEmail()`: Kiểm tra email tồn tại

- **CustomerDAO**
  - `save()`: Insert customer profile vào database

- **DAO (Base class)**
  - Quản lý database connection
  - Được kế thừa bởi MemberDAO

### **4. Lớp Model (Entity Layer)**
- **Member**
  - Properties: id, name, password, email, phone, address
  - Đại diện cho thông tin đăng ký

- **Customer** (extends Member)
  - Thêm properties: userAccountId, joinedAt
  - Đại diện cho customer profile trong database

- **User**
  - Đại diện cho tài khoản trong tblUsers
  - Dùng cho authentication

### **5. Lớp Utility**
- **PasswordUtil**
  - `hashPassword()`: Hash password bằng SHA-256
  - `matches()`: Kiểm tra password (dùng cho login)

- **StringUtils** (Apache Commons)
  - `trimToEmpty()`: Trim và convert null thành ""
  - `trimToNull()`: Trim và convert blank thành null
  - `isBlank()`: Kiểm tra null hoặc rỗng

---

## DATABASE SCHEMA

### **Bảng tblUsers**
```sql
CREATE TABLE tblUsers (
    id VARCHAR PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL,
    password_hash VARCHAR NOT NULL,
    role VARCHAR NOT NULL,           -- "CUSTOMER"
    full_name VARCHAR,
    email VARCHAR UNIQUE,
    phone_number VARCHAR,
    created_at TIMESTAMP
);
```

### **Bảng tblCustomers**
```sql
CREATE TABLE tblCustomers (
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR REFERENCES tblUsers(id),
    full_name VARCHAR,
    email VARCHAR,
    phone_number VARCHAR,
    address VARCHAR,
    joined_at TIMESTAMP
);
```

**Quan hệ:** tblCustomers.user_id → tblUsers.id (One-to-One)

---

## CÁC TRƯỜNG HỢP ĐẶC BIỆT

### **1. Username đã tồn tại**
- Lỗi: "Ten dang nhap da ton tai. Vui long chon ten khac."
- Người dùng phải chọn tên khác

### **2. Email đã được sử dụng**
- Lỗi: "Email da duoc su dung."
- Người dùng phải dùng email khác

### **3. Mật khẩu quá ngắn**
- Lỗi: "Mat khau phai co it nhat 8 ky tu."
- Người dùng phải nhập mật khẩu ≥ 8 ký tự

### **4. Trường bắt buộc để trống**
- Lỗi tương ứng cho từng trường
- Form giữ lại dữ liệu đã nhập

### **5. Lỗi database/transaction**
- Rollback tất cả thay đổi
- Thông báo: "Khong the tao tai khoan moi. Vui long thu lai sau."
- Log lỗi chi tiết ở server

---

## LUỒNG DỮ LIỆU

```
Form Input (JSP)
    ↓
HTTP POST Parameters
    ↓
RegisterServlet (trim, validate)
    ↓
Member object (plain password)
    ↓
Hash password (PasswordUtil)
    ↓
Member object (hashed password)
    ↓
MemberDAO.saveInformation()
    ↓
INSERT tblUsers → userId
    ↓
Convert to Customer object
    ↓
CustomerDAO.save() → INSERT tblCustomers
    ↓
Database (2 bảng được insert)
```

---

## KẾT LUẬN

Quy trình đăng ký thành viên được thiết kế theo kiến trúc MVC chuẩn với:
- **Separation of Concerns**: Mỗi lớp có trách nhiệm riêng biệt
- **Transaction Management**: Đảm bảo tính toàn vẹn dữ liệu
- **Security**: Hash password trước khi lưu
- **Validation**: Kiểm tra dữ liệu ở nhiều tầng
- **User Experience**: Giữ lại dữ liệu và hiển thị lỗi rõ ràng
- **Error Handling**: Xử lý exception và rollback khi cần

Luồng xử lý từ người dùng → Servlet → DAO → Database được tổ chức rõ ràng, dễ bảo trì và mở rộng.
