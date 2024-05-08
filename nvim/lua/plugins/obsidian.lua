-- <https://github.com/epwalsh/obsidian.nvim>

local qwox_util = require("qwox.util")

local obsidian_dir = qwox_util.paths.obsidian

local function config()
    local autocmd = require("typed.autocmd")
    local nmap = require("typed.keymap").nmap
    local templates_subdir = "templates"

    require("obsidian").setup {
        workspaces = {
            {
                name = "vault",
                path = obsidian_dir,
            }
        },

        completion = {
            nvim_cmp = true,
            min_chars = 1,
        },

        mappings = {
            --- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = require("obsidian").util.gf_passthrough,
                opts = { noremap = false, expr = true, buffer = true },
            },
            ["gd"] = {
                action = require("obsidian").util.gf_passthrough,
                opts = { noremap = false, expr = true, buffer = true },
            },
            -- Toggle check-boxes.
            ["<leader>ch"] = {
                action = require("obsidian").util.toggle_checkbox,
                opts = { buffer = true },
            },
        },

        --- Where to put new notes created from completion. Valid options are
        ---  * "current_dir" - put new notes in same directory as the current buffer.
        ---  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- see <https://github.com/epwalsh/obsidian.nvim/pull/406>
        wiki_link_func = function(opts)
            if opts.id == nil then
                return string.format("[[%s]]", opts.label)
            elseif opts.label ~= opts.id then
                return string.format("[[%s|%s]]", opts.id, opts.label)
            else
                return string.format("[[%s]]", opts.id)
            end
        end,

        templates = {
            subdir = templates_subdir,
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            substitutions = {}
        },

        daily_notes = {
            folder = "",
            alias_format = "",
            template = "templates/daily.md"
        }
    }

    -- line wrap in obsidian
    autocmd("BufEnter", { pattern = obsidian_dir .. "/*.md", command = ":set wrap" })
    autocmd("BufLeave", { pattern = obsidian_dir .. "/*.md", command = ":set nowrap" })
end

local keys = {
    { "<leader>ot", vim.cmd.ObsidianTemplate, desc = "[O]bsidian [T]emplate" },
    {
        "<leader>on",
        function()
            ---@type string
            local input = vim.fn.input("File name > ")
            if input == "" then return end
            local file = input:remove_end(".md") .. ".md"

            vim.cmd.cd(obsidian_dir)
            vim.cmd.edit(file)
            vim.cmd.ObsidianTemplate()
        end,
        desc = "[O]bsidian [N]ew",
    },
    { "<leader>of", vim.cmd.ObsidianSearch,   desc = "[O]bsidian [F]ind" },
    { "<leader>od", vim.cmd.ObsidianToday,    desc = "[O]bsidian open [D]aily" }
}

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
        if not vim.fn.getcwd():starts_with(obsidian_dir) then return end
        vim.cmd.doautocmd("User LoadObsidian")
    end
})

return {
    "epwalsh/obsidian.nvim",
    version = "*",
    event = {
        "BufReadPre " .. obsidian_dir .. "/**.md",
        "BufNewFile " .. obsidian_dir .. "/**.md",
        "User LoadObsidian",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = keys,
    config = config,
}
