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
    <div class="header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span>QLST</span>
        </a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register" class="is-active">Đăng ký thành viên</a>
            <a href="${pageContext.request.contextPath}/reports">Thống kê khách hàng</a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card form-card" aria-labelledby="register-title">
        <div>
            <h1 id="register-title">Đăng ký tài khoản khách hàng</h1>
            <p>Vui lòng cung cấp thông tin chính xác để hệ thống ghi nhận thành viên mới.</p>
        </div>

        <c:if test="${not empty errors}">
            <div class="alert" role="alert">
                <p>Vui lòng kiểm tra lại:</p>
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
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" value="${formData != null ? formData.address : ''}">
            </div>
            <div>
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div>
                <label for="confirmPassword">Xác nhận mật khẩu</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">Đăng ký</button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/login">Hủy</a>
            </div>
        </form>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Kết nối khách hàng trung thành</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
