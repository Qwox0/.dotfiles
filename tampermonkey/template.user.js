// ==UserScript==
// @name         template
// @namespace    qwox
// @version      1.0.3
// @description  description
// @author       Qwox
// @icon
// @match        https://somesite.com/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/template.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/template.user.js
// ==/UserScript==

const scriptName = GM_info.script.name;

const STATE = {
    element: undefined,
};
window.STATE = { ...window.STATE, [scriptName]: STATE }; // for `@grant none`
if (typeof unsafeWindow !== "undefined")
    unsafeWindow.STATE = { ...unsafeWindow.STATE, [scriptName]: STATE }; // for `@grant ...`

function main() {
    throw new Error("not implemented");
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
