// ==UserScript==
// @name         yt player hide gradient
// @namespace    qwox
// @version      0.1
// @description  hides annoying gradient shown on the bottom half of the youtube video player when the user agent is modified in a specific way.
// @author       Qwox
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @match        https://www.youtube.com/watch?v=*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @sandbox      JavaScript
// ==/UserScript==

function main() {
    alert("running");
}

(function() {
    'use strict';
    window.addEventListener('DOMContentLoaded', main);
})();
