local keys = {
    {
        "<leader>fu",
        function() require("telescope").extensions.undo.undo() end,
        desc = "[F]ind in [U]ndo history"
    }
}

local function config()
    require("qwox.telescope").load_extension("undo")
end

return {
    "debugloop/telescope-undo.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = config,
    keys = keys,
}
