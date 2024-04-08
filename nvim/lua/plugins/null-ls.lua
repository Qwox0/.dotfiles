local function config()
    local null_ls = require("null-ls")

    null_ls.setup {
        sources = {
            -- null_ls.builtins.code_actions.gitsigns,

            -- null_ls.builtins.completion.spell,
            null_ls.builtins.completion.tags,

            null_ls.builtins.diagnostics.ansiblelint,

            null_ls.builtins.hover.dictionary,
            null_ls.builtins.hover.printenv,
        },
    }
end


return {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = config,
}
