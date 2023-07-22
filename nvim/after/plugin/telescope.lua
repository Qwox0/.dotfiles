local qwox_util = require("qwox.util")
if not qwox_util.has_plugins("telescope") then return end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local strings = require("plenary.strings")

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

require("telescope").setup {
    defaults = { -- Default configuration for telescope
        layout_strategy = "flex",
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

        mappings = {
            i = {
                ["<ESC>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        },
        file_ignore_patterns = { "^.git/" },
    },
    pickers = { -- Default configuration for builtin pickers
        find_files = {
            hidden = true,
            no_ignore = false, -- true: show ignored files, false: hide ignored files
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
    },
}

local function nmap(...) vim.keymap.set("n", ...) end

nmap("<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
--nmap("<C-p>", builtin.git_files)
nmap("<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
nmap("<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
nmap("<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
nmap("<leader>fo", builtin.oldfiles, { desc = "[F]ind recently [o]pened files" })
nmap("<leader>fb", builtin.buffers, { desc = "[F]ind existing [b]uffers" })
nmap("<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
nmap("<leader>fe", function() builtin.diagnostics { severity_limit = 1 } end, { desc = "[F]ind [E]rrors" })
nmap("<leader>fs", function() builtin.grep_string { search = vim.fn.input("Grep For > ") } end, {
    desc = "[F]ind [S]tring",
})
nmap("<leader>/", function() builtin.current_buffer_fuzzy_find(small_dropdown) end, {
    desc = "[/] Fuzzily search in current buffer]",
})
nmap("<leader>ft", builtin.treesitter, { desc = "[F]ind [T]reesitter items" })

nmap("<leader>fm", builtin.keymaps, { desc = "[F]ind [M]appings" })

-- extensions

local extensions = { "ui-select", "dap" }
for _, ext in ipairs(extensions) do
    if pcall(require, "telescope._extensions." .. ext) then
        require("telescope").load_extension(ext)
    else
        print("Warn: telescope extension \"" .. ext .. "\" is missing!")
    end
end
