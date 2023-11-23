// ==UserScript==
// @name         yt player hide gradient
// @namespace    qwox
// @version      0.2.2
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
    const elements = document.querySelectorAll("div#container>div.html5-video-player>div.ytp-gradient-bottom");
    for (const el of elements.values()) {
        el.style.display = "none";
    }
}

let hasExecuted = false;

function tmMain() {
    if (hasExecuted) return;
    hasExecuted = true;
    console.log(`executing Tampermonkey script "${GM_info.script.name}" ...`);
    try {
        main();
    } catch (e) {
        const errMsg = `Error in Tampermonkey script "${GM_info.script.name}"`;
        console.error(`${errMsg}:`, e);
        window.alert(`${errMsg}. See console.`);
    }
}

(function() {
    'use strict';
    tmMain();
    window.addEventListener('DOMContentLoaded', tmMain);
})();
