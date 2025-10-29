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
                    <a class="nav-link nav-link--logout" href="${ctx}/logout">Đăng xuất</a>
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
            <h1 class="page-header__title">Báo cáo doanh thu theo khách hàng</h1>
            <p class="page-header__subtitle">Chọn khoảng thời gian để xem tổng doanh thu, số giao dịch và đi tới chi tiết của từng khách hàng.</p>
        </div>

        <c:if test="${not empty startDate}">
            <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="startDateObj"/>
        </c:if>
        <c:if test="${not empty endDate}">
            <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="endDateObj"/>
        </c:if>

        <div class="card-stack">
            <section class="card card--filters" aria-labelledby="filter-heading">
                <div>
                    <h2 class="card__title" id="filter-heading">Khoảng thời gian</h2>
                    <p class="card__subtitle">Chọn ngày bắt đầu và ngày kết thúc, sau đó nhấn "Xem báo cáo".</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert" role="alert">${error}</div>
                </c:if>

                <form action="${ctx}/statistics/customers" method="post" class="date-form">
                    <div class="date-range">
                        <div class="date-field">
                            <label for="startDate">Từ ngày</label>
                            <div class="input-with-icon">
                                <span class="input-with-icon__icon" aria-hidden="true">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <rect x="3" y="5" width="18" height="16" rx="2" stroke="currentColor" stroke-width="1.4"/>
                                        <path d="M8 3V7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                        <path d="M16 3V7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                        <path d="M3 10H21" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                    </svg>
                                </span>
                                <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                            </div>
                        </div>
                        <div class="date-field">
                            <label for="endDate">Đến ngày</label>
                            <div class="input-with-icon">
                                <span class="input-with-icon__icon" aria-hidden="true">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <rect x="3" y="5" width="18" height="16" rx="2" stroke="currentColor" stroke-width="1.4"/>
                                        <path d="M8 3V7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                        <path d="M16 3V7" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                        <path d="M3 10H21" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                                    </svg>
                                </span>
                                <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                            </div>
                        </div>
                    </div>
                    <div class="button-row button-row--align-start">
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
                            <div class="summary-banner" role="status">
                                <div class="summary-banner__item">
                                    <span class="summary-banner__label">Khoảng thời gian</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty startDateObj and not empty endDateObj}">
                                                <fmt:formatDate value="${startDateObj}" pattern="dd/MM/yyyy"/> →
                                                <fmt:formatDate value="${endDateObj}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>${startDate} → ${endDate}</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                                <div class="summary-banner__item">
                                    <span class="summary-banner__label">Số khách hàng</span>
                                    <strong>${totalCustomers}</strong>
                                </div>
                            </div>
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

</body>
</html>
