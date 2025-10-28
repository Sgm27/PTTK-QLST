<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng - QLST</title>
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
    <section class="container analytics-layout">
        <div class="analytics-header">
            <div class="analytics-header__text">
                <p class="analytics-header__eyebrow">QLST Insight</p>
                <h1 class="analytics-header__title">Thống kê doanh thu theo khách hàng</h1>
                <p class="analytics-header__description">
                    Lọc dữ liệu theo khoảng thời gian để theo dõi doanh thu và truy cập nhanh tới chi tiết giao dịch của từng khách hàng.
                </p>
            </div>
        </div>

        <div class="analytics-grid">
            <div class="surface-card surface-card--tight analytics-grid__side" aria-labelledby="filter-heading">
                <div class="analytics-card__header">
                    <h2 class="section-title" id="filter-heading">Bộ lọc thời gian</h2>
                    <p class="section-subtitle">Chọn khoảng ngày để hệ thống tổng hợp doanh thu tương ứng.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert" role="alert">${error}</div>
                </c:if>

                <form action="${ctx}/statistics/customers" method="post" class="form-grid form-grid--two">
                    <div class="form-field">
                        <label for="startDate">Ngày bắt đầu</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                    </div>
                    <div class="form-field">
                        <label for="endDate">Ngày kết thúc</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="button button--primary">Xem báo cáo</button>
                    </div>
                </form>
            </div>

            <c:choose>
                <c:when test="${not empty customerRevenue}">
                    <c:set var="totalCustomers" value="${fn:length(customerRevenue)}"/>
                    <div class="data-panel analytics-grid__main" aria-labelledby="report-heading">
                        <div class="data-panel__header">
                            <h2 class="section-title" id="report-heading">Bảng xếp hạng khách hàng</h2>
                            <p class="section-subtitle">
                                Có ${totalCustomers} khách hàng phù hợp trong khoảng thời gian ${startDate} → ${endDate}. Chọn nút
                                <strong>Mở trang chi tiết</strong> để chuyển sang màn hình giao dịch riêng cho từng người.
                            </p>
                        </div>
                        <div class="data-panel__body">
                            <div class="table-wrapper">
                                <table aria-describedby="report-heading">
                                    <thead>
                                    <tr>
                                        <th scope="col">Mã KH</th>
                                        <th scope="col">Họ tên</th>
                                        <th scope="col">Tổng doanh thu</th>
                                        <th scope="col">Số giao dịch</th>
                                        <th scope="col" class="table-actions">Chi tiết</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${customerRevenue}">
                                        <tr>
                                            <td>${item.customerId}</td>
                                            <td><c:out value="${item.customerName}"/></td>
                                            <td><fmt:formatNumber value="${item.revenue}" type="currency"/></td>
                                            <td>${item.transactionCount}</td>
                                            <td class="table-actions">
                                                <a class="button button--ghost" href="${ctx}/statistics/transactions?customerId=${item.customerId}&amp;startDate=${startDate}&amp;endDate=${endDate}"
                                                   aria-label="Mở trang chi tiết giao dịch của ${item.customerName}">Mở trang chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:if test="${not empty startDate and not empty endDate}">
                        <div class="empty-state analytics-grid__full" role="status">
                            <p>Không có dữ liệu giao dịch trong khoảng thời gian đã chọn.</p>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>
<footer class="app-footer">
    <small>&copy; 2024 QLST. Báo cáo doanh thu chính xác, thời gian thực.</small>
    <div class="app-footer__links">
        <a href="${ctx}/">Trang chủ</a>
        <span aria-hidden="true">•</span>
        <a href="${ctx}/login">Đăng nhập</a>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
