<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="register"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>
<c:set var="roleValue" value="${selectedRole != null ? selectedRole : (formData != null ? formData.role : 'CUSTOMER')}"/>
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
                    <a class="nav-link nav-link--logout" href="${ctx}/logout">Đăng xuất</a>
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
            <p class="page-header__eyebrow">QLST Members</p>
            <h1 class="page-header__title">Tạo tài khoản mới</h1>
            <p class="page-header__subtitle">Điền các trường bên dưới để kích hoạt quyền truy cập khách hàng hoặc quản lý.</p>
        </div>

        <section class="card" aria-labelledby="register-heading">
            <div>
                <h2 class="card__title" id="register-heading">Thông tin cần thiết</h2>
                <p class="card__subtitle">Chúng tôi chỉ yêu cầu những dữ liệu tối thiểu để thiết lập tài khoản.</p>
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

            <form action="${ctx}/register" method="post" class="form-grid" autocomplete="off">
                <div class="form-grid form-grid--two-column">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" value="${formData != null ? formData.username : ''}" required
                               placeholder="Ví dụ: nguyenanh" autocomplete="username">
                        <p class="helper-text">Tên viết liền, tối thiểu 4 ký tự.</p>
                    </div>
                    <div class="form-group">
                        <label for="role">Vai trò</label>
                        <select id="role" name="role">
                            <option value="CUSTOMER" ${roleValue eq 'CUSTOMER' ? 'selected="selected"' : ''}>Khách hàng</option>
                            <option value="MANAGER" ${roleValue eq 'MANAGER' ? 'selected="selected"' : ''}>Quản lý</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="password" required placeholder="Tối thiểu 8 ký tự" autocomplete="new-password">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu" autocomplete="new-password">
                    </div>
                </div>

                <div class="form-grid form-grid--two-column">
                    <div class="form-group">
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" value="${formData != null ? formData.fullName : ''}" required
                               placeholder="Nhập đầy đủ họ tên" autocomplete="name">
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${formData != null ? formData.email : ''}" required
                               placeholder="email@domain.com" autocomplete="email">
                    </div>
                </div>

                <div class="form-grid form-grid--two-column">
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" value="${formData != null ? formData.phone : ''}"
                               placeholder="090xxxxxxx" autocomplete="tel">
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" name="address" value="${formData != null ? formData.address : ''}"
                               placeholder="Số nhà, phường/xã" autocomplete="street-address">
                    </div>
                </div>

                <div class="button-row">
                    <a class="btn btn--ghost" href="${ctx}/login">Đã có tài khoản</a>
                    <button type="submit" class="btn btn--primary">Hoàn tất đăng ký</button>
                </div>
            </form>
        </section>
    </div>
</main>

</body>
</html>
