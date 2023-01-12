local awful = require("core").awful
local client = require("core").client

local modkey = require("vars").keys.modkey
local main_menu = require("menu").mymainmenu

awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() main_menu:toggle() end),
    -- scroll to cycle between tags
    awful.button({}, 4, awful.tag.viewprev),
    awful.button({}, 5, awful.tag.viewnext),
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)
