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
<body>
<c:set var="currentPage" value="statistics"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>
<fmt:setLocale value="vi_VN"/>
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
                    <a class="nav-link is-active" href="${ctx}/statistics/customers">Thống kê</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">Đăng nhập</a>
                    <a class="nav-link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link is-active" href="${ctx}/statistics/customers">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page">
        <div class="page-header">
            <p class="page-header__eyebrow">QLST Insight</p>
            <h1 class="page-header__title">Thống kê doanh thu khách hàng</h1>
            <p class="page-header__subtitle">Lọc dữ liệu theo khoảng thời gian để xem tổng doanh thu và số giao dịch của từng khách hàng.</p>
        </div>

        <div class="card-grid card-grid--split">
            <section class="card card--narrow" aria-labelledby="filter-heading">
                <div>
                    <h2 class="card__title" id="filter-heading">Khoảng thời gian</h2>
                    <p class="card__subtitle">Chọn ngày bắt đầu và kết thúc trước khi xem báo cáo.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert" role="alert">${error}</div>
                </c:if>

                <form action="${ctx}/statistics/customers" method="post" class="form-grid">
                    <div class="form-group">
                        <label for="startDate">Ngày bắt đầu</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate">Ngày kết thúc</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                    </div>
                    <div class="button-row">
                        <button type="submit" class="btn btn--primary">Xem báo cáo</button>
                    </div>
                </form>
            </section>

            <c:choose>
                <c:when test="${not empty customerRevenue}">
                    <c:set var="totalCustomers" value="${fn:length(customerRevenue)}"/>
                    <section class="card" aria-labelledby="report-heading">
                        <div>
                            <h2 class="card__title" id="report-heading">Kết quả thống kê</h2>
                            <p class="card__subtitle">Có ${totalCustomers} khách hàng phù hợp trong khoảng ${startDate} → ${endDate}.</p>
                        </div>
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
                                            <a class="btn btn--ghost" href="${ctx}/statistics/transactions?customerId=${item.customerId}&amp;startDate=${startDate}&amp;endDate=${endDate}">Xem</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:when>
                <c:otherwise>
                    <section class="card" aria-live="polite">
                        <h2 class="card__title">Chưa có dữ liệu</h2>
                        <c:choose>
                            <c:when test="${not empty startDate and not empty endDate}">
                                <p class="card__subtitle">Không tìm thấy giao dịch trong khoảng thời gian đã chọn.</p>
                            </c:when>
                            <c:otherwise>
                                <p class="card__subtitle">Chọn ngày bắt đầu và ngày kết thúc để xem bảng thống kê.</p>
                            </c:otherwise>
                        </c:choose>
                        <div class="empty-state">
                            <p>Hệ thống sẽ hiển thị dữ liệu ngay sau khi bạn chạy báo cáo.</p>
                        </div>
                    </section>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<footer class="site-footer">
    <div class="site-footer__inner">
        <small>&copy; 2024 QLST. Thống kê rõ ràng, giao diện tối giản.</small>
        <div class="site-footer__links">
            <a href="${ctx}/login">Đăng nhập</a>
            <a href="${ctx}/register">Đăng ký</a>
        </div>
    </div>
</footer>
</body>
</html>
