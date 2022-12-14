local awful = require("awful")
local home = require("vars").home

awful.spawn.with_shell(home .. "/scripts/dualScreen.sh")
awful.spawn.with_shell(home .. "/scripts/blueFilter.sh")


awful.spawn.with_shell("syncthing serve --no-browser --logfile=default")
awful.spawn.with_shell("compton")
--awful.spawn.with_shell("picom")
--awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell(home .. "/scripts/wallpaper.sh")

--awful.spawn(editor_cmd .. " " .. awesome.conffile, { rule = {}, properties = { screen = 1, tag = "conf" } })

local autostart = function(program)
    awful.spawn.single_instance(program, awful.rules.rules)
end

autostart("firefox")
autostart("discord")
autostart("thunderbird")
