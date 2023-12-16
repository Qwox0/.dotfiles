-- local awful = require("core").awful
local awful = require("awful")

local home = require("vars").home


--awful.spawn(editor_cmd .. " " .. awesome.conffile, { rule = {}, properties = { screen = 1, tag = "conf" } })

local scripts_dir = home .. "/.dotfiles/scripts"

-- these are called in a shell
local scripts = {
    scripts_dir .. "/dualScreen",
    scripts_dir .. "/blueFilter.sh",
    "syncthing serve --no-browser --logfile=default",

    "~/bin/moonlander/wally/wally",

    "compton",
    --"picom",

    "nitrogen --restore",
    --scripts_dir .. "/wallpaper.sh",
}

--- set rules in `rules.lua`
local programs = {
    "firefox",
    "thunderbird",
    "discord",
    "keepassxc",
    "virt-manager",
    "gnome-control-center",
}

local run = function()
    for _, program in ipairs(programs) do
        awful.spawn.single_instance(program)
    end

    for _, script in pairs(scripts) do
        awful.spawn.with_shell(script)
    end
end

return {
    run = run,
}
