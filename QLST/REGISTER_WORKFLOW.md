# WORKFLOW - ĐĂNG KÝ THÀNH VIÊN

## Quy trình thực hiện chức năng "Đăng ký thành viên"

1. Khách hàng truy cập đường dẫn `/register` trên trình duyệt.
2. Container đọc cấu hình `web.xml` và ánh xạ URL `/register` tới lớp `RegisterServlet`.
3. Container khởi tạo `RegisterServlet` (nếu chưa tồn tại) và gọi `service()` xử lý request GET.
4. Hàm `RegisterServlet.doGet()` gọi phương thức nội bộ `forwardToForm(req, resp)`.
5. Phương thức `forwardToForm()` sử dụng `RequestDispatcher` forward sang `FillInformation.jsp`.
6. Lớp `FillInformation.jsp` khởi tạo các biến JSTL như `ctx`, `currentPage`, `formData` từ request scope.
7. Lớp `FillInformation.jsp` kiểm tra `requestScope.errors`; nếu có thì hiển thị `<div class="alert">` chứa danh sách lỗi.
8. Lớp `FillInformation.jsp` tạo thẻ `<form action="${ctx}/register" method="post" autocomplete="off">` để thu thập dữ liệu.
9. Lớp `FillInformation.jsp` hiển thị trường "Họ và tên" (`input#name`) với thuộc tính `required` và giá trị mặc định lấy từ `${formData.name}`.
10. Lớp `FillInformation.jsp` hiển thị trường "Mật khẩu" (`input#password`) với thuộc tính `required` và placeholder "Tối thiểu 8 ký tự".
11. Lớp `FillInformation.jsp` hiển thị trường "Email" (`input#email`) với thuộc tính `type="email"`, `required` và giá trị `${formData.email}`.
12. Lớp `FillInformation.jsp` hiển thị trường "Địa chỉ" (`input#address`) cho phép bỏ trống và đổ lại `${formData.address}` nếu có.
13. Lớp `FillInformation.jsp` hiển thị trường "Số điện thoại" (`input#phone`) cho phép bỏ trống và đổ lại `${formData.phone}` nếu có.
14. Lớp `FillInformation.jsp` cung cấp nhóm nút gồm liên kết "Đã có tài khoản" quay lại `/login` và nút submit "Gửi yêu cầu".
15. Khách hàng nhập thông tin, nhấn "Gửi yêu cầu"; trình duyệt gửi request POST tới `/register` với form data.
16. Container tiếp tục định tuyến `/register` tới `RegisterServlet` và gọi `doPost()`.
17. Hàm `RegisterServlet.doPost()` đặt `req.setCharacterEncoding("UTF-8")` để đọc đúng dữ liệu Unicode.
18. Hàm `doPost()` lấy mật khẩu gốc bằng `StringUtils.defaultString(req.getParameter("password"))` và lưu vào biến `rawPassword`.
19. Hàm `doPost()` gọi `extractFormData(req)` để tạo đối tượng `Member` chứa dữ liệu form.
20. Hàm `extractFormData()` khởi tạo `Member`, gán `name` từ `req.getParameter("name")` sau khi `trim`, `email` từ `req.getParameter("email")`, `address` và `phone` với `trimToNull`.
21. Hàm `extractFormData()` trả về đối tượng `Member` và `doPost()` gán vào biến `formData`.
22. Hàm `doPost()` khởi tạo `List<String> errors = new ArrayList<>()` và đặt `req.setAttribute("formData", formData)`.
23. Hàm `doPost()` gọi `validateRequiredFields(formData, rawPassword, errors)` để kiểm tra các trường bắt buộc.
24. Hàm `validateRequiredFields()` kiểm tra `formData.getName()` rỗng; nếu vi phạm thì thêm thông báo "Họ và tên không được để trống." vào danh sách lỗi.
25. Hàm `validateRequiredFields()` kiểm tra `rawPassword` rỗng hoặc độ dài < 8 ký tự; nếu vi phạm thì thêm thông báo tương ứng.
26. Hàm `validateRequiredFields()` kiểm tra `formData.getEmail()` rỗng; nếu vi phạm thì thêm thông báo "Email không được để trống.".
27. Hàm `validateRequiredFields()` trả về `doPost()` cùng danh sách `errors` đã cập nhật.
28. Hàm `doPost()` nếu `errors` rỗng thì tiếp tục gọi `validateUniqueness(formData, errors)` để kiểm tra trùng lặp.
29. Hàm `validateUniqueness()` sử dụng `userDAO.findByUsername(formData.getName())` để tra cứu tài khoản theo tên đăng nhập.
30. Phương thức `UserDAO.findByUsername()` mở kết nối JDBC qua `DBConnection.getConnection()`.
31. `UserDAO.findByUsername()` chuẩn bị câu lệnh `SELECT ... FROM tblUsers WHERE username = ?` và gán tham số tên đăng nhập.
32. `UserDAO.findByUsername()` thực thi truy vấn, nếu tìm thấy bản ghi thì gọi `mapRow(resultSet)` ánh xạ sang đối tượng `User` (model).
33. `UserDAO.mapRow()` khởi tạo `User`, gán `id`, `username`, `passwordHash`, `role`, `fullName`, `email`, `phoneNumber`, `createdAt` từ `ResultSet`.
34. `UserDAO.findByUsername()` trả về `Optional<User>`; nếu có giá trị, `validateUniqueness()` thêm lỗi "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.".
35. `validateUniqueness()` tiếp tục gọi `userDAO.findByEmail(formData.getEmail())` để kiểm tra email trùng.
36. `UserDAO.findByEmail()` thực hiện quy trình tương tự bước 30-33 nhưng với điều kiện `email = ?` và trả về `Optional<User>`.
37. Nếu email đã tồn tại, `validateUniqueness()` thêm lỗi "Email đã được sử dụng." vào danh sách.
38. Nếu trong quá trình tra cứu phát sinh `SQLException`, `validateUniqueness()` ném `ServletException` để `doPost()` xử lý.
39. Sau khi hoàn thành kiểm tra, `doPost()` đánh giá danh sách `errors`.
40. Nếu `errors` không rỗng, `doPost()` đặt `req.setAttribute("errors", errors)` và gọi lại `forwardToForm(req, resp)`.
41. Phương thức `forwardToForm()` forward request về `FillInformation.jsp` để hiển thị lỗi.
42. Lớp `FillInformation.jsp` đọc `errors` và hiển thị lại biểu mẫu với dữ liệu đã nhập; khách hàng quay lại bước 15 để chỉnh sửa.
43. Khi danh sách `errors` rỗng, `doPost()` gọi `buildMemberToPersist(formData, rawPassword)`.
44. Hàm `buildMemberToPersist()` tạo đối tượng `Member` mới `memberToPersist`.
45. `buildMemberToPersist()` sao chép `name`, `email`, `address`, `phone` từ `formData` sang `memberToPersist`.
46. `buildMemberToPersist()` mã hóa mật khẩu bằng `PasswordUtil.hashPassword(rawPassword)` và gán vào `memberToPersist.setPassword()`.
47. Hàm `buildMemberToPersist()` trả về đối tượng `memberToPersist` cho `doPost()`.
48. Hàm `doPost()` mở khối `try (MemberDAO memberDAO = new MemberDAO())` để thao tác cơ sở dữ liệu.
49. Lớp `MemberDAO` kế thừa `DAO`, trong constructor gọi `super()` để lấy `Connection con` từ `DBConnection`.
50. Hàm `doPost()` gọi `memberDAO.saveInformation(memberToPersist)` và gán kết quả cho biến `savedSuccessfully`.
51. Phương thức `MemberDAO.saveInformation()` lưu trạng thái `boolean originalAutoCommit = con.getAutoCommit()`.
52. `MemberDAO.saveInformation()` đặt `con.setAutoCommit(false)` để điều khiển giao dịch thủ công.
53. `MemberDAO.saveInformation()` gọi `insertUser(member)` để chèn bản ghi vào bảng `tblUsers`.
54. Hàm `insertUser()` tính `createdAt = LocalDateTime.now()`.
55. `insertUser()` chuẩn bị `PreparedStatement` với câu lệnh `INSERT INTO tblUsers (username, password_hash, role, full_name, email, phone_number, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)`.
56. `insertUser()` gán lần lượt các tham số: username, password hash, role "CUSTOMER", full_name, email, phone_number, created_at.
57. `insertUser()` thực thi `executeUpdate()` để thêm dòng dữ liệu vào `tblUsers`.
58. `insertUser()` gọi `fetchUserIdByUsername(member.getName())` để lấy `id` của tài khoản vừa tạo.
59. Hàm `fetchUserIdByUsername()` chuẩn bị câu `SELECT id FROM tblUsers WHERE username = ?`, gán tham số và thực thi truy vấn.
60. Nếu có kết quả, `fetchUserIdByUsername()` trả về giá trị `id`; nếu không, hàm ném `SQLException` "Không thể lấy mã người dùng sau khi tạo thành viên.".
61. `MemberDAO.saveInformation()` nhận `userId` trả về từ `insertUser()`.
62. `MemberDAO.saveInformation()` gọi `toCustomer(member, userId)` để chuyển đổi sang đối tượng `Customer` (model).
63. Hàm `toCustomer()` khởi tạo `Customer`, sao chép `name`, `email`, `phone`, `address` từ `member` và gán `userAccountId = userId`.
64. `toCustomer()` đặt `joinedAt = LocalDateTime.now()` cho khách hàng mới.
65. `MemberDAO.saveInformation()` nhận đối tượng `customer` và gọi `customerDAO.save(con, customer)`.
66. Phương thức `CustomerDAO.save()` kiểm tra `customer.getUserAccountId()` khác `null`; nếu `null` thì ném `IllegalArgumentException`.
67. `CustomerDAO.save()` chuẩn bị câu lệnh `INSERT INTO tblCustomers (user_id, full_name, email, phone_number, address, joined_at) VALUES (?, ?, ?, ?, ?, ?)`.
68. `CustomerDAO.save()` xác định `joinedAt`; nếu `customer.getJoinedAt()` `null` thì set `LocalDateTime.now()` và cập nhật lại đối tượng.
69. `CustomerDAO.save()` gán các tham số tương ứng rồi gọi `executeUpdate()` để thêm bản ghi khách hàng.
70. `CustomerDAO.save()` gọi `assignCustomerId(connection, customer)` để lấy khóa chính vừa sinh.
71. Hàm `assignCustomerId()` chạy câu `SELECT id FROM tblCustomers WHERE user_id = ?`, gán tham số `userAccountId` và thực thi.
72. Nếu tìm thấy bản ghi, `assignCustomerId()` gán `customer.setId(resultSet.getString("id"))`; nếu không, ném `SQLException`.
73. Sau khi `customerDAO.save()` hoàn tất, điều khiển quay về `MemberDAO.saveInformation()`.
74. `MemberDAO.saveInformation()` gọi `con.commit()` để xác nhận giao dịch.
75. `MemberDAO.saveInformation()` gán `member.setId(customer.getId())` để lưu mã khách hàng vào đối tượng `Member` được truyền vào.
76. `MemberDAO.saveInformation()` trả về `true` cho biết lưu thành công.
77. Khối `finally` của `MemberDAO.saveInformation()` luôn khôi phục `con.setAutoCommit(originalAutoCommit)`.
78. Nếu bất kỳ bước nào ném `SQLException`, `MemberDAO.saveInformation()` gọi `con.rollback()` trước khi rethrow lỗi cho servlet.
79. Quay lại `RegisterServlet.doPost()`, nếu `memberDAO.saveInformation()` ném `SQLException`, khối `catch` ghi log, thêm thông báo lỗi chung vào `errors`, gán vào request và forward lại form.
80. Nếu `savedSuccessfully` nhận giá trị `false`, `doPost()` cũng thêm thông báo lỗi và quay lại `FillInformation.jsp`.
81. Khi `savedSuccessfully` là `true`, `doPost()` đặt `req.setAttribute("member", memberToPersist)`.
82. Hàm `doPost()` gọi `req.getRequestDispatcher("/jsp/DoSaveMember.jsp").forward(req, resp)` để chuyển sang trang thành công.
83. Lớp `DoSaveMember.jsp` import `com.qlst.model.Member` và đọc đối tượng `member` từ request attribute.
84. `DoSaveMember.jsp` kiểm tra nếu `member == null` thì thực hiện `response.sendRedirect(request.getContextPath() + "/register")` nhằm ngăn truy cập trực tiếp.
85. `DoSaveMember.jsp` hiển thị thông báo "Đăng ký thành công!" cùng nội dung chúc mừng khách hàng.
86. `DoSaveMember.jsp` hiển thị thông tin thành viên gồm họ tên và email từ `member.getName()` và `member.getEmail()`.
87. `DoSaveMember.jsp` hiển thị tùy chọn số điện thoại nếu `member.getPhone()` không rỗng.
88. `DoSaveMember.jsp` hiển thị tùy chọn địa chỉ nếu `member.getAddress()` không rỗng.
89. `DoSaveMember.jsp` cung cấp nút "Đăng nhập ngay" dẫn tới `/login?registered=true` và nút "Về trang chủ" trở lại `/`.
90. Khách hàng có thể chọn "Đăng nhập ngay" để chuyển sang luồng đăng nhập hoặc quay về trang chủ sau khi đăng ký hoàn tất.
91. Lớp `Member` (model) lưu trữ thông tin thành viên với các thuộc tính `id`, `name`, `password`, `email`, `phone`, `address` kèm setter/getter.
92. Lớp `Customer` (model) mở rộng `Member`, bổ sung `userAccountId` và `joinedAt` để liên kết với bảng tài khoản người dùng.
93. Luồng đăng ký kết thúc khi khách hàng xem trang `DoSaveMember.jsp` và lựa chọn bước tiếp theo phù hợp.