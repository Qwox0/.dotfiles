// ==UserScript==
// @name         CookiePopupRemover
// @namespace    qwox
// @version      0.2.3
// @description  removes cookie popups
// @author       Qwox
// @icon
// @match        https://askubuntu.com/questions/*
// @grant        none
// @updateURL    https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/cookie_popup_remover.user.js
// @downloadURL  https://github.com/Qwox0/.dotfiles/raw/main/tampermonkey/cookie_popup_remover.user.js
// @sandbox      JavaScript
// ==/UserScript==

const scriptName = GM_info.script.name;

const PAGES = {
    "askubuntu.com": () => document.querySelector("body > div.js-consent-banner"),
}

const STATE = {
    PAGES: PAGES,
    site: undefined,
    element: undefined,
};
window.STATE = { ...window.STATE, [scriptName]: STATE }; // for `@grant none`
if (typeof unsafeWindow !== "undefined")
    unsafeWindow.STATE = { ...unsafeWindow.STATE, [scriptName]: STATE }; // for `@grant ...`

function getSite() {
    return new window.URL(window.location.href);
}

function main() {
    STATE.site = getSite();
    log("site:", STATE.site);
    if (!STATE.site) throw new Error("Error with getSite!");
    const hostname = STATE.site.hostname;

    const elemGetter = PAGES[hostname];
    log("elemGetter:", elemGetter);
    if (!elemGetter) throw new Error(`Please add a getter for "${hostname}"`);

    STATE.element = elemGetter();
    log("element:", STATE.element);
    if (!STATE.element) throw new Error(`Cannot get element.`);

    STATE.element.style.display = "none";
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
