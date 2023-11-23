// ==UserScript==
// @name         template
// @namespace    qwox
// @version      0.1
// @description  description
// @author       Qwox
// @icon
// @match        https://somesite.com/*
// @grant        none
// @sandbox      JavaScript
// ==/UserScript==

function main() {
    alert("running");
}

(function() {
    'use strict';
    window.addEventListener('DOMContentLoaded', main);
})();
