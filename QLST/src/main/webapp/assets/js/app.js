document.addEventListener('DOMContentLoaded', () => {
    document.documentElement.classList.add('js-enabled');

    const currentPath = window.location.pathname.replace(/\/$/, '');
    const highlightLink = (selector, activeClass) => {
        document.querySelectorAll(selector).forEach(link => {
            const href = link.getAttribute('href') || '';
            if (!href || href.startsWith('#')) {
                return;
            }

            const linkPath = link.pathname ? link.pathname.replace(/\/$/, '') : href.replace(/\/$/, '');
            if (!linkPath) {
                return;
            }

            const activeRoot = link.dataset.activeRoot
                ? link.dataset.activeRoot.replace(/\/$/, '')
                : linkPath;
            const matchesCurrent = currentPath === linkPath || currentPath.startsWith(activeRoot + '/');
            if (matchesCurrent) {
                link.classList.add(activeClass);
            }
        });
    };

    highlightLink('.site-nav a', 'is-active');
});
