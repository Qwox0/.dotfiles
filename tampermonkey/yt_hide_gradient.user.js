// ==UserScript==
// @name         yt player hide gradient
// @namespace    qwox
// @version      0.2.5
// @description  hides annoying gradient shown on the bottom half of the youtube video player when the user agent is modified in a specific way.
// @author       Qwox
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @match        https://www.youtube.com/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @sandbox      JavaScript
// ==/UserScript==

const scriptName = GM_info.script.name;

const ITERATIONS = 1000;
const ITER_TIMEOUT = 50;

function log(...data) {
    console.log(`Tampermonkey script "${scriptName}":`, ...data);
}

function error(...data) {
    console.error(`Tampermonkey script "${scriptName}":`, ...data);
    window.alert(`Error in Tampermonkey script "${scriptName}". See console.`);
}

function main() {
    let i = 0;
    const loop = setInterval(() => {
        if (++i > ITERATIONS) {
            error("couldn't find video-player element.");
            clearInterval(loop);
            return;
        }
        const elements = document.querySelectorAll("div#container>div.html5-video-player>div.ytp-gradient-bottom");
        if (elements.length === 0) return;
        for (const el of elements.values()) {
            log("hide element", el);
            el.style.display = "none";
        }
    }, ITER_TIMEOUT);
}

(function() {
    'use strict';
    log("executing ...");
    main();
})();
