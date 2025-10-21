<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành viên - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="wrapper header-inner">
        <a class="logo" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span>QL</span>
            Hệ thống QLST
        </a>
        <div class="tagline">Khởi tạo tài khoản cho nhân viên và khách hàng chỉ với vài bước</div>
        <nav class="main-nav" aria-label="Điều hướng chính">
            <ul>
                <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/reports">Báo cáo</a></li>
            </ul>
        </nav>
    </div>
</header>
<main>
    <div class="wrapper">
        <section class="form-card" aria-labelledby="register-title">
            <h2 id="register-title">Tạo tài khoản QLST</h2>
            <p class="page-intro">Hoàn thiện biểu mẫu để cấp quyền truy cập phù hợp với vai trò của từng thành viên.</p>

            <c:if test="${not empty errors}">
                <div class="alert alert-error">
                    <ul>
                        <c:forEach var="error" items="${errors}">
                            <li>${error}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="form-grid two-column">
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
                    <input type="tel" id="phone" name="phone" value="${formData != null ? formData.phone : ''}">
                </div>
                <div class="full-width">
                    <label for="role">Vai trò</label>
                    <c:set var="selectedRole" value="${formData != null ? formData.role : 'CUSTOMER'}" />
                    <select id="role" name="role">
                        <option value="CUSTOMER"<c:if test="${selectedRole == 'CUSTOMER'}"> selected</c:if>>Khách hàng</option>
                        <option value="SALES"<c:if test="${selectedRole == 'SALES'}"> selected</c:if>>Nhân viên bán hàng</option>
                        <option value="WAREHOUSE"<c:if test="${selectedRole == 'WAREHOUSE'}"> selected</c:if>>Nhân viên kho</option>
                        <option value="MANAGER"<c:if test="${selectedRole == 'MANAGER'}"> selected</c:if>>Quản lý</option>
                    </select>
                </div>
                <div>
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div>
                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <div class="form-actions full-width">
                    <button type="submit" class="btn btn-primary">Đăng ký</button>
                </div>
            </form>
            <p class="form-note">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="wrapper">
        <small>&copy; 2024 QLST &mdash; Kết nối đội ngũ của bạn an toàn, nhanh chóng</small>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
