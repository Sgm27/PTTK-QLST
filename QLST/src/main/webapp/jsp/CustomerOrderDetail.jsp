<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPage" value="statistics"/>
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
                    <a class="nav-link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page page--wide">
        <div class="page-header page-header--full">
            <p class="page-header__eyebrow">Chi tiết đơn hàng</p>
            <h1 class="page-header__title">Thông tin sản phẩm trong đơn hàng</h1>
            <p class="page-header__subtitle">
                Danh sách chi tiết các sản phẩm trong đơn hàng.
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty order}">
            <section class="card">
                <div class="summary-banner">
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Mã đơn hàng</span>
                        <span class="summary-banner__value"><c:out value="${order.id}"/></span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Ngày đặt</span>
                        <span class="summary-banner__value">
                            <c:choose>
                                <c:when test="${not empty order.date}">
                                    <fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Tổng tiền (VNĐ)</span>
                        <span class="summary-banner__value">
                            <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>
                        </span>
                    </div>
                </div>
            </section>
        </c:if>

        <div style="text-align: right; margin: 1.5rem 0;">
            <form action="${ctx}/customer-order" method="get" style="display: inline;">
                <input type="hidden" name="customerId" value="${customerId}">
                <input type="hidden" name="startDate" value="${startDate}">
                <input type="hidden" name="endDate" value="${endDate}">
                <button type="submit" id="btnClose" name="btnClose" class="btn btn--ghost">
                    Quay lại danh sách đơn hàng
                </button>
            </form>
        </div>

        <c:if test="${not empty order}">
            <c:choose>
                <c:when test="${not empty order.listOrderDetail}">
                    <section class="card">
                        <div>
                            <h2 class="card__title">Danh sách sản phẩm</h2>
                            <p class="card__subtitle">
                                Chi tiết các sản phẩm trong đơn hàng này.
                            </p>
                        </div>
                        <div class="table-wrapper">
                            <table id="tblOrderDetail">
                                <thead>
                                <tr>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th class="text-right">Đơn giá (VNĐ)</th>
                                    <th class="text-right">Thành tiền (VNĐ)</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="detail" items="${order.listOrderDetail}">
                                    <tr>
                                        <td><c:out value="${detail.product.id}"/></td>
                                        <td><c:out value="${detail.product.name}"/></td>
                                        <td><c:out value="${detail.quantity}"/></td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        Đơn hàng này chưa có sản phẩm nào.
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</main>
</body>
</html>
