<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Th&#7889;ng k&ecirc; kh&aacute;ch h&agrave;ng - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="reports"/>
<fmt:setLocale value="vi_VN"/>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Trang ch&#7911; QLST">
            <span class="brand__mark">QL</span>
            <span class="brand__text">
                <span class="brand__title">QLST</span>
                <span class="brand__subtitle">Quan ly sieu thi</span>
            </span>
        </a>
        <nav class="site-nav" aria-label="&#272;i&#7873;u h&#432;&#7899;ng ch&iacute;nh">
            <a class="site-nav__link${currentPage eq 'home' ? ' is-active' : ''}" href="${pageContext.request.contextPath}/">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M3.75 10.1 12 3l8.25 7.1v10.15a.75.75 0 0 1-.75.75h-5.25v-6.75h-4.5v6.75H4.5a.75.75 0 0 1-.75-.75z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>Trang ch&#7911;</span>
            </a>
            <a class="site-nav__link${currentPage eq 'login' ? ' is-active' : ''}" href="${pageContext.request.contextPath}/login">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M15 4.5a4.5 4.5 0 1 1 0 9m3 6.75H6a2.25 2.25 0 0 1 0-4.5h1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="m12.75 11.25 3 3-3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>&#272;&#259;ng nh&#7853;p</span>
            </a>
            <a class="site-nav__link${currentPage eq 'register' ? ' is-active' : ''}" href="${pageContext.request.contextPath}/register">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2.5c-3.05 0-5.5 1.82-5.5 4.06V20a.75.75 0 0 0 .75.75h9.5A.75.75 0 0 0 17.5 20v-1.44C17.5 16.32 15.05 14.5 12 14.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>&#272;&#259;ng k&yacute;</span>
            </a>
            <a class="site-nav__link${currentPage eq 'reports' ? ' is-active' : ''}" href="${pageContext.request.contextPath}/reports">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M4.5 19.5h15M6.75 16.5v-6m4.5 6v-9m4.5 9V9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>Th&#7889;ng k&ecirc;</span>
            </a>
        </nav>
    </div>
