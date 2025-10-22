<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - QLST</title>
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
            <p class="app-tagline">Đăng nhập để tiếp tục quản lý siêu thị của bạn</p>
            <nav class="primary-nav" aria-label="Liên kết nhanh">
                <a href="${pageContext.request.contextPath}/login" class="is-active">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
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
                <div class="sidebar-title">Hướng dẫn nhanh</div>
                <nav class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/register">Tạo tài khoản mới</a>
                    <a href="${pageContext.request.contextPath}/customer">Xem thống kê khách hàng</a>
                    <a href="${pageContext.request.contextPath}/warehouse">Quản lý kho</a>
                </nav>
            </div>
            <p class="sidebar-note">Liên hệ bộ phận hỗ trợ nếu bạn quên mật khẩu hoặc cần phân quyền mới.</p>
        </aside>
        <main class="app-content">
            <section class="form-card" aria-labelledby="login-title">
                <div class="section-header">
                    <div>
                        <h2 id="login-title">Chào mừng trở lại</h2>
                        <p>Sử dụng thông tin tài khoản được cấp để truy cập bảng điều khiển.</p>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="form-grid" autocomplete="on">
                    <div class="full-width">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" value="${empty username ? '' : username}" required autofocus>
                    </div>
                    <div class="full-width">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div class="form-actions full-width">
                        <button type="submit" class="btn btn-primary">Đăng nhập</button>
                    </div>
                </form>
                <p class="form-note">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
            </section>
        </main>
    </div>
    <footer class="site-footer">
        <div class="site-footer__inner">
            <small>&copy; 2024 QLST &mdash; Đăng nhập an toàn cho mọi vai trò</small>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
