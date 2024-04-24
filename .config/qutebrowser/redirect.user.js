// ==UserScript==
// @name Redirect Script
// @namespace https://example.com
// @version 1.0
// @description Redirects URLs by replacing values from config
// @match *://*/*
// @run-at document-start
// @grant none
// ==/UserScript==

(function() {
    'use strict';

    var currentUrl = window.location.href;
    var config = {
//      'from': 'to',
        '^(?:https?://)(?:www.)?youtube.com/watch': 'https://yt.cdaut.de/watch',
    };
    
    for (var oldValue in config) {
        var newValue = config[oldValue];
        var regex = new RegExp(oldValue, 'g');
        currentUrl = currentUrl.replace(regex, newValue);
    }
    
    if (currentUrl !== window.location.href) {
        window.location.href = currentUrl;
    }
})();
