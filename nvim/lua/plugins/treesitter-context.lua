local function config()
    require("treesitter-context").setup {
        enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true,         -- Throttles plugin updates (may improve performance)
        max_lines = 8,           -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 5, -- Maximum number of lines to show for a single context
        trim_scope = "outer",    -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
        mode = "cursor",         -- Line used to calculate context. Choices: "cursor", "topline"
        show_all_context = false,
        patterns = {
            -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the "default" entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                "function",
                "method",
                "for",
                "while",
                "if",
                "switch",
                "case",
            },
            rust = {
                "loop_expression",
                "impl_item",
            },
            typescript = {
                "class_declaration",
                "abstract_class_declaration",
                "else_clause",
            },
        },
    }
end

return { -- show current context (function) at the top
    "nvim-treesitter/nvim-treesitter-context",
    config = config,
}
