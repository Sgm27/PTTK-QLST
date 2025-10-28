<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>&#272;&#259;ng nh&#7853;p - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="login"/>
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
            <span class="page-header__eyebrow">QLST Access</span>
            <h1 class="page-header__title">&#272;&#259;ng nh&#7853;p h&#7879; th&#7889;ng</h1>
            <p class="page-header__subtitle">Theo d&otilde;i ho&#7841;t &#273;&#7897;ng kinh doanh v&agrave; qu&#7843;n l&yacute; kh&aacute;ch h&agrave;ng b&#7857;ng m&#7897;t giao di&#7879;n tinh g&#7885;n, hi&#7879;n &#273;&#7841;i.</p>
        </header>
        <section class="card" aria-labelledby="login-title">
            <div class="card__header">
                <div>
                    <span class="badge" aria-hidden="true">T&agrave;i kho&#7843;n</span>
                    <h2 class="card__title" id="login-title">&#272;&#259;ng nh&#7853;p</h2>
                    <p>Nh&#7853;p th&ocirc;ng tin t&agrave;i kho&#7843;n &#273;&#7875; truy c&#7853;p b&#7843;ng &#273;i&#7873;u khi&#7875;n QLST.</p>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert" role="status">${message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="form-grid" autocomplete="on">
                <div class="form-group">
                    <label for="username">T&ecirc;n &#273;&#259;ng nh&#7853;p</label>
                    <input type="text" id="username" name="username" value="${empty username ? '' : username}" required autofocus placeholder="Nh&#7853;p t&ecirc;n &#273;&#259;ng nh&#7853;p">
                </div>
                <div class="form-group">
                    <label for="password">M&#7853;t kh&#7849;u</label>
                    <input type="password" id="password" name="password" required placeholder="Nh&#7853;p m&#7853;t kh&#7849;u">
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn">
                        <span class="btn__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 2.75a4.25 4.25 0 0 1 4.25 4.25v1.75h.75a2.25 2.25 0 0 1 2.25 2.25v7.5a2.25 2.25 0 0 1-2.25 2.25H7a2.25 2.25 0 0 1-2.25-2.25V11a2.25 2.25 0 0 1 2.25-2.25h.75V7a4.25 4.25 0 0 1 4.25-4.25Zm0 1.5A2.75 2.75 0 0 0 9.25 7v1.75h5.5V7A2.75 2.75 0 0 0 12 4.25Zm0 7a2 2 0 1 0 2 2 2 2 0 0 0-2-2Z" fill="currentColor"/>
                            </svg>
                        </span>
                        <span>X&aacute;c nh&#7853;n</span>
                    </button>
                </div>
            </form>
            <p class="form-note">Ch&#432;a c&oacute; t&agrave;i kho&#7843;n? <a href="${pageContext.request.contextPath}/register">B&#7855;t &#273;&#7847;u &#273;&#259;ng k&yacute;</a></p>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="site-footer__content">
        <small>&copy; 2024 QLST. T&#7889;i &#432;u ho&aacute; hi&#7879;u n&#259;ng.</small>
        <div class="site-footer__nav">
            <a href="${pageContext.request.contextPath}/" aria-label="Trang ch&#7911;">Trang ch&#7911;</a>
            <span aria-hidden="true">&#8226;</span>
            <a href="${pageContext.request.contextPath}/reports">Th&#7889;ng k&ecirc;</a>
        </div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