</header>
<main class="page-content">
    <div class="layout-container page-grid">
        <header class="page-header">
            <span class="page-header__eyebrow">QLST Insight</span>
            <h1 class="page-header__title">Th&#7889;ng k&ecirc; kh&aacute;ch h&agrave;ng</h1>
            <p class="page-header__subtitle">Ph&acirc;n t&iacute;ch doanh thu theo kh&aacute;ch h&agrave;ng, kho&#7843;ng th&#7901;i gian v&agrave; chi ti&#7871;t giao d&#7883;ch.</p>
        </header>

        <section class="card" aria-labelledby="filter-title">
            <div class="card__header">
                <div>
                    <span class="badge" aria-hidden="true">Kho&#7843;ng th&#7901;i gian</span>
                    <h2 class="card__title" id="filter-title">B&#7897; l&#7885;c b&aacute;o c&aacute;o</h2>
                    <p>T&ugrave;y ch&#7889;n th&#7901;i gian &#273;&#7875; xem doanh thu kh&aacute;ch h&agrave;ng.</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert" role="alert">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reports" method="post" class="form-grid form-grid--two">
                <div class="form-group">
                    <label for="startDate">Ng&agrave;y b&#7855;t &#273;&#7847;u</label>
                    <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                </div>
                <div class="form-group">
                    <label for="endDate">Ng&agrave;y k&#7871;t th&uacute;c</label>
                    <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn">
                        <span class="btn__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="m9.75 6.75 3.5-3 3.5 3M13.25 3.75v12.5a4 4 0 0 1-4 4H4.75" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                        <span>T&#7843;i l&#7841;i b&aacute;o c&aacute;o</span>
                    </button>
                </div>
            </form>
        </section>

        <c:if test="${not empty customerRevenue}">
            <c:set var="totalCustomers" value="${fn:length(customerRevenue)}"/>
            <c:set var="topCustomer" value="${customerRevenue[0]}"/>
            <section class="card" aria-labelledby="summary-title">
                <div class="card__header">
                    <div>
                        <span class="badge" aria-hidden="true">T&#7893;ng quan</span>
                        <h2 class="card__title" id="summary-title">Hi&#7879;u su&#7845;t doanh thu</h2>
                    </div>
                </div>
                <div class="stat-pills">
                    <div class="stat-pill">
                        <span class="stat-pill__label">S&#7889; kh&aacute;ch h&agrave;ng</span>
                        <span class="stat-pill__value">${totalCustomers}</span>
                    </div>
                    <div class="stat-pill">
                        <span class="stat-pill__label">Doanh thu cao nh&#7845;t</span>
                        <span class="stat-pill__value">
                            <fmt:formatNumber value="${topCustomer.revenue}" type="currency"/>
                        </span>
                    </div>
                    <div class="stat-pill">
                        <span class="stat-pill__label">Giao d&#7883;ch cao nh&#7845;t</span>
                        <span class="stat-pill__value">${topCustomer.transactionCount}</span>
                    </div>
                </div>
            </section>

            <section class="card" aria-labelledby="report-title">
                <div class="card__header">
                    <div>
                        <span class="badge" aria-hidden="true">Danh s&aacute;ch</span>
                        <h2 class="card__title" id="report-title">B&aacute;o c&aacute;o doanh thu kh&aacute;ch h&agrave;ng</h2>
                        <p>S&#7855;p x&#7871;p gia&#7843;m d&#7847;n theo doanh thu.</p>
                    </div>
                </div>
                <div class="table-shell" aria-live="polite">
                    <div class="table-responsive">
                        <table aria-label="B&aacute;o c&aacute;o doanh thu kh&aacute;ch h&agrave;ng">
                            <thead>
                            <tr>
                                <th scope="col">M&atilde; KH</th>
                                <th scope="col">H&#7885; t&ecirc;n</th>
                                <th scope="col">T&#7893;ng doanh thu</th>
                                <th scope="col">S&#7889; giao d&#7883;ch</th>
                                <th scope="col" class="table-actions">Chi ti&#7871;t</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${customerRevenue}">
                                <tr class="${item.customerId == selectedCustomerId ? 'table-row-selected' : ''}">
                                    <td>${item.customerId}</td>
                                    <td><c:out value="${item.customerName}"/></td>
                                    <td><fmt:formatNumber value="${item.revenue}" type="currency"/></td>
                                    <td>${item.transactionCount}</td>
                                    <td class="table-actions">
                                        <form action="${pageContext.request.contextPath}/reports" method="post" class="inline-form">
                                            <input type="hidden" name="startDate" value="${startDate}">
                                            <input type="hidden" name="endDate" value="${endDate}">
                                            <input type="hidden" name="customerId" value="${item.customerId}">
                                            <button type="submit" class="btn btn--ghost">
                                                <span class="btn__icon" aria-hidden="true">
                                                    <svg viewBox="0 0 24 24" fill="none">
                                                        <path d="m9.75 7.5 4.5 4.5-4.5 4.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                                    </svg>
                                                </span>
                                                <span>Xem</span>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </c:if>

        <c:if test="${empty customerRevenue}">
            <section class="card">
                <div class="empty-state">
                    <p>Kh&ocirc;ng c&oacute; d&#7919; li&#7879;u doanh thu cho kho&#7843;ng th&#7901;i gian &#273;&atilde; ch&#7885;n.</p>
                </div>
            </section>
        </c:if>

        <c:if test="${not empty selectedCustomerId}">
            <section class="card" aria-labelledby="customer-detail-heading">
                <div class="card__header">
                    <div>
                        <span class="badge" aria-hidden="true">Chi ti&#7871;t</span>
                        <h2 class="card__title" id="customer-detail-heading">Giao d&#7883;ch c&#7911;a kh&aacute;ch h&agrave;ng</h2>
                        <div class="breadcrumb" aria-label="&#272;&#432;&#7901;ng d&#7851;n">
                            <a href="${pageContext.request.contextPath}/reports?startDate=${startDate}&amp;endDate=${endDate}">Danh s&aacute;ch</a>
                            <span aria-hidden="true">&#8250;</span>
                            <span>Kh&aacute;ch h&agrave;ng #${selectedCustomerId}</span>
                        </div>
                    </div>
                </div>
                <div class="detail-summary">
                    <div class="detail-summary__row">
                        <span>Kh&aacute;ch h&agrave;ng: <strong><c:out value="${selectedCustomerName}" default="Kh&aacute;ch #${selectedCustomerId}"/></strong></span>
                        <span>T&#7893;ng chi ti&ecirc;u: <strong><fmt:formatNumber value="${selectedCustomerTotal}" type="currency"/></strong></span>
                    </div>
                    <div class="detail-summary__row">
                        <span>Kho&#7843;ng th&#7901;i gian: <strong>${startDate}</strong> &rarr; <strong>${endDate}</strong></span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty selectedCustomerTransactions}">
                        <div class="table-shell" aria-live="polite">
                            <div class="table-responsive">
                                <table aria-label="Danh s&aacute;ch giao d&#7883;ch c&#7911;a kh&aacute;ch h&agrave;ng">
                                    <thead>
                                    <tr>
                                        <th scope="col">M&atilde; GD</th>
                                        <th scope="col">Th&#7901;i gian</th>
                                        <th scope="col">M&ocirc; t&#7843;</th>
                                        <th scope="col">Gi&aacute; tr&#7883;</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="transaction" items="${selectedCustomerTransactions}">
                                        <tr>
                                            <td>${transaction.id}</td>
                                            <td><c:out value="${transaction.transactionDate}"/></td>
                                            <td><c:out value="${transaction.description}" default="-"/></td>
                                            <td><fmt:formatNumber value="${transaction.amount}" type="currency"/></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>Ch&#432;a c&oacute; giao d&#7883;ch trong kho&#7843;ng th&#7901;i gian n&agrave;y.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="form-actions">
                    <a class="btn btn--ghost" href="${pageContext.request.contextPath}/reports?startDate=${startDate}&amp;endDate=${endDate}">
                        <span class="btn__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="m10.5 8.25-3 3 3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M8 11.25h8.75a2 2 0 0 1 2 2v4.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                        <span>Quay l&#7841;i danh s&aacute;ch</span>
                    </a>
                </div>
            </section>
        </c:if>
    </div>
</main>
<footer class="site-footer">
    <div class="site-footer__content">
        <small>&copy; 2024 QLST. Ph&acirc;n t&iacute;ch doanh thu ch&iacute;nh x&aacute;c.</small>
        <div class="site-footer__nav">
            <a href="${pageContext.request.contextPath}/" aria-label="Trang ch&#7911;">Trang ch&#7911;</a>
            <span aria-hidden="true">&#8226;</span>
            <a href="${pageContext.request.contextPath}/login">&#272;&#259;ng nh&#7853;p</a>
        </div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
