local toggle_opts = {
    title = " Harpoon ",
    title_pos = "center",
    border = "rounded",
    ui_width_ratio = 1,
    ui_max_width = 80,
    height_in_lines = 13,
}

local function nav_file(idx)
    local harpoon = require("harpoon")
    if harpoon.ui.win_id ~= nil then harpoon.ui:save() end
    harpoon:list():select(idx)
end

local keys = {
    { "<leader>a", function() require("harpoon"):list():add() end, desc = "[A]dd Harpoon mark" },
    {
        "<C-e>",
        function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
            vim.api.nvim_set_option_value("winhl", "NormalFloat:Normal,Title:Normal", { win = harpoon.ui.win_id })
        end,
        desc = "Open Harpoon [E]dit menu"
    },

    { "<C-j>",     function() nav_file(1) end,                     desc = "to Harpoon 1" },
    { "<C-k>",     function() nav_file(2) end,                     desc = "to Harpoon 2" },
    { "<C-l>",     function() nav_file(3) end,                     desc = "to Harpoon 3" },
    -- { "<C-m>", function() require("harpoon.ui").nav_file(4) end,         desc = "to Harpoon 4" }, -- nvim can't differentiate between <C-m> and <Enter>
}


return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = keys,
    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")

        harpoon:setup {
            settings = {
                save_on_toggle = true,
            },
        }
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    end,
}
