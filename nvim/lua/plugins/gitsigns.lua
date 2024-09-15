return { -- show git changes is signcolumn
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        require("gitsigns").setup {
            signs                        = {
                add          = { text = "│" },
                change       = { text = "│" },
                delete       = { text = "⬎" },
                topdelete    = { text = "⬏" },
                changedelete = { text = "~" },
                untracked    = { text = "│" }, -- ┆
            },
            signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
            linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir                 = {
                follow_files = true,
            },
            auto_attach                  = true,
            attach_to_untracked          = true,
            current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts      = {
                virt_text = true,
                virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority                = 6,
            update_debounce              = 100,
            status_formatter             = nil,   -- Use default
            max_file_length              = 40000, -- Disable if file is longer than this (in lines)
            preview_config               = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1
            },
        }

        vim.colors.flatten_unlink("GitSignsAdd", "keep")
        vim.colors.update("GitSignsAdd", { fg = "#50fa7b" })
        vim.colors.update("GitSignsChange", { link = "GruvboxYellowSign" })
        vim.colors.update("GitSignsDelete", { link = "GruvboxRedSign" })
        vim.colors.update("GitSignsChangedelete", { link = "GruvboxOrangeSign" })
        vim.colors.update("GitSignsChangedeleteNr", { link = "GitSignsChangedelete" })

        local function get_inline(s)
            return { underdotted = true, sp = vim.colors.get_active("GitSigns" .. s).fg, reverse = false }
        end
        vim.colors.update("GitSignsAddInline", get_inline("Add"))
        vim.colors.update("GitSignsChangeInline", get_inline("Change"))
        vim.colors.update("GitSignsChangedeleteInline", get_inline("Changedelete"))
        vim.colors.update("GitSignsDeleteInline", get_inline("Delete"))
    end,
}
