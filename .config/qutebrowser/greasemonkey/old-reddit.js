// ==UserScript==
// @name               Bring Back Old Reddit
// @namespace          https://greasyfork.org/en/users/105361-randomusername404
// @description        Always redirects to old-Reddit, avoiding Reddit's redesign.
// @include            *://old.reddit.com/*
// @version            1.02
// @run-at             document-start
// @author             RandomUsername404
// @grant              none
// @icon               https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-76x76.png
// ==/UserScript==

(function () {
    window.addEventListener("load", hideUnwantedElements, false);

    function hideUnwantedElements() {
        const elementsToHide = [
            '#header',          // Header of the page
            '.side',            // Sidebar
            '.top-matter',      // Top matter (includes title and voting buttons)
            '.footer-container', // Footer
            '.infobar',
            '.infobar.listingsignupbar',
            '.infobar.commentsignupbar.infobar.commentsignupbar',
            '.infobar-toaster-container'
        ];

        elementsToHide.forEach(selector => {
            const element = document.querySelector(selector);
            if (element) {
                element.style.display = 'none';
            }
        });
        const favicon = document.getElementById("favicon");
        favicon.setAttribute("href", "");
    }
})();
