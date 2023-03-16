-- access screen objects via `screen` global
local awful = require("core").awful
local wibox = require("core").wibox
local beautiful = require("core").beautiful
local client = require("core").client
local screen = require("core").screen

local modkey = require("vars").keys.modkey
local launcher = require("menu").launcher


screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)

--local kbdcfg = awful.widget.keyboardlayout()
local kbdcfg = {
    cmd = "setxkbmap",
    widget = wibox.widget.textbox(),
    current = 1,
    layouts = {
        { "us", "intl" },
        { "de", "" },
    },
}
function kbdcfg:get() return self.layouts[self.current] end

function kbdcfg:set(idx)
    if type(idx) ~= "number" then return end
    local new = self.layouts[idx]
    if new == nil then return end
    self.current = idx
    local variant = (new[2] == "") and "" or "(" .. new[2] .. ")"
    kbdcfg.widget:set_text(" " .. new[1] .. variant .. " ")
    os.execute(kbdcfg.cmd .. " " .. new[1] .. " " .. new[2])
end

function kbdcfg:set_next() self:set(self.current % #self.layouts + 1) end

-- require("util").debug_msg(kbdcfg:get()[1] .. kbdcfg:get()[2])
kbdcfg:set(1)
kbdcfg.widget:connect_signal("button::press", function() kbdcfg:set_next() end)

local mytextclock = wibox.widget.textclock()

local screens = {
        [1] = {
        tags = { "www", "dev", 3, 4, 5, 6, "key", "VM", "conf" },
    },
        [2] = {
        tags = { "Email", "Dc", 3, 4, 5, 6, 7, 8, 9 },
        layout = awful.layout.suit.tile.bottom,
    },
}

screen.connect_signal("request::desktop_decoration", function(s)
    local tags = screens[s.index].tags or { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local layout = screens[s.index].layout or awful.layout.suit.tile
    awful.tag(tags, s, layout)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then client.focus:move_to_tag(t) end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then client.focus:toggle_tag(t) end
            end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- s.mypromptbox = awful.widget.prompt({
    --     prompt = "$ > ",
    --     with_shell = true,
    -- })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({}, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        }
    }

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar { position = "top", screen = s }
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            kbdcfg.widget,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
















--[[



-- Table of screen tags
-- Each screen has its own tag table.
local screen_tags = {
    default = {
        tags = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        layout = awful.layout.suit.tile,
    },
    [1] = {
        tags = { "www", "dev", 3, 4, 5, 6, "VM", 8, "conf" },
    },
    [2] = {
        tags = { "Email", "Dc", 3, 4, 5, 6, 7, 8, 9 },
        layout = awful.layout.suit.tile.bottom,
    }
}

awful.screen.connect_for_each_screen(function(s)
    local tags = screen_tags[s.index].tags or screen_tags.default.tags
    local layout = screen_tags[s.index].layout or screen_tags.default.layout
    awful.tag(tags, s, layout)
end)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
]]
