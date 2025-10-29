<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="login"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>
<c:if test="${not empty currentUser}">
    <c:set var="displayName" value="${not empty currentUser.fullName ? currentUser.fullName : currentUser.username}"/>
</c:if>

<header class="top-bar">
    <div class="top-bar__inner">
        <a class="brand" href="${ctx}/login">
            <span class="brand__badge">QL</span>
            <span>QLST</span>
        </a>
        <div class="top-bar__links">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <span class="nav-pill">Xin chào, <c:out value="${displayName}"/></span>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/statistics/customers">Thống kê</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
                    <a class="nav-link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/statistics/customers">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page">
        <div class="page-header">
            <p class="page-header__eyebrow">QLST Access</p>
            <h1 class="page-header__title">Đăng nhập tài khoản</h1>
            <p class="page-header__subtitle">Nhập thông tin để truy cập bảng điều khiển và báo cáo khách hàng.</p>
        </div>

        <section class="card card--narrow" aria-labelledby="login-heading">
            <div>
                <h2 class="card__title" id="login-heading">Thông tin đăng nhập</h2>
                <p class="card__subtitle">Tên đăng nhập và mật khẩu đều là bắt buộc.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert" role="status">${message}</div>
            </c:if>

            <form action="${ctx}/login" method="post" class="form-grid" autocomplete="on">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="${empty username ? '' : username}" required
                           placeholder="Ví dụ: nguyenanh" autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
                </div>
                <div class="button-row">
                    <button type="submit" class="btn btn--primary">Đăng nhập</button>
                </div>
            </form>

            <p class="helper-text">Chưa có tài khoản? <a href="${ctx}/register">Tạo mới ngay</a>.</p>
        </section>
    </div>
</main>

<footer class="site-footer">
    <div class="site-footer__inner">
        <small>&copy; 2024 QLST. Đăng nhập an toàn với giao diện đơn giản.</small>
        <div class="site-footer__links">
            <a href="${ctx}/register">Đăng ký</a>
            <a href="${ctx}/statistics/customers">Thống kê</a>
        </div>
    </div>
</footer>
</body>
</html>
