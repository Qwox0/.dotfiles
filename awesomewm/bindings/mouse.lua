local gears = require("gears")
local awful = require("awful")

local mymainmenu = require("menu").mymainmenu

root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    -- scroll to cycle between tags
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
