<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành viên - QLST</title>
</head>
<body>
<h2>Đăng ký thành viên</h2>
<form action="${pageContext.request.contextPath}/register" method="post">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" required>

    <label for="fullName">Họ và tên</label>
    <input type="text" id="fullName" name="fullName" required>

    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>

    <label for="phone">Số điện thoại</label>
    <input type="tel" id="phone" name="phone">

    <label for="password">Mật khẩu</label>
    <input type="password" id="password" name="password" required>

    <button type="submit">Đăng ký</button>
</form>
<p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
</body>
</html>
