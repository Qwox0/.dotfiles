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

function log(...data) {
    console.log(`Tampermonkey script "${scriptName}":`, ...data);
}

function error(...data) {
    console.error(`Tampermonkey script "${scriptName}":`, ...data);
    window.alert(`Error in Tampermonkey script "${scriptName}". See console.`);
}

/**
 * @param {(stop: () => void) => void} run
 * @param {() => void} after
 * @param {number} [iterations=1000]
 * @param {number} [timeout=50]
 */
function repeat(run, after, iterations = 1000, timeout = 50) {
    const loop = setInterval(() => run(stop), timeout);
    const loop_timeout = setTimeout(() => {
        stop();
        after();
    }, iterations * timeout);
    const stop = () => {
        clearInterval(loop);
        clearTimeout(loop_timeout);
    }
}

/** @param {NodeListOf<Element>} elements */
function hideElements(elements) {
    elements.forEach(el => log("hide element", el));
    repeat(
        () => elements.forEach(el => el.style.display = "none"),
        () => log("finished hideElements loop")
    );
}

function main() {
    repeat(
        stop => {
            const elements = document.querySelectorAll("div#container>div.html5-video-player>div.ytp-gradient-bottom");
            if (elements.length === 0) return;
            hideElements(elements);
            stop();
        },
        () => error("couldn't find video-player element."),
    );
}

(function() {
    'use strict';
    log("executing ...");
    main();
})();
