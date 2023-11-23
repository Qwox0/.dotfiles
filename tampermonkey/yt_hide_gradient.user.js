// ==UserScript==
// @name         yt player hide gradient
// @namespace    qwox
// @version      0.2.3
// @description  hides annoying gradient shown on the bottom half of the youtube video player when the user agent is modified in a specific way.
// @author       Qwox
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @match        https://www.youtube.com/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/yt_hide_gradient.user.js
// @sandbox      JavaScript
// ==/UserScript==

const MAX_ITERATIONS = 1000;
const ITER_TIMEOUT = 30;

/** @param {NodeListOf<Element>} elements */
function hideElements(elements) {
    for (const el of elements.values()) {
        el.style.display = "none";
    }
}

function main() {
    let i = 0;
    const loop = setInterval(() => {
        if (++i >= MAX_ITERATIONS) {
            clearInterval(loop);
            throw new Error(`couldn't find video-player element.`);
        }

        const elements = document.querySelectorAll("div#container>div.html5-video-player>div.ytp-gradient-bottom");
        if (elements.length === 0) return;
        hideElements(elements);
        clearInterval(loop);
    }, ITER_TIMEOUT);
}

(function() {
    'use strict';
    console.log(`executing Tampermonkey script "${GM_info.script.name}" ...`);
    try {
        main();
    } catch (e) {
        const errMsg = `Error in Tampermonkey script "${GM_info.script.name}"`;
        console.error(`${errMsg}:`, e);
        window.alert(`${errMsg}. See console.`);
    }
})();
