// ==UserScript==
// @name         template
// @namespace    qwox
// @version      1.0
// @description  description
// @author       Qwox
// @icon
// @match        https://somesite.com/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/template.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/template.user.js
// @sandbox      JavaScript
// ==/UserScript==

function main() {
    throw new Error("not implemented");
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
