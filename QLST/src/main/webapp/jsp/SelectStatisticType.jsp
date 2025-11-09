<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn loại thống kê - QLST</title>
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
            <p class="page-header__eyebrow">Thiết lập báo cáo</p>
            <h1 class="page-header__title">Chọn loại thống kê và khoảng thời gian</h1>
            <p class="page-header__subtitle">
                Xác định loại báo cáo cần xem và phạm vi ngày để tính toán doanh thu.
            </p>
        </div>

        <section class="card card--filters">
            <div>
                <h2 class="card__title">Điều kiện thống kê</h2>
                <p class="card__subtitle">Chọn loại thống kê và nhập khoảng thời gian để xem báo cáo chi tiết.</p>
            </div>
            <form action="${ctx}/customer-statistic" method="get" class="form-grid date-form">
                <div class="form-group">
                    <label for="statisticType">Loại thống kê</label>
                    <select id="statisticType" name="statisticType">
                        <option value="customer-revenue"
                                ${param.statisticType eq 'customer-revenue' ? 'selected="selected"' : ''}>
                            Khách hàng theo doanh thu
                        </option>
                        <option value="customer-order-count"
                                ${param.statisticType eq 'customer-order-count' ? 'selected="selected"' : ''}>
                            Khách hàng theo số lượng đơn hàng
                        </option>
                        <option value="customer-purchase-frequency"
                                ${param.statisticType eq 'customer-purchase-frequency' ? 'selected="selected"' : ''}>
                            Khách hàng theo tần suất mua hàng
                        </option>
                    </select>
                </div>
                <div class="date-range">
                    <div class="date-field">
                        <label for="startDate">Từ ngày</label>
                        <input type="date" id="startDate" name="startDate" required value="${param.startDate}">
                    </div>
                    <div class="date-field">
                        <label for="endDate">Đến ngày</label>
                        <input type="date" id="endDate" name="endDate" required value="${param.endDate}">
                    </div>
                </div>
                <div class="button-row">
                    <button type="submit" id="btnViewStatistic" name="btnViewStatistic" class="btn btn--primary">
                        Xem thống kê
                    </button>
                </div>
            </form>
        </section>
    </div>
</main>
</body>
</html>
