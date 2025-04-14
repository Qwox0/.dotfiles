local keys = {
    {
        "<leader>a",
        function() require("harpoon.mark").add_file() end,
        desc = "[A]dd Harpoon mark"
    },
    { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Open Harpoon [E]dit menu" },

    { "<C-j>", function() require("harpoon.ui").nav_file(1) end,         desc = "to Harpoon 1" },
    { "<C-k>", function() require("harpoon.ui").nav_file(2) end,         desc = "to Harpoon 2" },
    { "<C-l>", function() require("harpoon.ui").nav_file(3) end,         desc = "to Harpoon 3" },
    -- { "<C-m>", function() require("harpoon.ui").nav_file(4) end,         desc = "to Harpoon 4" }, -- nvim can't differentiate between <C-m> and <Enter>
}

return {
    "theprimeagen/harpoon",
    keys = keys,
    opts = {
        menu = {
            width = 80,
            height = 13,
        }
    },
}
