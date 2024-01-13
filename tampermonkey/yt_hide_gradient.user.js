// ==UserScript==
// @name         yt player hide gradient
// @namespace    qwox
// @version      0.3.4
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

const STATE = {};
window.STATE = { ...window.STATE, [scriptName]: STATE }; // for `@grant none`
if (typeof unsafeWindow !== "undefined")
    unsafeWindow.STATE = { ...unsafeWindow.STATE, [scriptName]: STATE }; // for `@grant ...`

const TIMEOUT = 100;

function main() {
    const loop = setInterval(() => {
        const element = document.querySelector("div#container>div.html5-video-player>div.ytp-gradient-bottom");
        if (!element) return;
        element.style.display = "none"
    }, TIMEOUT);
    STATE.yt_hide_gradient_loop = loop;
}

function log(...data) {
    console.log(`Tampermonkey script "${scriptName}":`, ...data);
}

function error(...data) {
    console.error(`Tampermonkey script "${scriptName}":`, ...data);
    window.alert(`Error in Tampermonkey script "${scriptName}". See console.`);
}

(function() {
    'use strict';
    log("executing ...");

    function _main() {
        try {
            main();
        } catch (e) {
            error(e);
        } finally {
            log("finished running main");
            log("STATE:", STATE);
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", _main);
    } else {
        _main();
    }
})();
