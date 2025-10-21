<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành viên - QLST</title>
</head>
<body>
<h2>Đăng ký thành viên</h2>
<c:if test="${not empty errors}">
    <div class="alert alert-error">
        <ul>
            <c:forEach var="error" items="${errors}">
                <li>${error}</li>
            </c:forEach>
        </ul>
    </div>
</c:if>
<form action="${pageContext.request.contextPath}/register" method="post">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" value="${formData != null ? formData.username : ''}" required>

    <label for="fullName">Họ và tên</label>
    <input type="text" id="fullName" name="fullName" value="${formData != null ? formData.fullName : ''}" required>

    <label for="email">Email</label>
    <input type="email" id="email" name="email" value="${formData != null ? formData.email : ''}" required>

    <label for="phone">Số điện thoại</label>
    <input type="tel" id="phone" name="phone" value="${formData != null ? formData.phone : ''}">

    <label for="role">Vai trò</label>
    <c:set var="selectedRole" value="${formData != null ? formData.role : 'CUSTOMER'}" />
    <select id="role" name="role">
        <option value="CUSTOMER"<c:if test="${selectedRole == 'CUSTOMER'}"> selected</c:if>>Khách hàng</option>
        <option value="SALES"<c:if test="${selectedRole == 'SALES'}"> selected</c:if>>Nhân viên bán hàng</option>
        <option value="WAREHOUSE"<c:if test="${selectedRole == 'WAREHOUSE'}"> selected</c:if>>Nhân viên kho</option>
        <option value="MANAGER"<c:if test="${selectedRole == 'MANAGER'}"> selected</c:if>>Quản lý</option>
    </select>

    <label for="password">Mật khẩu</label>
    <input type="password" id="password" name="password" required>

    <label for="confirmPassword">Xác nhận mật khẩu</label>
    <input type="password" id="confirmPassword" name="confirmPassword" required>

    <button type="submit">Đăng ký</button>
</form>
<p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
</body>
</html>
