local awful = require("core").awful
local awesome = require("core").awesome
local client = require("core").client
local menubar = require("core").menubar
local hotkeys_popup = require("awful.hotkeys_popup")

local terminal = require("vars").terminal
local mod = require("vars").keys.modkey
local main_menu = require("menu").main_menu

local actions = require("bindings.actions").actions
local addkey = require("bindings.actions").addkey

awful.keyboard.append_global_keybindings({
    -- help
    awful.key({ mod }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    -- quit, restart
    awful.key({ mod, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ mod, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    -- run, open
    awful.key({ mod }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ mod }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),
    awful.key({ mod }, "p", function() menubar.show() end, { description = "show the menubar", group = "launcher" }),
    awful.key({ mod }, "x", function()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end, { description = "lua execute prompt", group = "awesome" }),

    -- awful.key({ modkey, }, "w", function() main_menu:show() end, { description = "show main menu", group = "awesome" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    addkey({ mod }, "b", actions.tag.focus.relative(-1)),
    addkey({ mod }, "n", actions.tag.focus.relative(1)),
    addkey({ mod, "Shift" }, "b", actions.client.move_to_tag.relative(-1)),
    addkey({ mod, "Shift" }, "n", actions.client.move_to_tag.relative(1)),
    addkey({ mod }, "Left", actions.tag.focus.relative(-1)),
    addkey({ mod }, "Right", actions.tag.focus.relative(1)),
    -- awful.key({ modkey, }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    addkey({ mod }, "h", actions.client.focus.global_direction("left")),
    addkey({ mod }, "j", actions.client.focus.global_direction("down")),
    addkey({ mod }, "k", actions.client.focus.global_direction("up")),
    addkey({ mod }, "l", actions.client.focus.global_direction("right")),
    addkey({ mod }, "u", actions.client.focus.urgent()),

    --[[
    awful.key({ modkey, }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end, { description = "go back", group = "client" }),
    ]]
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    addkey({ mod, "Shift" }, "h", actions.client.swap.global_direction("left")),
    addkey({ mod, "Shift" }, "j", actions.client.swap.global_direction("down")),
    addkey({ mod, "Shift" }, "k", actions.client.swap.global_direction("up")),
    addkey({ mod, "Shift" }, "l", actions.client.swap.global_direction("right")),
    awful.key({ mod, "Control" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ mod, "Control" }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ mod, "Control" }, "j", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ mod, "Control" }, "k", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ mod, }, "space", function() awful.layout.inc(1) end, { description = "select next", group = "layout" }),
    awful.key({ mod, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { mod },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then tag:view_only() end
        end,
    },
    awful.key {
        modifiers   = { mod, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:move_to_tag(tag) end
            end
        end,
    },
    awful.key {
        modifiers   = { mod, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then awful.tag.viewtoggle(tag) end
        end,
    },
    --[[
    awful.key {
        modifiers   = { mod, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then client.focus:toggle_tag(tag) end
            end
        end,
    },
    awful.key {
        modifiers   = { mod },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function(index)
            local t = awful.screen.focused().selected_tag
            if t then t.layout = t.layouts[index] or t.layout end
        end,
    }
    ]]
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ mod }, "q", function(c) c:kill() end, { description = "close", group = "client" }),
        awful.key({ mod }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "toggle fullscreen", group = "client" }),
        awful.key({ mod }, "m", function(c) c.minimized = true end, { description = "minimize", group = "client" }), -- The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus.
        awful.key({ mod }, "o", function(c) c:move_to_screen() end,
            { description = "move to other screen", group = "client" }),

        -- awful.key({ mod, "Control" }, "space", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
        -- awful.key({ mod }, "t", function(c) c.ontop = not c.ontop end, { description = "toggle keep on top", group = "client" }),
        -- awful.key({ mod }, "m", function(c) c.maximized = not c.maximized c:raise() end, { description = "(un)maximize", group = "client" }),
        -- awful.key({ mod, "Control" }, "m", function(c) c.maximized_vertical = not c.maximized_vertical c:raise() end, { description = "(un)maximize vertically", group = "client" }),
        -- awful.key({ mod, "Shift" }, "m", function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end, { description = "(un)maximize horizontally", group = "client" }),

        -- awful.key({ mod, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end, { description = "move to master", group = "client" }),
    })
end)












--[[

local globalkeys = gears.table.join(
    awful.key({ modkey, }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

    -- -- -- Client

    -- -- -- Tag
    -- }}}


    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    --[[
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
    ]

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    -- awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
    --     { description = "close", group = "client" }),
    awful.key({ modkey }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    --[[
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    ]
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
]]
