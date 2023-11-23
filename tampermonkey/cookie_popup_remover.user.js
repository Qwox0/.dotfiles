// ==UserScript==
// @name         CookiePopupRemover
// @namespace    qwox
// @version      0.2.1
// @description  removes cookie popups
// @author       Qwox
// @icon
// @match        https://askubuntu.com/questions/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/cookie_popup_remover.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/cookie_popup_remover.user.js
// @sandbox      JavaScript
// ==/UserScript==

const PAGES = {
    "askubuntu.com": () => document.querySelector("body > div.js-consent-banner"),
}

function getSite() {
    return new window.URL(window.location.href);
}

function main() {
    const site = getSite();
    console.log("site:", site);
    if (!site) throw new Error("Error with getSite!");
    const hostname = site.hostname;

    const elemGetter = PAGES[hostname];
    console.log("elemGetter:", elemGetter);
    if (!elemGetter) throw new Error(`Please add a getter for "${hostname}"`);

    const element = elemGetter();
    console.log("element:", element);
    if (!element) throw new Error(`Cannot get element.`);

    element.style.display = "none";
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
