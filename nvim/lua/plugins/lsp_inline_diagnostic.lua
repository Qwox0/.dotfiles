local function config()
    require("tiny-inline-diagnostic").setup {
        preset = "modern", -- "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
        transparent_bg = false,
        hi = {
            background = "Normal",
        },

        options = {
            -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
            show_source = {
                enabled = false, -- Enable showing source names
                if_many = false, -- Only show source if multiple sources exist for the same diagnostic
            },

            set_arrow_to_diag_color = false,

            add_messages = {
                messages = true,              -- Show full diagnostic messages
                display_count = false,        -- Show diagnostic count instead of messages when cursor not on line
                use_max_severity = true,      -- only show the most severe diagnostic
                show_multiple_glyphs = false, -- Show multiple icons for multiple diagnostics of same severity
            },

            multilines = {
                enabled = true,
                always_show = true,
                severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
            },

            show_all_diags_on_cursorline = true,

            show_related = {
                enabled = false,
                max_count = 3,
            },

            -- Enable diagnostics display in insert mode
            -- May cause visual artifacts; consider setting throttle to 0 if enabled
            enable_on_insert = false,

            overflow = {
                mode = "wrap",
            },

            -- Filter diagnostics by severity levels
            -- Remove severities you don't want to display
            severity = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.HINT,
            },
        },
    }
    require("qwox.diagnostic").setup()
    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
end

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    --event = "VeryLazy",
    --priority = 1000,
    config = config,
}
