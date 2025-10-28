document.addEventListener('DOMContentLoaded', () => {
    document.documentElement.classList.add('js-enabled');

    const currentPath = window.location.pathname.replace(/\/$/, '');
    const highlightLink = (selector, activeClass) => {
        document.querySelectorAll(selector).forEach(link => {
            const href = link.getAttribute('href') || '';
            const linkPath = link.pathname ? link.pathname.replace(/\/$/, '') : href.replace(/\/$/, '');

            if (!href || href.startsWith('#')) {
                return;
            }

            if (link.classList.contains(activeClass)) {
                return;
            }

            if (linkPath && linkPath === currentPath) {
                link.classList.add(activeClass);
            }
        });
    };

    highlightLink('.site-nav a', 'is-active');
});
