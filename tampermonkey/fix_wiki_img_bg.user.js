// ==UserScript==
// @name         Wikipedia + Dark Reader: fix image background
// @namespace    qwox
// @version      1.0.0
// @description  description
// @author       Qwox
// @icon         https://www.google.com/s2/favicons?sz=64&domain=wikipedia.org
// @match        https://*.wikipedia.org/wiki/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/fix_wiki_img_bg.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/fix_wiki_img_bg.user.js
// ==/UserScript==

const scriptName = GM_info.script.name;

const STATE = {
    element: undefined
};
window.STATE = { ...window.STATE, [scriptName]: STATE }; // for `@grant none`
if (typeof unsafeWindow !== "undefined")
    unsafeWindow.STATE = { ...unsafeWindow.STATE, [scriptName]: STATE }; // for `@grant ...`

function main() {
    const el = document.createElement("style");
    el.innerHTML = `
        span.mwe-math-element {
            filter: invert(1) !important;
        }
    `;
    document.head.appendChild(el);
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
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", _main);
    } else {
        _main();
    }
})();
