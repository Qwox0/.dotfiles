// ==UserScript==
// @name         template
// @namespace    qwox
// @version      0.1.1
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

(function() {
    'use strict';
    window.addEventListener('DOMContentLoaded', main);
})();
