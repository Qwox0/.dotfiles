if not require("qwox.util").has_plugins("harpoon") then return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local nmap = require("qwox.keymap").nmap

nmap("<leader>a", function() mark.add_file() end)
nmap("<C-e>", function() ui.toggle_quick_menu() end)

nmap("<C-j>", function() ui.nav_file(1) end)
nmap("<C-k>", function() ui.nav_file(2) end)
nmap("<C-l>", function() ui.nav_file(3) end)
nmap("<C-;>", function() ui.nav_file(4) end)
