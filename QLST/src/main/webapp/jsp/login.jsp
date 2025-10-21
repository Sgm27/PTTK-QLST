<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - QLST</title>
</head>
<body>
<h2>Đăng nhập hệ thống</h2>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success">${message}</div>
</c:if>
<form action="${pageContext.request.contextPath}/login" method="post">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" value="${empty username ? '' : username}" required>

    <label for="password">Mật khẩu</label>
    <input type="password" id="password" name="password" required>

    <button type="submit">Đăng nhập</button>
</form>
<p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
</body>
</html>
