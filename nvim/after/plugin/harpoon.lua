if not require("qwox.util").has_plugins("harpoon") then return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local nmap = require("qwox.keymap").nmap

nmap("<leader>a", function() mark.add_file() end, { desc = "[A]dd Harpoon mark" })
nmap("<C-e>", function() ui.toggle_quick_menu() end, { desc = "Open Harpoon [E]dit menu" })

nmap("<C-j>", function() ui.nav_file(1) end, { desc = "to Harpoon 1" })
nmap("<C-k>", function() ui.nav_file(2) end, { desc = "to Harpoon 2" })
nmap("<C-l>", function() ui.nav_file(3) end, { desc = "to Harpoon 3" })
nmap("<C-;>", function() ui.nav_file(4) end, { desc = "to Harpoon 4" })
