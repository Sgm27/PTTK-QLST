<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="app-shell">
<c:set var="currentPage" value="register"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="roleValue" value="${selectedRole != null ? selectedRole : (formData != null ? formData.role : 'CUSTOMER')}"/>
<header class="app-header">
    <div class="app-bar">
        <a class="brand" href="${ctx}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span class="brand__text">
                <span class="brand__title">QLST</span>
                <span class="brand__subtitle">Retail Suite</span>
            </span>
        </a>
        <nav class="app-nav" aria-label="Điều hướng chính">
            <a class="app-nav__link${currentPage eq 'home' ? ' is-active' : ''}" href="${ctx}/">Trang chủ</a>
            <a class="app-nav__link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
            <a class="app-nav__link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
            <a class="app-nav__link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/statistics/customers" data-active-root="${ctx}/statistics">Thống kê</a>
        </nav>
    </div>
</header>
<main>
    <section class="container page-hero">
        <div>
            <p class="page-hero__eyebrow">QLST Members</p>
            <h1 class="page-hero__title">Tạo tài khoản khách hàng hoặc quản lý</h1>
            <p class="page-hero__subtitle">
                Điền thông tin chi tiết để kích hoạt quyền truy cập. QLST lưu trữ an toàn, chuẩn hóa mật khẩu bằng SHA-256.
            </p>
        </div>
        <div class="surface-card surface-card--soft form-shell" aria-labelledby="register-heading">
            <div>
                <h2 class="section-title" id="register-heading">Thông tin cần thiết</h2>
                <p class="section-subtitle">Mọi thông tin phải chính xác để đảm bảo quản trị và liên hệ khách hàng.</p>
            </div>

            <c:if test="${not empty errors}">
                <div class="alert" role="alert">
                    <p class="helper-text">Vui lòng kiểm tra lại các thông tin sau:</p>
                    <ul>
                        <c:forEach var="item" items="${errors}">
                            <li>${item}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form action="${ctx}/register" method="post" class="form-grid form-grid--two" autocomplete="off">
                <div class="form-field">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="${formData != null ? formData.username : ''}" required
                           placeholder="Ví dụ: nguyenanh">
                </div>
                <div class="form-field">
                    <label for="fullName">Họ và tên</label>
                    <input type="text" id="fullName" name="fullName" value="${formData != null ? formData.fullName : ''}" required
                           placeholder="Nhập đầy đủ họ tên">
                </div>
                <div class="form-field">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${formData != null ? formData.email : ''}" required
                           placeholder="email@domain.com">
                </div>
                <div class="form-field">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" value="${formData != null ? formData.phone : ''}" placeholder="090xxxxxxx">
                </div>
                <div class="form-field">
                    <label for="address">Địa chỉ</label>
                    <input type="text" id="address" name="address" value="${formData != null ? formData.address : ''}" placeholder="Số nhà, phường/xã">
                </div>
                <div class="form-field">
                    <label for="role">Vai trò</label>
                    <select id="role" name="role">
                        <option value="CUSTOMER" ${roleValue eq 'CUSTOMER' ? 'selected="selected"' : ''}>Khách hàng</option>
                        <option value="MANAGER" ${roleValue eq 'MANAGER' ? 'selected="selected"' : ''}>Quản lý</option>
                    </select>
                </div>
                <div class="form-field">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required placeholder="Tối thiểu 8 ký tự">
                </div>
                <div class="form-field">
                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                </div>
                <div class="form-actions">
                    <button type="submit" class="button button--primary">Hoàn tất đăng ký</button>
                    <a class="button button--ghost" href="${ctx}/login">Quay về đăng nhập</a>
                </div>
            </form>
        </div>
    </section>
</main>
<footer class="app-footer">
    <small>&copy; 2024 QLST. Đăng ký nhanh, bảo mật cao.</small>
    <div class="app-footer__links">
        <a href="${ctx}/">Trang chủ</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/statistics/customers">Thống kê</a>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
