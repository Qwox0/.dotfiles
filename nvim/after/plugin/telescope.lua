local ok, telescope = pcall(require, "telescope")
if not ok then print("Warn: telescope is missing!") return end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local nnoremap = require("qwox.keymap").nnoremap
local qwox_util = require("qwox.util")


telescope.setup({
    defaults = {
        --layout_strategy = 'vertical',
        --layout_strategy = 'center',
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

--telescope.load_extension("ui-select")

local find_opts = { hidden = true }
if vim.fn.has('windows') then find_opts = {} end

nnoremap("<leader>ff", function() builtin.find_files(find_opts) end, "search for file")
nnoremap("<leader>fg", function() builtin.live_grep() end, "search for file content")
nnoremap("<leader>fs", function() builtin.grep_string({ search = vim.fn.input("Grep For > ") }) end,
    "search for file with specific string")

nnoremap("<leader>fb", function() builtin.buffers() end, "search for buffer")
nnoremap("<leader>fh", function() builtin.help_tags() end, "search for help")

nnoremap("<leader>co", function()
    local path = qwox_util.paths.configs .. "/nvim"
    vim.api.nvim_command(":cd " .. path)
    builtin.find_files({ prompt_title = "< NeovimRC >", })
end, "goto nvim config path")


-- -- -- Git
