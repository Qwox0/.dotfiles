local awful = require("core").awful
local screen = require("core").screen

local home = require("vars").home


--awful.spawn(editor_cmd .. " " .. awesome.conffile, { rule = {}, properties = { screen = 1, tag = "conf" } })

local scripts_dir = home .. "/.dotfiles/scripts"

-- these are called in a shell
local scripts = {
    scripts_dir .. "/dualScreen",
    scripts_dir .. "/blueFilter.sh",
    "syncthing serve --no-browser --logfile=default",

    "compton",
    --"picom",

    "nitrogen --restore",
    --scripts_dir .. "/wallpaper.sh",
}

-- rules[program name] = rule
local programs = {
    thunderbird = {
        rule_any = { class = { "thunderbird-default", "thunderbird" } },
        properties = {
            screen = screen[2],
            tag = "Email",
        }
    },
    discord = {
        rule_any = { class = "discord" },
        properties = {
            screen = screen[2],
            tag = "Dc",
        },
    },
}

local run = function()
    for program, rule in pairs(programs) do
        --require("rules").append_rule(rule)
        if type(rule) ~= "table" then
            require("util").debug_msg("not table: " .. rule)
        end
        awful.spawn.once(program)
    end

    for _, script in pairs(scripts) do
        awful.spawn.with_shell(script)
    end

    --awful.spawn.single_instance("thunderbird")
end


--[[
    { rule = { instance = "Navigator", class = "firefox" },
        properties = { screen = 1, tag = "www" }
    },
    { rule = { instance = "virt-manager", class = "Virt-manager" },
        properties = { screen = 1, tag = "VM"}

    }

]]

return {
    run = run,
}
