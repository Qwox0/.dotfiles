local awful = require("core").awful

local keys = {
    alt   = "Mod1",
    super = "Mod4",
    shift = "Shift",
    ctrl  = "Control",
}
keys.modkey = keys.super

local home = os.getenv("HOME")
local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "nvim"

return {
    home = home,
    conf_path = home .. "/.config/awesome",
    terminal = terminal,
    editor = editor,
    editor_cmd = terminal .. " -e " .. editor,

    keys = keys,

    -- Table of layouts to cover with awful.layout.inc, order matters.
    layout_list = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.max,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    },

    init = function()
        local beautiful = require("core").beautiful
        local gears = require("core").gears

        -- Themes define colours, icons, font and wallpapers.
        beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
    end
}
