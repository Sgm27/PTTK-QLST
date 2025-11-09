<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống kê doanh thu khách hàng - QLST</title>
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
                    <a class="nav-link${currentPage eq 'fillInformation' ? ' is-active' : ''}" href="${ctx}/register">Đăng ký</a>
                    <a class="nav-link${currentPage eq 'statistics' ? ' is-active' : ''}" href="${ctx}/jsp/MainManagement.jsp">Thống kê</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <div class="page">
        <div class="page-header page-header--full">
            <p class="page-header__eyebrow">Báo cáo doanh thu</p>
            <h1 class="page-header__title">Kết quả thống kê khách hàng</h1>
            <p class="page-header__subtitle">
                <c:choose>
                    <c:when test="${hasRange}">
                        Doanh thu được tổng hợp cho giai đoạn từ
                        <strong><c:out value="${startDate}"/></strong>
                        đến
                        <strong><c:out value="${endDate}"/></strong>.
                    </c:when>
                    <c:otherwise>
                        Chọn khoảng thời gian ở bước trước để xem báo cáo doanh thu khách hàng.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${not empty listCustomerStatistic}">
            <section class="card">
                <div class="summary-banner">
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Từ ngày</span>
                        <span class="summary-banner__value"><c:out value="${startDate}"/></span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Đến ngày</span>
                        <span class="summary-banner__value"><c:out value="${endDate}"/></span>
                    </div>
                    <div class="summary-banner__item">
                        <span class="summary-banner__label">Số khách hàng</span>
                        <span class="summary-banner__value">
                            <c:out value="${fn:length(listCustomerStatistic)}"/>
                        </span>
                    </div>
                </div>
                
                <div class="search-box">
                    <input
                        type="text"
                        id="searchInput"
                        class="search-box__input"
                        placeholder="Tìm kiếm nhanh theo mã hoặc tên khách hàng..."
                        autocomplete="off"
                    >
                    <button type="button" id="searchBtn" class="btn btn--primary search-box__btn">
                        Tìm kiếm
                    </button>
                </div>
                
                <div class="table-wrapper">
                    <table id="tblCustomerStatistic">
                        <thead>
                        <tr>
                            <th>Mã khách hàng</th>
                            <th>Họ tên</th>
                            <th class="text-right">Tổng doanh thu (VNĐ)</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="statistic" items="${listCustomerStatistic}">
                            <tr>
                                <td><c:out value="${statistic.customer.id}"/></td>
                                <td><c:out value="${statistic.customer.name}"/></td>
                                <td class="text-right">
                                    <fmt:formatNumber value="${statistic.totalPrice}" type="number" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    <form action="${ctx}/customer-order" method="get" style="display: inline;">
                                        <input type="hidden" name="startDate" value="${startDate}">
                                        <input type="hidden" name="endDate" value="${endDate}">
                                        <input type="hidden" name="customerId" value="${statistic.customer.id}">
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
        </c:if>

        <c:if test="${empty listCustomerStatistic and empty error}">
            <div class="empty-state">
                Không có dữ liệu doanh thu cho khoảng thời gian đã chọn.
            </div>
        </c:if>
    </div>
</main>

<script>
(function() {
    const searchInput = document.getElementById('searchInput');
    const table = document.getElementById('tblCustomerStatistic');
    
    if (!searchInput || !table) return;
    
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    
    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    searchInput.addEventListener('input', function() {
        const searchText = this.value.trim().toLowerCase();

        if (searchText === '') {
            rows.forEach(row => {
                row.style.display = '';
            });
            return;
        }

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length < 2) return;

            const customerId = cells[0].textContent.trim().toLowerCase();
            const customerName = cells[1].textContent.trim().toLowerCase();

            const isMatch = customerId.includes(searchText) || customerName.includes(searchText);
            row.style.display = isMatch ? '' : 'none';
        });
    });
})();
</script>
</body>
</html>
