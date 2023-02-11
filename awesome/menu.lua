local awesome = require("core").awesome
local awful = require("core").awful
local menubar = require("core").menubar
local beautiful = require("core").beautiful
local hotkeys_popup = require("awful.hotkeys_popup")

local debian = require("debian.menu")
local terminal = require("vars").terminal
local editor_cmd = require("vars").editor_cmd

local awesome_menu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", awesome.quit },
    { "hibernate", function() os.execute("systemctl hibernate") end },
}

local main_menu = awful.menu {
    items = {
        { "awesome", awesome_menu, beautiful.awesome_icon },
        { "Debian", debian.menu.Debian_menu.Debian },
        { "open terminal", terminal },
    }
}

local launcher = awful.widget.launcher {
    image = beautiful.awesome_icon,
    menu = main_menu,
}

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

return {
    main_menu = main_menu,
    launcher = launcher,
}
