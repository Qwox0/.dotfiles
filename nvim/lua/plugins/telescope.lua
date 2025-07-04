local function config()
    local qwox_util = require("qwox.util")

    local actions = require("telescope.actions")
    actions.layout = require("telescope.actions.layout")
    actions.state = require("telescope.actions.state")
    local builtin = require("telescope.builtin")
    local pickers = require("telescope.pickers")
    local entry_display = require("telescope.pickers.entry_display")
    local finders = require("telescope.finders")
    local previewers = require("telescope.previewers")
    local themes = require("telescope.themes")
    local strings = require("plenary.strings")

    local create_command = vim.command.set
    local nmap = vim.keymap.nmap
    local vmap = vim.keymap.vmap

    local small_dropdown = themes.get_dropdown {
        layout_config = { height = 0.8, width = 0.7 },
        previewer = false,
    }

    local numbered_ui_select = {
        make_indexed = function(items)
            local indexed_items = {}
            local widths = { idx = 0, title = 0 }
            for idx, item in ipairs(items) do
                local entry = {
                    idx = idx,
                    text = item,
                    title = item:gsub("\r\n", "\\r\\n"):gsub("\n", "\\n"),
                }
                table.insert(indexed_items, entry)
                widths.idx = math.max(widths.idx, strings.strdisplaywidth(entry.idx))
                widths.title = math.max(widths.title, strings.strdisplaywidth(entry.title))
            end
            return indexed_items, widths
        end,
        make_displayer = function(widths)
            return entry_display.create {
                separator = " ",
                items = {
                    { width = widths.idx + 1 }, -- +1 for ":" suffix
                    { width = widths.title },
                },
            }
        end,
        make_display = function(displayer)
            return function(e)
                return displayer {
                    { e.value.idx .. ":", "TelescopePromptPrefix" },
                    { e.value.title },
                }
            end
        end,
        make_ordinal = function(e)
            return e.idx .. e.title
        end,
    }

    local default_strategy = "flex"

    local function send_to_loclist(prompt_bufnr)
        actions.send_to_loclist(prompt_bufnr)
        vim.cmd.lopen()
    end

    require("telescope").setup {
        defaults = { -- Default configuration for telescope
            layout_strategy = default_strategy,
            layout_config = {
                anchor = "CENTER",
                height = 0.9,
                width = 0.8,

                horizontal = {
                    preview_cutoff = 105,
                    preview_width = function(_, tel_cols) -- params: size of telescope window
                        local content_width = tel_cols - 4
                        return math.floor(content_width * 0.5)
                    end,
                },
                vertical = {
                    preview_height = 0.4,
                },
                flex = {
                    flip_columns = 130, -- The number of columns required to move to horizontal mode
                    -- flip_lines = 1, -- The number of lines required to move to horizontal mode
                },
            },
            cycle_layout_list = { "vertical", default_strategy },

            mappings = {
                i = {
                    ["<ESC>"] = actions.close,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-l>"] = actions.layout.cycle_layout_next,
                    ["<C-v>"] = false,
                    ["<C-s>"] = actions.file_vsplit, -- <C-v>
                    ["<C-c>"] = function(prompt_bufnr)
                        local selection = actions.state.get_selected_entry()
                        local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                        actions.close(prompt_bufnr)
                        -- Depending on what you want put `cd`, `lcd`, `tcd`
                        vim.cmd(string.format("silent lcd %s", dir))
                    end,
                    ["<PageUp>"] = send_to_loclist,
                    ["<PageDown>"] = send_to_loclist,
                },
            },
            file_ignore_patterns = { "^.git/" },

            --preview = { treesitter = true, },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--trim"
            },
        },
        pickers = { -- Default configuration for builtin pickers
            find_files = { hidden = true, },
            grep_string = {
                additional_args = { "--hidden" },
            },
            live_grep = {
                additional_args = { "--hidden" },
            },
            planets = { show_moon = true, show_pluto = true },
        },
        extensions = {
            ["ui-select"] = {
                small_dropdown,
                specific_opts = {
                    ["rust-tools/debuggables"] = numbered_ui_select,
                    ["rust-tools/runnables"] = numbered_ui_select,
                    ["qwox/debug-prompt"] = numbered_ui_select,
                },
            },
            undo = {
            },
        },
    }

    nmap("<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    local find_files_with_ignored = function() builtin.find_files { no_ignore = true, no_ignore_parent = true } end
    nmap("<leader>fi", find_files_with_ignored, { desc = "[F]ind files (including [I]gnored)" })
    --nmap("<C-p>", builtin.git_files)
    nmap("<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    nmap("<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
    nmap("<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    nmap("<leader>fo", builtin.oldfiles, { desc = "[F]ind recently [o]pened files" })
    nmap("<leader>fb", builtin.buffers, { desc = "[F]ind existing [b]uffers" })
    nmap("<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    nmap("<leader>fe", function() builtin.diagnostics { severity_limit = 1 } end, { desc = "[F]ind [E]rrors" })

    nmap("<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })

    nmap("<leader>fs", function() builtin.grep_string { search = vim.fn.input("Grep For > ") } end, {
        desc = "[F]ind [S]tring",
    })
    vmap("<leader>f", function() builtin.grep_string { search = qwox_util.get_selection_text() } end, {
        desc = "[F]ind Selection"
    })
    nmap("<leader>/", function() builtin.current_buffer_fuzzy_find(small_dropdown) end, {
        desc = "[/] Fuzzily search in current buffer",
    })
    vmap("<leader>/", function()
        local selection = qwox_util.get_selection_text()
        qwox_util.enter_normal_mode()
        -- vim.cmd(":let @/ = "" .. selection .. """)
        --vim.fn.search(selection)
        --vim.fn.feedkeys("/" .. selection)
        vim.fn.feedkeys("/" .. selection)
        --vim.fn.feedkeys("<CR>", "x")
        -- builtin.current_buffer_fuzzy_find(vim.tbl_deep_extend("force", small_dropdown, {
        --     default_text = selection,
        -- }))
    end, { desc = "[/] Search for selected text in buffer", })
    nmap("<leader>ft", builtin.treesitter, { desc = "[F]ind [T]reesitter items" })

    nmap("<leader>fm", builtin.keymaps, { desc = "[F]ind [M]appings" })

    vim.autocmd.new("WinLeave", {
        callback = function()
            if qwox_util.is_filetype("TelescopePrompt") and vim.fn.mode() == "i" then
                qwox_util.enter_normal_mode()
            end
        end,
    })

    vim.command.set({ "Hi", "Highlights" }, function(_)
        builtin.highlights()
    end, { desc = "Lists all available highlights" })

    ---@diagnostic disable-next-line: different-requires
    require("qwox.telescope").load_extension("ui-select")
end

return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = config,
}
