<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang chủ QLST">
            <span class="brand__mark">QL</span>
            <span>QLST</span>
        </a>
        <nav class="site-nav" aria-label="Điều hướng chính">
            <a href="${pageContext.request.contextPath}/login" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a4.5 4.5 0 10-4.5-4.5A4.51 4.51 0 0012 12zm0 2c-3.6 0-6.5 1.87-6.5 4.17V20h13v-1.83C18.5 15.87 15.6 14 12 14z"/></svg>
                </span>
                <span class="nav-label">Đăng nhập</span>
            </a>
            <a href="${pageContext.request.contextPath}/register" class="nav-link">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M12 12a5 5 0 10-5-5 5 5 0 005 5zm7 1h-3v-3h-2v3h-3v2h3v3h2v-3h3zM4 18.25C4 15.9 7.13 14 12 14v2c-3.87 0-6 1.23-6 2.25V20H4z"/></svg>
                </span>
                <span class="nav-label">Đăng ký</span>
            </a>
            <a href="${pageContext.request.contextPath}/reports" class="nav-link is-active">
                <span class="nav-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" role="presentation"><path d="M5 4h3v16H5zm5 6h3v10h-3zm5-4h3v14h-3z"/></svg>
                </span>
                <span class="nav-label">Thống kê</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <section class="card report-card" aria-labelledby="report-title">
        <div class="section-header">
            <div>
                <h1 id="report-title">Thống kê khách hàng theo doanh thu</h1>
                <p>Chọn khoảng thời gian phù hợp để xem tổng doanh thu, số đơn hàng và mở trang chi tiết cho từng khách hàng.</p>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reports" method="get" class="filter-form">
            <input type="hidden" name="submitted" value="true">
            <div class="filter-form__row">
                <div>
                    <label for="startDate">Ngày bắt đầu</label>
                    <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                </div>
                <div>
                    <label for="endDate">Ngày kết thúc</label>
                    <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">Xem thống kê</button>
                <c:if test="${not empty startDate or not empty endDate}">
                    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/reports">Bỏ lọc</a>
                </c:if>
            </div>
            <p class="filter-form__hint">Mốc thời gian được tính theo ngày đặt hàng và bao gồm cả ngày bắt đầu, kết thúc.</p>
        </form>

        <c:choose>
            <c:when test="${not empty customerRevenue}">
                <div class="table-card" aria-live="polite">
                    <div class="table-responsive">
                        <table aria-label="Báo cáo doanh thu khách hàng">
                            <thead>
                            <tr>
                                <th scope="col">Mã khách hàng</th>
                                <th scope="col">Họ tên</th>
                                <th scope="col">Tổng doanh thu</th>
                                <th scope="col">Số đơn</th>
                                <th scope="col" class="table-actions">Chi tiết</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${customerRevenue}">
                                <tr>
                                    <td>${item.customerId}</td>
                                    <td>${item.customerName}</td>
                                    <td>${item.revenue}</td>
                                    <td>${item.orderCount}</td>
                                    <td class="table-actions">
                                        <c:url var="detailUrl" value="/reports/customer">
                                            <c:param name="startDate" value="${startDate}"/>
                                            <c:param name="endDate" value="${endDate}"/>
                                            <c:param name="customerId" value="${item.customerId}"/>
                                            <c:param name="submitted" value="true"/>
                                        </c:url>
                                        <a class="btn btn-secondary" href="${detailUrl}">Xem chi tiết</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state" aria-live="polite">
                    <p><strong>Chưa có dữ liệu thống kê.</strong> Hãy chọn khoảng thời gian rồi nhấn “Xem thống kê”.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
<footer class="site-footer">
    <small>&copy; 2024 QLST &mdash; Theo dõi doanh thu khách hàng hiệu quả</small>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
