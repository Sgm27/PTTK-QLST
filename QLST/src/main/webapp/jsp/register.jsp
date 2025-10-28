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
            <a href="${pageContext.request.contextPath}/login" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <span class="nav-label">Đăng nhập</span>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="nav-link is-active">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a5 5 0 10-5-5 5 5 0 005 5zm7 1h-3v-3h-2v3h-3v2h3v3h2v-3h3zM4 18.25C4 15.9 7.13 14 12 14v2c-3.87 0-6 1.23-6 2.25V20H4z"/></svg>
                </span>
                <span class="nav-label">Đăng ký</span>
            </a>
            <a href="${pageContext.request.contextPath}/reports" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M5 4h3v16H5zm5 6h3v10h-3zm5-4h3v14h-3z"/></svg>
                </span>
                <span class="nav-label">Thống kê</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card form-card" aria-labelledby="register-title">
        <div class="form-card__header">
            <h1 id="register-title">Đăng ký tài khoản khách hàng</h1>
            <p>Điền đầy đủ thông tin cần thiết để kích hoạt chương trình khách hàng thân thiết và quản lý ưu đãi.</p>
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
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div>
                <label for="confirmPassword">Xác nhận mật khẩu</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">Đăng ký</button>
                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/login">Hủy</a>
            </div>
        </form>
        <p class="form-footnote">Tài khoản sẽ được kích hoạt ngay khi thông tin hợp lệ.</p>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Kết nối khách hàng trung thành</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
