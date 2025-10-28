# Kế hoạch triển khai QLST (rút gọn)

Tài liệu này mô tả các hạng mục cần hoàn thành cho phạm vi chức năng đã được thống nhất: đăng nhập, đăng ký khách hàng và xem thống kê doanh thu khách hàng.

## 1. Hạ tầng & cấu hình
- [ ] Rà soát `pom.xml`, bổ sung dependency cần thiết cho JDBC, JSTL và bảo mật.
- [ ] Thiết lập cấu hình build (maven-war-plugin, compiler) và môi trường chạy thử (Tomcat/Jetty).
- [ ] Tạo script khởi tạo cơ sở dữ liệu với bảng người dùng, khách hàng và giao dịch.

## 2. Tầng tiện ích
- [ ] Hoàn thiện `DBConnection` với kết nối JDBC chuẩn và xử lý lỗi chung.
- [ ] Bổ sung tiện ích mã hóa mật khẩu và kiểm tra đầu vào.

## 3. Tầng Entity (Model)
- [ ] Hoàn thiện entity `User`, `Customer`, `Transaction` với các thuộc tính cần thiết (họ tên, email, vai trò, giá trị giao dịch...).
- [ ] Viết mapper hoặc builder hỗ trợ chuyển đổi giữa ResultSet và entity.

## 4. Tầng DAO
- [ ] Hiện thực CRUD tối thiểu cho `UserDAO` và `CustomerDAO` phục vụ đăng ký/đăng nhập.
- [ ] Xây dựng truy vấn thống kê doanh thu khách hàng theo khoảng thời gian trong `StatisticsDAO`.

## 5. Tầng Servlet (Controller)
- [ ] Xây dựng `AuthServlet` xử lý đăng ký và đăng nhập với kiểm tra dữ liệu đầu vào.
- [ ] Xây dựng `StatisticsServlet` cho phép quản lý chọn khoảng thời gian và xem thống kê khách hàng theo doanh thu.
- [ ] Thiết lập filter bảo vệ các trang yêu cầu đăng nhập.

## 6. Giao diện JSP
- [ ] Tạo form đăng ký khách hàng và đăng nhập với thông báo lỗi/thành công.
- [ ] Tạo trang thống kê: chọn ngày bắt đầu, ngày kết thúc và hiển thị bảng khách hàng kèm tổng doanh thu, liên kết xem chi tiết giao dịch.

## 7. Kiểm thử & tài liệu
- [ ] Viết test tích hợp cho quy trình đăng ký, đăng nhập và truy vấn thống kê.
- [ ] Cập nhật README mô tả phạm vi chức năng, cách chạy và tài khoản mẫu.
