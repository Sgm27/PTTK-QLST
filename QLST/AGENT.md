# Kế hoạch triển khai QLST (rút gọn)

Tài liệu này mô tả các hạng mục cần hoàn thành cho phạm vi chức năng đã được thống nhất: đăng nhập, đăng ký khách hàng và xem thống kê doanh thu khách hàng.

## 1. Hạ tầng & cấu hình
- [x] Rà soát `pom.xml`, bổ sung dependency cần thiết cho JDBC, JSTL và bảo mật.
- [x] Thiết lập cấu hình build (maven-war-plugin, compiler) và môi trường chạy thử (Tomcat/Jetty).
- [x] Tạo script khởi tạo cơ sở dữ liệu với bảng người dùng, khách hàng và giao dịch.

## 2. Tầng tiện ích
- [x] Hoàn thiện `DBConnection` với kết nối JDBC chuẩn và xử lý lỗi chung.
- [x] Bổ sung tiện ích mã hóa mật khẩu và kiểm tra đầu vào.

## 3. Tầng Entity (Model)
- [x] Hoàn thiện entity `User`, `Customer`, `Transaction` với các thuộc tính cần thiết (họ tên, email, vai trò, giá trị giao dịch...).
- [x] Viết mapper hoặc builder hỗ trợ chuyển đổi giữa ResultSet và entity.

## 4. Tầng DAO
- [x] Hiện thực CRUD tối thiểu cho `UserDAO` và `CustomerDAO` phục vụ đăng ký/đăng nhập.
- [x] Xây dựng truy vấn thống kê doanh thu khách hàng theo khoảng thời gian trong `StatisticsDAO`.

## 5. Tầng Servlet (Controller)
- [x] Xây dựng `AuthServlet` xử lý đăng ký và đăng nhập với kiểm tra dữ liệu đầu vào.
- [x] Xây dựng `StatisticsServlet` cho phép quản lý chọn khoảng thời gian và xem thống kê khách hàng theo doanh thu.
- [x] Thiết lập filter bảo vệ các trang yêu cầu đăng nhập.

## 6. Giao diện JSP
- [x] Tạo form đăng ký khách hàng và đăng nhập với thông báo lỗi/thành công.
- [x] Tạo trang thống kê: chọn ngày bắt đầu, ngày kết thúc và hiển thị bảng khách hàng kèm tổng doanh thu, liên kết xem chi tiết giao dịch.

## 7. Kiểm thử & tài liệu
- [ ] Viết test tích hợp cho quy trình đăng ký, đăng nhập và truy vấn thống kê.
- [ ] Cập nhật README mô tả phạm vi chức năng, cách chạy và tài khoản mẫu.
