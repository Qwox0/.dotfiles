local ok, telescope = pcall(require, "telescope")
if not ok then
    print("Warn: telescope is missing!");
    return
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local qwox_util = require("qwox.util")

telescope.setup({
    defaults = {
        --layout_strategy = "vertical",
        --layout_strategy = "center",
        --layout_config = { height = 0.95 },
        --file_ignore_patterns = { "git" }
        --file_ignore_patterns = { "^.git$" }
    },
    extensions = {
        --[[
        ["ui-select"] = {
            themes.get_dropdown({

            })
        },
        ]]
    },
})

local map = function(mode, keys, func, desc)
    local props = { hidden = true }
    vim.keymap.set(mode, keys, function() func(props) end, { desc = desc })
end

map("n", "<leader>fo", require("telescope.builtin").oldfiles, "[?] Find recently opened files")
map("n", "<leader>fb", require("telescope.builtin").buffers, "[ ] Find existing buffers")
map("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    }) -- You can pass additional configuration to telescope to change theme, layout, etc.
end, "[/] Fuzzily search in current buffer]")

map("n", "<leader>ff", builtin.find_files, "[F]ind [F]iles")
--map("n", "<C-p>", builtin.git_files)
map("n", "<leader>fh", builtin.help_tags, "[F]ind [H]elp")
map("n", "<leader>fw", builtin.grep_string, "[F]ind current [W]ord")
map("n", "<leader>fg", builtin.live_grep, "[F]ind by [G]rep")
map("n", "<leader>fd", builtin.diagnostics, "[F]ind [D]iagnostics")
map("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep For > ") })
end)

map("n", "<leader>co", function()
    local path = qwox_util.paths.configs .. "/nvim"
    vim.api.nvim_command(":cd " .. path)
    builtin.find_files({ prompt_title = "< NeovimRC >", })
end)
