if not require("qwox.util").has_plugins("telescope") then return end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

local qwox_util = require("qwox.util")

require("telescope").setup({
    defaults = {
        --layout_strategy = "vertical",
        --layout_strategy = "center",
        --layout_config = { height = 0.95 },
        --file_ignore_patterns = { "git" }
        file_ignore_patterns = { "^.git/" },
    },
    extensions = {
        --[[
        ["ui-select"] = {
            themes.get_dropdown({

            })
        },
        ]]
    },
    pickers = {
        find_files = {
            hidden = true,
            no_ignore = false, -- true: show ignored files, false: hide ignored files
        }
    }
})

vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    }) -- You can pass additional configuration to telescope to change theme, layout, etc.
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
--vim.keymap.set("n", "<C-p>", builtin.git_files)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fe", function()
    builtin.diagnostics({ severity_limit = 1 })
end, { desc = "[F]ind [E]rrors" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep For > ") })
end)

vim.keymap.set("n", "<leader>co", function()
    local path = qwox_util.paths.configs .. "/nvim"
    vim.api.nvim_command(":cd " .. path)
    builtin.find_files({ prompt_title = "< NeovimRC >", })
end)
