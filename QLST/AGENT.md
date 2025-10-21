# Kế hoạch triển khai QLST

Tài liệu này liệt kê các hạng mục chính cần thực hiện để hoàn thiện hệ thống quản lý siêu thị điện máy QLST.

## 1. Hạ tầng & cấu hình
- [ ] Rà soát `pom.xml`, bổ sung các dependency cần thiết cho JDBC, JSTL, bảo mật.
- [ ] Cấu hình plugin build (maven-war-plugin, compiler) và thiết lập profile phát triển.
- [ ] Thiết lập môi trường chạy thử (Tomcat/Jetty), tài khoản DB và script khởi tạo.

## 2. Lớp tiện ích & cấu trúc chung
- [ ] Hoàn thiện `DBConnection` với connection pool hoặc datasource.
- [ ] Bổ sung lớp tiện ích cho logging, xử lý lỗi chung, i18n.
- [ ] Thiết kế filter/ listener cho quản lý session và mã hóa ký tự.

## 3. Tầng Entity (Model)
- [ ] Hoàn thiện các thuộc tính còn thiếu (địa chỉ giao hàng chi tiết, trạng thái thanh toán...).
- [ ] Sinh builder/record hoặc Lombok (nếu dùng) để giảm boilerplate.
- [ ] Viết unit test đảm bảo chuyển đổi dữ liệu giữa entity và JDBC ResultSet chính xác.

## 4. Tầng DAO
- [ ] Hiện thực CRUD cho `UserDAO`, `ProductDAO`, `SupplierDAO`, `OrderDAO`.
- [ ] Thêm transaction cho quy trình duyệt/ xuất hàng.
- [ ] Xây dựng truy vấn thống kê doanh thu khách hàng theo khoảng thời gian.

## 5. Tầng Servlet (Controller)
- [ ] Hoàn thiện logic xác thực, phân quyền và điều hướng.
- [ ] Xử lý validation đầu vào, hiển thị thông báo lỗi/thành công.
- [ ] Tách controller cho từng tác vụ (ví dụ: `WarehouseServlet`, `SalesServlet`).

## 6. Giao diện JSP
- [ ] Thiết kế layout chung (header/footer) và tái sử dụng bằng JSTL/ include.
- [ ] Hoàn thiện form nhập hàng, quản lý sản phẩm, thống kê doanh thu.
- [ ] Bổ sung thông báo dạng modal/ toast và bảng dữ liệu động.

## 7. Chức năng nghiệp vụ chính
- [ ] Quy trình đăng ký khách hàng: validate, mã hóa mật khẩu, gửi email xác nhận.
- [ ] Quy trình bán hàng tại quầy: tạo hóa đơn, cập nhật tồn kho, in hóa đơn.
- [ ] Quy trình duyệt đơn online: kiểm tra tồn, tạo phiếu xuất, giao hàng.
- [ ] Báo cáo quản lý: thống kê theo sản phẩm, nhà cung cấp, khách hàng, doanh thu.

## 8. Bảo mật & phân quyền
- [ ] Tích hợp cơ chế đăng nhập an toàn (hash mật khẩu, session management).
- [ ] Phân quyền chi tiết theo vai trò (MANAGER, WAREHOUSE, SALES, CUSTOMER).
- [ ] Thiết lập filter chống truy cập trái phép và CSRF.

## 9. Kiểm thử & triển khai
- [ ] Viết test tích hợp cho DAO và servlet (sử dụng ServletUnit hoặc Spring Test).
- [ ] Thiết lập pipeline CI (build, test, kiểm tra code style).
- [ ] Chuẩn bị tài liệu triển khai và hướng dẫn sử dụng.

## 10. Tài liệu & hướng dẫn
- [ ] Viết README mô tả dự án, cách build/run, cấu trúc thư mục.
- [ ] Soạn tài liệu hướng dẫn nghiệp vụ cho từng vai trò người dùng.
- [ ] Cập nhật sơ đồ C4/UML phản ánh kiến trúc cuối cùng.
