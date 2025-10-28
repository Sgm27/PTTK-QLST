<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>QLST - Qu&#7843;n l&yacute; si&ecirc;u th&#7883;</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<c:set var="currentPage" value="home"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="${ctx}/" aria-label="Trang ch&#7911; QLST">
            <span class="brand__mark">QL</span>
            <span class="brand__text">
                <span class="brand__title">QLST</span>
                <span class="brand__subtitle">Quan ly sieu thi</span>
            </span>
        </a>
        <nav class="site-nav" aria-label="&#272;i&#7873;u h&#432;&#7899;ng ch&iacute;nh">
            <a class="site-nav__link${currentPage eq 'home' ? ' is-active' : ''}" href="${ctx}/">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M3.75 10.1 12 3l8.25 7.1v10.15a.75.75 0 0 1-.75.75h-5.25v-6.75h-4.5v6.75H4.5a.75.75 0 0 1-.75-.75z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>Trang ch&#7911;</span>
            </a>
            <a class="site-nav__link${currentPage eq 'login' ? ' is-active' : ''}" href="${ctx}/login">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M15 4.5a4.5 4.5 0 1 1 0 9m3 6.75H6a2.25 2.25 0 0 1 0-4.5h1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="m12.75 11.25 3 3-3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>&#272;&#259;ng nh&#7853;p</span>
            </a>
            <a class="site-nav__link${currentPage eq 'register' ? ' is-active' : ''}" href="${ctx}/register">
                <span class="site-nav__icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" fill="none">
                        <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2.5c-3.05 0-5.5 1.82-5.5 4.06V20a.75.75 0 0 0 .75.75h9.5A.75.75 0 0 0 17.5 20v-1.44C17.5 16.32 15.05 14.5 12 14.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>&#272;&#259;ng k&yacute;</span>
            </a>
            <a class="site-nav__link${currentPage eq 'reports' ? ' is-active' : ''}" href="${ctx}/reports">
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
    <div class="layout-container hero-grid">
        <header class="page-header">
            <span class="page-header__eyebrow">QLST Platform</span>
            <h1 class="page-header__title">B&#7843;ng &#273;i&#7873;u khi&#7875;n trung t&acirc;m</h1>
            <p class="page-header__subtitle">Qu&#7843;n l&yacute; si&ecirc;u th&#7883;, kh&aacute;ch h&agrave;ng v&agrave; giao d&#7883;ch trong m&#7897;t n&#417;i v&#7899;i thi&#7871;t k&#7871; hi&#7879;n &#273;&#7841;i, t&#7893;i &#432;u cho c&ocirc;ng vi&#7879;c h&agrave;ng ng&agrave;y.</p>
        </header>
        <section class="hero-card" aria-labelledby="overview-title">
            <h2 class="hero-card__title" id="overview-title">S&#417; l&#432;&#7907;c nhanh</h2>
            <p>QLST cung c&#7845;p c&aacute;c c&ocirc;ng c&#7909; gi&uacute;p nh&oacute;m kinh doanh ra quy&#7871;t &#273;&#7883;nh nhanh ch&oacute;ng, ch&iacute;nh x&aacute;c.</p>
            <div class="stat-pills">
                <div class="stat-pill">
                    <span class="stat-pill__label">Qu&#7843;n l&yacute; kh&aacute;ch h&agrave;ng</span>
                    <span class="stat-pill__value">360&deg;</span>
                </div>
                <div class="stat-pill">
                    <span class="stat-pill__label">D&#7919; li&#7879;u doanh thu</span>
                    <span class="stat-pill__value">Realtime</span>
                </div>
                <div class="stat-pill">
                    <span class="stat-pill__label">B&aacute;o c&aacute;o</span>
                    <span class="stat-pill__value">Bi&#7871;u &#273;&#7891;</span>
                </div>
            </div>
        </section>
        <section aria-label="T&#432;&#417;ng t&aacute;c nhanh">
            <div class="hero-actions">
                <a class="hero-card" href="${ctx}/login">
                    <h3 class="hero-card__title">&#272;&#259;ng nh&#7853;p nhanh</h3>
                    <p>Truy c&#7853;p ngay b&#7843;ng &#273;i&#7873;u khi&#7875;n v&agrave; qu&#7843;n l&yacute; do&#7841;nh thu.</p>
                    <span class="hero-card__meta">
                        <span aria-hidden="true">&#8594;</span>
                        <span>V&agrave;o h&#7879; th&#7889;ng</span>
                    </span>
                </a>
                <a class="hero-card" href="${ctx}/register">
                    <h3 class="hero-card__title">T&#7841;o t&agrave;i kho&#7843;n</h3>
                    <p>Tham gia c&ugrave;ng &#273;&#7897;i ng&#361;, &#273;&#259;ng k&yacute; vai tr&ograve; qu&#7843;n l&yacute; ho&#7863;c kh&aacute;ch h&agrave;ng.</p>
                    <span class="hero-card__meta">
                        <span aria-hidden="true">&#8594;</span>
                        <span>B&#7855;t &#273;&#7847;u ngay</span>
                    </span>
                </a>
                <a class="hero-card" href="${ctx}/reports">
                    <h3 class="hero-card__title">Xem th&#7889;ng k&ecirc;</h3>
                    <p>Ph&acirc;n t&iacute;ch doanh thu v&agrave; giao d&#7883;ch chi ti&#7871;t theo kh&aacute;ch h&agrave;ng.</p>
                    <span class="hero-card__meta">
                        <span aria-hidden="true">&#8594;</span>
                        <span>M&#7903; b&aacute;o c&aacute;o</span>
                    </span>
                </a>
            </div>
        </section>
    </div>
</main>
<footer class="site-footer">
    <div class="site-footer__content">
        <small>&copy; 2024 QLST. Giao di&#7879;n hai t&#244;ng m&agrave;u tinh g&#7885;n.</small>
        <div class="site-footer__nav">
            <a href="${ctx}/login">&#272;&#259;ng nh&#7853;p</a>
            <span aria-hidden="true">&#8226;</span>
            <a href="${ctx}/register">&#272;&#259;ng k&yacute;</a>
        </div>
    </div>
</footer>
<script src="${ctx}/assets/js/app.js"></script>
</body>
</html>
