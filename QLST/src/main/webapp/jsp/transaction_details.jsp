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
            <p class="page-header__eyebrow">QLST Insight</p>
            <h1 class="page-header__title">Chi tiết giao dịch khách hàng</h1>
            <p class="page-header__subtitle">Theo dõi lịch sử giao dịch và thông tin liên hệ của khách hàng trong khoảng thời gian đã chọn.</p>
        </div>

        <c:url var="backToStatisticsUrl" value="/statistics/customers">
            <c:param name="startDate" value="${empty startDate ? '' : startDate}"/>
            <c:param name="endDate" value="${empty endDate ? '' : endDate}"/>
        </c:url>

        <c:if test="${not empty error}">
            <section class="card card--narrow" role="alert">
                <div class="alert">${error}</div>
                <div class="button-row">
                    <a class="btn btn--ghost" href="${backToStatisticsUrl}">Quay lại thống kê</a>
                </div>
            </section>
        </c:if>

        <c:if test="${empty error}">
            <c:if test="${not empty startDate}">
                <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="startDateObj"/>
            </c:if>
            <c:if test="${not empty endDate}">
                <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="endDateObj"/>
            </c:if>

            <section class="card" aria-label="Tóm tắt thống kê">
                <div class="button-row">
                    <a class="btn btn--ghost" href="${backToStatisticsUrl}">Quay lại thống kê</a>
                </div>
                <div class="stat-summary">
                    <div class="stat-chip">
                        <span class="stat-chip__label">Ngày bắt đầu</span>
                        <span class="stat-chip__value">
                            <c:choose>
                                <c:when test="${not empty startDateObj}">
                                    <fmt:formatDate value="${startDateObj}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="stat-chip">
                        <span class="stat-chip__label">Ngày kết thúc</span>
                        <span class="stat-chip__value">
                            <c:choose>
                                <c:when test="${not empty endDateObj}">
                                    <fmt:formatDate value="${endDateObj}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="stat-chip">
                        <span class="stat-chip__label">Tổng giá trị</span>
                        <span class="stat-chip__value"><fmt:formatNumber value="${totalAmount}" type="currency"/></span>
                    </div>
                </div>
            </section>

            <div class="card-grid card-grid--split">
                <section class="card card--narrow" aria-labelledby="customer-heading">
                    <h2 class="card__title" id="customer-heading">Thông tin khách hàng</h2>
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
                </section>

                <c:choose>
                    <c:when test="${not empty transactions}">
                        <section class="card" aria-labelledby="transaction-heading">
                            <div>
                                <h2 class="card__title" id="transaction-heading">Danh sách giao dịch</h2>
                                <p class="card__subtitle">Các giao dịch được sắp xếp theo thời gian gần nhất.</p>
                            </div>
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
                        </section>
                    </c:when>
                    <c:otherwise>
                        <section class="card" aria-live="polite">
                            <h2 class="card__title">Chưa có giao dịch</h2>
                            <p class="card__subtitle">Khách hàng chưa phát sinh giao dịch trong khoảng thời gian này.</p>
                            <div class="empty-state">
                                <p>Khi có giao dịch mới, bảng thống kê sẽ tự động cập nhật.</p>
                            </div>
                        </section>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</main>

<footer class="site-footer">
    <div class="site-footer__inner">
        <small>&copy; 2024 QLST. Chi tiết giao dịch rõ ràng, dễ theo dõi.</small>
        <div class="site-footer__links">
            <a href="${ctx}/statistics/customers">Thống kê</a>
            <a href="${ctx}/login">Đăng nhập</a>
        </div>
    </div>
</footer>
</body>
</html>
