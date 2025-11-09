<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng khách hàng - QLST</title>
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
<c:set var="hasRange" value="${not empty startDate and not empty endDate}"/>

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
            <h1 class="page-header__title">Đơn hàng theo khách hàng</h1>
            <p class="page-header__subtitle">
                <c:choose>
                    <c:when test="${hasRange}">
                        Danh sách đơn hàng của khách hàng trong giai đoạn
                        <strong><c:out value="${startDate}"/></strong>
                        đến
                        <strong><c:out value="${endDate}"/></strong>.
                    </c:when>
                    <c:otherwise>
                        Chọn khách hàng từ bước thống kê để xem chi tiết đơn hàng.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty customerStatistic}">
            <section class="card">
                <div class="summary-banner">
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Khách hàng</span>
                        <span class="summary-banner__value"><c:out value="${customerStatistic.customer.name}"/></span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Mã khách hàng</span>
                        <span class="summary-banner__value"><c:out value="${customerStatistic.customer.id}"/></span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Tổng doanh thu (VNĐ)</span>
                        <span class="summary-banner__value">
                            <fmt:formatNumber value="${customerStatistic.totalPrice}" type="number" maxFractionDigits="0"/>
                        </span>
                    </div>
                </div>
            </section>
        </c:if>

        <div style="text-align: right; margin: 1.5rem 0;">
            <form action="${ctx}/customer-statistic" method="get" style="display: inline;">
                <input type="hidden" name="statisticType" value="customer revenue">
                <input type="hidden" name="startDate" value="${startDate}">
                <input type="hidden" name="endDate" value="${endDate}">
                <button type="submit" id="btnClose" name="btnClose" class="btn btn--ghost">
                    Quay lại thống kê
                </button>
            </form>
        </div>

        <c:choose>
            <c:when test="${not empty lstOrder}">
                <section class="card">
                    <div>
                        <h2 class="card__title">Danh sách đơn hàng</h2>
                        <p class="card__subtitle">
                            Các đơn hàng được liệt kê theo thứ tự mới nhất.
                        </p>
                    </div>
                    <div class="table-wrapper">
                        <table id="tblOrder">
                            <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Ngày đặt</th>
                                <th class="text-right">Tổng tiền (VNĐ)</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="order" items="${lstOrder}">
                                <tr>
                                    <td><c:out value="${order.id}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.date}">
                                                <fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <form action="${ctx}/customer-order-detail" method="get" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="customerId" value="${customerStatistic.customer.id}">
                                            <input type="hidden" name="startDate" value="${startDate}">
                                            <input type="hidden" name="endDate" value="${endDate}">
                                            <button type="submit" class="btn btn--sm btn--primary">
                                                Xem chi tiết
                                            </button>
                                        </form>
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
                    Không tìm thấy đơn hàng nào cho khách hàng trong khoảng thời gian này.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
</body>
</html>
