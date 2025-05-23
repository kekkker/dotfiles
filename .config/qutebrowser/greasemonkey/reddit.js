// ==UserScript==
// @name               Bring Back Old Reddit
// @namespace          https://greasyfork.org/en/users/105361-randomusername404
// @description        Always redirects to old-Reddit, avoiding Reddit's redesign.
// @include            *://www.reddit.com/*
// @exclude            *://www.reddit.com/poll/*
// @version            1.02
// @run-at             document-start
// @author             RandomUsername404
// @grant              GM.getValue
// @grant              GM.setValue
// @icon               https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-76x76.png
// ==/UserScript==

(function () {
    'use strict';

    // Redirect to old-reddit
    if (window.location.href.startsWith("https://www.reddit.com")) {
        window.location.replace("https://old.reddit.com" + window.location.pathname + window.location.search);
    }
})();
