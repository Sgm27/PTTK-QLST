<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>&#272;&#259;ng k&yacute; th&agrave;nh vi&ecirc;n - QLST</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="register"/>
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
            <span class="page-header__eyebrow">QLST Members</span>
            <h1 class="page-header__title">&#272;&#259;ng k&yacute; th&agrave;nh vi&ecirc;n</h1>
            <p class="page-header__subtitle">Thi&#7871;t l&#7853;p t&agrave;i kho&#7843;n m&#7899;i &#273;&#7875; qu&#7843;n l&yacute; si&ecirc;u th&#7883; ho&#7863;c mua s&#7855;m t&#7841;i QLST.</p>
        </header>
        <section class="card card--accent" aria-labelledby="register-title">
            <div class="card__header">
                <div>
                    <span class="badge" aria-hidden="true">T&#7841;o t&agrave;i kho&#7843;n</span>
                    <h2 class="card__title" id="register-title">Th&ocirc;ng tin c&#417; b&#7843;n</h2>
                    <p>Ch&#250;ng t&ocirc;i b&#7843;o m&#7853;t th&ocirc;ng tin c&#7911;a b&#7841;n theo chu&#7849;n SHA-256.</p>
                </div>
            </div>

            <c:if test="${not empty errors}">
                <div class="alert" role="alert">
                    <p class="form-note">Vui l&ograve;ng ki&#7875;m tra l&#7841;i th&ocirc;ng tin:</p>
                    <ul>
                        <c:forEach var="error" items="${errors}">
                            <li>${error}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="form-grid form-grid--two" autocomplete="off">
                <div class="form-group">
                    <label for="username">T&ecirc;n &#273;&#259;ng nh&#7853;p</label>
                    <input type="text" id="username" name="username" value="${formData != null ? formData.username : ''}" required placeholder="VD: nguyenanh">
                </div>
                <div class="form-group">
                    <label for="fullName">H&#7885; v&agrave; t&ecirc;n</label>
                    <input type="text" id="fullName" name="fullName" value="${formData != null ? formData.fullName : ''}" required placeholder="VD: Nguyen Van A">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${formData != null ? formData.email : ''}" required placeholder="email@domain.com">
                </div>
                <div class="form-group">
                    <label for="phone">S&#7889; &#273;i&#7879;n tho&#7841;i</label>
                    <input type="text" id="phone" name="phone" value="${formData != null ? formData.phone : ''}" placeholder="VD: 0901234567">
                </div>
                <div class="form-group">
                    <label for="address">&#272;&#7883;a ch&#7881;</label>
                    <input type="text" id="address" name="address" value="${formData != null ? formData.address : ''}" placeholder="S&#7889; nh&agrave;, ph&#432;&#7901;ng/x&atilde;">
                </div>
                <div class="form-group">
                    <label for="password">M&#7853;t kh&#7849;u</label>
                    <input type="password" id="password" name="password" required placeholder="T&#7891;i thi&#7875;u 8 k&yacute; t&#7921;">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">X&aacute;c nh&#7853;n m&#7853;t kh&#7849;u</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u">
                </div>
                <div class="form-group">
                    <label for="role">Vai tr&ograve;</label>
                    <select id="role" name="role">
                        <option value="CUSTOMER" ${empty param.role or param.role eq 'CUSTOMER' ? 'selected="selected"' : ''}>Kh&aacute;ch h&agrave;ng</option>
                        <option value="MANAGER" ${param.role eq 'MANAGER' ? 'selected="selected"' : ''}>Qu&#7843;n l&yacute;</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn">
                        <span class="btn__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="M12 4.5a3.5 3.5 0 0 1 3.5 3.5v1.25h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-6.5A2.25 2.25 0 0 1 6 9.25h2.25V8a3.5 3.5 0 0 1 3.75-3.5Zm0 1.5A2 2 0 0 0 10 8v1.25h4V8a2 2 0 0 0-2-2Zm0 6.5a2 2 0 1 0 2 2 2 2 0 0 0-2-2Z" fill="currentColor"/>
                            </svg>
                        </span>
                        <span>Ho&agrave;n t&#7845;t &#273;&#259;ng k&yacute;</span>
                    </button>
                    <a class="btn btn--ghost" href="${pageContext.request.contextPath}/login">
                        <span class="btn__icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24" fill="none">
                                <path d="m10.5 8.25-3 3 3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                <path d="M8 11.25h8.75a2 2 0 0 1 2 2v4.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                        <span>Quay l&#7841;i &#273;&#259;ng nh&#7853;p</span>
                    </a>
                </div>
            </form>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="site-footer__content">
        <small>&copy; 2024 QLST. K&#7871;t n&#7889;i kh&aacute;ch h&agrave;ng v&agrave; qu&#7843;n l&yacute;.</small>
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
