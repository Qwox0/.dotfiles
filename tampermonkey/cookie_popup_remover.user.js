// ==UserScript==
// @name         CookiePopupRemover
// @namespace    qwox
// @version      0.2.2
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
