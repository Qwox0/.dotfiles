// ==UserScript==
// @name         template
// @namespace    qwox
// @version      0.1.2
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
    alert("running");
}

let hasExecuted = false;

function tmMain() {
    if (hasExecuted) return;
    hasExecuted = true;
    console.log("executing Tampermonkey script...");
    main();
}

(function() {
    'use strict';
    tmMain();
    window.addEventListener('DOMContentLoaded', tmMain);
})();
