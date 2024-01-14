-- Rules to apply to new clients (through the "manage" signal).
-- use `xprop` or `xpropclass`
-- -- WM_CLASS = <Instance Name>, <class-rule>
-- -- WM_NAME = <name-rule>

local awful = require("core").awful
local beautiful = require("core").beautiful
local ruled = require("core").ruled

-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id         = "floating",
        rule_any   = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name     = {
                "Event Tester", -- xev.
            },
            role     = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    }

    -- Set Firefox to always map on the tag named "www" on screen 1.
    --[[
    ruled.client.append_rule {
        rule       = { class = "firefox" },
        properties = { screen = 1, tag = "www" }
    }
    ]]

    ruled.client.append_rule {
        rule_any = { class = { "thunderbird-default", "thunderbird" } },
        properties = { screen = 2, tag = "Email" }
    }

    ruled.client.append_rule {
        rule       = { class = "discord" },
        properties = { screen = 2, tag = "Dc" }
    }

    ruled.client.append_rule {
        rule       = { class = "Virt-manager", instance = "virt-manager" },
        properties = { screen = 1, tag = "VM" }
    }

    ruled.client.append_rule {
        rule       = { class = "Gnome-control-center", instance = "gnome-control-center" },
        properties = { screen = 1, tag = "www", minimized = true }
    }

    ruled.client.append_rule {
        rule       = { class = "Wally", instance = "wally" },
        properties = { screen = 2, tag = "8" }
    }

    ruled.client.append_rule {
        rule       = { class = "KeePassXC", instance = "keepassxc" },
        properties = { screen = 1, tag = "key" }
    }
end)



--[[

local set_default_rules = function()
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = {}, -- all
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        },
        -- Floating clients.
        { rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, properties = { floating = true } },

        -- Add titlebars to normal clients and dialogs
        { rule_any = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = true }
        },
    }
end

local append_rule = function(rule)
    if type(awful.rules.rules) ~= "table" then set_default_rules() end
    if type(rule) ~= "table" then return end
    table.insert(awful.rules.rules, rule)
end

return {
    set_default_rules = set_default_rules,
    append_rule = append_rule,
}
 ]]
