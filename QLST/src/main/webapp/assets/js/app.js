document.addEventListener('DOMContentLoaded', () => {
    document.documentElement.classList.add('js-enabled');

    const navLinks = document.querySelectorAll('.main-nav a');
    const currentPath = window.location.pathname.replace(/\/$/, '');

    navLinks.forEach(link => {
        const linkPath = link.pathname.replace(/\/$/, '');
        if (linkPath === currentPath || (link.getAttribute('href') === 'index.jsp' && currentPath.endsWith('/'))) {
            link.classList.add('is-active');
        }
    });
});
