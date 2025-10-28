<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết giao dịch khách hàng - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="app-shell">
<c:set var="currentPage" value="statistics"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>
<fmt:setLocale value="vi_VN"/>
<c:if test="${not empty currentUser}">
    <c:set var="displayName" value="${not empty currentUser.fullName ? currentUser.fullName : currentUser.username}"/>
    <c:set var="displayInitial" value="${fn:toUpperCase(fn:substring(displayName, 0, 1))}"/>
</c:if>
<header class="app-header">
    <div class="app-bar">
        <a class="brand" href="${ctx}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span class="brand__text">
                <span class="brand__title">QLST</span>
                <span class="brand__subtitle">Retail Suite</span>
            </span>
        </a>
        <div class="app-bar__nav-group">
            <nav class="app-nav" aria-label="Điều hướng chính">
                <a class="app-nav__link${currentPage eq 'home' ? ' is-active' : ''}" href="${ctx}/">Trang chủ</a>
                <a class="app-nav__link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/statistics/customers" data-active-root="${ctx}/statistics">Thống kê</a>
            </nav>
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <div class="app-nav app-nav--auth" aria-label="Tài khoản">
                        <span class="app-nav__user">
                            <span class="app-nav__user-badge" aria-hidden="true">${displayInitial}</span>
                            <span>Xin chào, <c:out value="${displayName}"/></span>
                        </span>
                        <form class="app-nav__logout" action="${ctx}/logout" method="post">
                            <button type="submit" class="button button--ghost button--small">Đăng xuất</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <nav class="app-nav app-nav--auth" aria-label="Tài khoản">
                        <a class="app-nav__link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
                        <a class="app-nav__link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    </nav>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<main>
    <section class="container container--wide analytics-layout">
        <c:url var="backToStatisticsUrl" value="/statistics/customers">
            <c:param name="startDate" value="${empty startDate ? '' : startDate}"/>
            <c:param name="endDate" value="${empty endDate ? '' : endDate}"/>
        </c:url>

        <div class="analytics-header">
            <div class="analytics-header__text">
                <p class="analytics-header__eyebrow">QLST Insight</p>
                <h1 class="analytics-header__title">Chi tiết giao dịch khách hàng</h1>
                <p class="analytics-header__description">
                    Xem lịch sử giao dịch của khách hàng cùng thông tin liên hệ để đưa ra quyết định chăm sóc chính xác.
                </p>
            </div>
            <a class="button button--ghost analytics-header__action" href="${backToStatisticsUrl}">Quay lại thống kê</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">${error}</div>
        </c:if>

        <c:if test="${empty error}">
            <c:if test="${not empty startDate}">
                <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="startDateObj"/>
            </c:if>
            <c:if test="${not empty endDate}">
                <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="endDateObj"/>
            </c:if>

            <div class="stats-grid analytics-summary" role="region" aria-label="Tổng quan giao dịch">
                <div class="stat-tile">
                    <span class="stat-tile__label">Ngày bắt đầu thống kê</span>
                    <span class="stat-tile__value">
                        <c:choose>
                            <c:when test="${not empty startDateObj}">
                                <fmt:formatDate value="${startDateObj}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="stat-tile">
                    <span class="stat-tile__label">Ngày kết thúc thống kê</span>
                    <span class="stat-tile__value">
                        <c:choose>
                            <c:when test="${not empty endDateObj}">
                                <fmt:formatDate value="${endDateObj}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="stat-tile">
                    <span class="stat-tile__label">Tổng giá trị giao dịch</span>
                    <span class="stat-tile__value">
                        <fmt:formatNumber value="${totalAmount}" type="currency"/>
                    </span>
                </div>
            </div>

            <div class="analytics-grid analytics-grid--details">
                <div class="surface-card surface-card--tight analytics-grid__side" aria-labelledby="customer-heading">
                    <p class="breadcrumb" aria-label="Đường dẫn">
                        <a href="${backToStatisticsUrl}">Thống kê khách hàng</a>
                        <span aria-hidden="true">/</span>
                        <span>Chi tiết giao dịch</span>
                    </p>
                    <div class="analytics-card__header">
                        <h2 class="section-title" id="customer-heading">Thông tin khách hàng</h2>
                        <p class="section-subtitle">Tổng hợp dữ liệu liên quan tới khách hàng trong khoảng thời gian đã chọn.</p>
                    </div>
                    <div class="meta-list">
                        <div class="meta-item">
                            <span class="meta-item__label">Họ tên</span>
                            <span class="meta-item__value"><c:out value="${customer.fullName}"/></span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-item__label">Email</span>
                            <span class="meta-item__value"><c:out value="${customer.email}"/></span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-item__label">Số điện thoại</span>
                            <span class="meta-item__value"><c:out value="${empty customer.phoneNumber ? 'Chưa cập nhật' : customer.phoneNumber}"/></span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-item__label">Địa chỉ</span>
                            <span class="meta-item__value"><c:out value="${empty customer.address ? 'Chưa cập nhật' : customer.address}"/></span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-item__label">Khoảng thời gian</span>
                            <span class="meta-item__value">
                                <c:choose>
                                    <c:when test="${not empty startDateObj and not empty endDateObj}">
                                        <fmt:formatDate value="${startDateObj}" pattern="dd/MM/yyyy"/> →
                                        <fmt:formatDate value="${endDateObj}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>${startDate} → ${endDate}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty transactions}">
                        <div class="data-panel analytics-grid__main" aria-labelledby="transaction-heading">
                            <div class="data-panel__header">
                                <h2 class="section-title" id="transaction-heading">Danh sách giao dịch</h2>
                                <p class="section-subtitle">Các giao dịch được sắp xếp theo thời gian gần nhất.</p>
                            </div>
                            <div class="data-panel__body">
                                <div class="table-wrapper">
                                    <table aria-describedby="transaction-heading">
                                        <thead>
                                        <tr>
                                            <th scope="col">Mã GD</th>
                                            <th scope="col">Thời gian</th>
                                            <th scope="col">Mô tả</th>
                                            <th scope="col">Giá trị</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="transaction" items="${transactions}">
                                            <tr>
                                                <td>${transaction.id}</td>
                                                <td>${transaction.transactionDate != null ? transaction.transactionDate.format(timeFormatter) : '-'}</td>
                                                <td><c:out value="${empty transaction.description ? 'Không có mô tả' : transaction.description}"/></td>
                                                <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state analytics-grid__main" role="status">
                            <p>Khách hàng chưa phát sinh giao dịch trong khoảng thời gian này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </section>
</main>
<footer class="app-footer">
    <small>&copy; 2024 QLST. Chi tiết giao dịch trực quan.</small>
    <div class="app-footer__links">
        <a href="${ctx}/">Trang chủ</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/statistics/customers">Thống kê</a>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
