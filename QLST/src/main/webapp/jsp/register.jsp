<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="app-shell">
    <header class="app-header">
        <div class="app-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
                <span class="brand__mark">QL</span>
                <span>QLST</span>
            </a>
            <p class="app-tagline">Khởi tạo tài khoản cho thành viên mới trong tổ chức</p>
            <nav class="primary-nav" aria-label="Liên kết nhanh">
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="is-active">Đăng ký</a>
                <a href="${pageContext.request.contextPath}/dashboard">Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/warehouse">Kho hàng</a>
                <a href="${pageContext.request.contextPath}/customer">Khách hàng</a>
                <a href="${pageContext.request.contextPath}/reports">Báo cáo</a>
            </nav>
        </div>
    </header>
    <div class="app-body">
        <aside class="app-sidebar" aria-label="Thông tin hỗ trợ">
            <div>
                <div class="sidebar-title">Mẹo tổ chức</div>
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard">Cấu hình hệ thống</a>
                    <a href="${pageContext.request.contextPath}/customer">Theo dõi khách hàng</a>
                    <a href="${pageContext.request.contextPath}/warehouse">Phân công kho</a>
                </nav>
            </div>
            <p class="sidebar-note">Gán role phù hợp giúp nhân viên nhận được quyền truy cập chính xác với công việc.</p>
        </aside>
        <main class="app-content">
            <section class="form-card" aria-labelledby="register-title">
                <div class="section-header">
                    <div>
                        <h2 id="register-title">Tạo tài khoản mới</h2>
                        <p>Nhập đủ thông tin cần thiết để nhân viên hoặc khách hàng truy cập hệ thống QLST.</p>
                    </div>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert alert-error" role="alert">
                        <ul>
                            <c:forEach var="error" items="${errors}">
                                <li>${error}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="form-grid two-column" autocomplete="off">
                    <div>
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" value="${formData != null ? formData.username : ''}" required>
                    </div>
                    <div>
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" value="${formData != null ? formData.fullName : ''}" required>
                    </div>
                    <div>
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${formData != null ? formData.email : ''}" required>
                    </div>
                    <div>
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" value="${formData != null ? formData.phone : ''}">
                    </div>
                    <div>
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div>
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div class="full-width">
                        <label for="role">Vai trò</label>
                        <select id="role" name="role">
                            <option value="CUSTOMER" ${formData != null && formData.role == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                            <option value="MANAGER" ${formData != null && formData.role == 'MANAGER' ? 'selected' : ''}>Quản lý</option>
                            <option value="WAREHOUSE" ${formData != null && formData.role == 'WAREHOUSE' ? 'selected' : ''}>Kho</option>
                            <option value="SALES" ${formData != null && formData.role == 'SALES' ? 'selected' : ''}>Bán hàng</option>
                        </select>
                    </div>
                    <div class="form-actions full-width">
                        <button type="submit" class="btn btn-primary">Đăng ký</button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/login">Hủy</a>
                    </div>
                </form>
            </section>
        </main>
    </div>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Quản lý tài khoản thống nhất</small>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
