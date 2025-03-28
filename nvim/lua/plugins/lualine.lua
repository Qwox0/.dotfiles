local function config()
    local diagnostics = {
        "diagnostics",
        sources = { "nvim_lsp", "nvim_diagnostic" }, -- "nvim_lsp", "nvim_diagnostic", "nvim_workspace_diagnostic", "coc", "ale", "vim_lsp".
        sections = { "error", "warn", "info", "hint" },
        --[[
        diagnostics_color = {
            -- Same values as the general color option can be used here.
            error = "DiagnosticError", -- Changes diagnostics" error color.
            warn  = "DiagnosticWarn",  -- Changes diagnostics" warn color.
            info  = "DiagnosticInfo",  -- Changes diagnostics" info color.
            hint  = "DiagnosticHint",  -- Changes diagnostics" hint color.
        },
        --]]
        --symbols = { error = "E", warn = "W", info = "I", hint = "H" },
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
    }

    local filepath = { "filename", path = 3 }

    require("lualine").setup {
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", diagnostics },
            lualine_c = { filepath },
            lualine_x = { "searchcount", "encoding" },
            lualine_y = { "fileformat", "filetype" },
            lualine_z = { "location" }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { filepath },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
end

return {
    "nvim-lualine/lualine.nvim",
    branch = "fix_hl_inheritence", -- TODO: remove this when <https://github.com/nvim-lualine/lualine.nvim/pull/1315> is merged
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = config,
}
