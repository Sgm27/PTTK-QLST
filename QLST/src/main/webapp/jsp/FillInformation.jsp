<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Điền thông tin thành viên - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="fillInformation"/>
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
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                    <a class="nav-link nav-link--logout" href="${ctx}/logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
                    <a class="nav-link${currentPage eq 'fillInformation' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page">
        <div class="page-header">
            <p class="page-header__eyebrow">QLST Members</p>
            <h1 class="page-header__title">Điền thông tin thành viên</h1>
            <p class="page-header__subtitle">Hoàn tất biểu mẫu bên dưới để gửi yêu cầu tạo tài khoản khách hàng.</p>
        </div>

        <section class="card" aria-labelledby="fill-information-heading">
            <div>
                <h2 class="card__title" id="fill-information-heading">Thông tin liên hệ</h2>
                <p class="card__subtitle">Vui lòng cung cấp thông tin chính xác để hệ thống thiết lập tài khoản.</p>
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

            <form action="${ctx}/register" method="post" autocomplete="off">
                <table id="tblInputInformation" class="form-table">
                    <tbody>
                    <tr>
                        <th><label for="name">Họ và tên</label></th>
                        <td>
                            <input type="text"
                                   id="name"
                                   name="name"
                                   value="${formData != null ? formData.name : ''}"
                                   required
                                   placeholder="Nguyễn Văn A"
                                   autocomplete="name">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="password">Mật khẩu</label></th>
                        <td>
                            <input type="password"
                                   id="password"
                                   name="password"
                                   required
                                   placeholder="Tối thiểu 8 ký tự"
                                   autocomplete="new-password">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="email">Email</label></th>
                        <td>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   value="${formData != null ? formData.email : ''}"
                                   required
                                   placeholder="email@domain.com"
                                   autocomplete="email">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="address">Địa chỉ</label></th>
                        <td>
                            <input type="text"
                                   id="address"
                                   name="address"
                                   value="${formData != null ? formData.address : ''}"
                                   placeholder="Số nhà, phường/xã"
                                   autocomplete="street-address">
                        </td>
                    </tr>
                    <tr>
                        <th><label for="phone">Số điện thoại</label></th>
                        <td>
                            <input type="tel"
                                   id="phone"
                                   name="phone"
                                   value="${formData != null ? formData.phone : ''}"
                                   placeholder="090xxxxxxx"
                                   autocomplete="tel">
                        </td>
                    </tr>
                    </tbody>
                </table>

                <div class="button-row">
                    <a class="btn btn--ghost" href="${ctx}/login">Đã có tài khoản</a>
                    <button id="btnRegister" type="submit" class="btn btn--primary">Gửi yêu cầu</button>
                </div>
            </form>
        </section>
    </div>
</main>
</body>
</html>
