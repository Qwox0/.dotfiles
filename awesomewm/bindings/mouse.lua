local awful = require("core").awful
local client = require("core").client

local modkey = require("vars").keys.modkey
local main_menu = require("menu").mymainmenu

awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function() main_menu:toggle() end),
    awful.button({}, 4, awful.tag.viewprev), -- scroll to cycle between tags
    awful.button({}, 5, awful.tag.viewnext),
})

---@diagnostic disable-next-line: redundant-parameter
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        awful.button({ modkey }, 3, function(c)
            -- c:activate { context = "mouse_click", action = "mouse_resize"}
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end),
    })
end)
-- client.connect_signal("request::default_mousebindings", function()
--     awful.mouse.append_client_mousebindings({
--         awful.button({}, 1, function(c)
--             c:emit_signal("request::activate", "mouse_click", { raise = true })
--         end),
--         awful.button({ modkey }, 1, function(c)
--             c:emit_signal("request::activate", "mouse_click", { raise = true })
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ modkey }, 3, function(c)
--             c:emit_signal("request::activate", "mouse_click", { raise = true })
--             awful.mouse.client.resize(c)
--         end)
--         --[[
--         awful.button({}, 1, function(c) c:activate { context = "mouse_click" } end),
--         awful.button({ modkey }, 1, function(c) c:activate { context = "mouse_click", action = "mouse_move" } end),
--         awful.button({ modkey }, 3, function(c) c:activate { context = "mouse_click", action = "mouse_resize" } end),
--         --]]
--     })
-- end)
