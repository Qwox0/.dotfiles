-- <https://github.com/epwalsh/obsidian.nvim>

local qwox_util = require("qwox.util")
if not qwox_util.has_plugins("obsidian") then return end

if not qwox_util.is_filetype("markdown") then return end

local autocmd = require("typed.autocmd")
local nmap = require("typed.keymap").nmap

local obsidian_dir = qwox_util.paths.home .. "/obsidian"

local templates_subdir = "templates"

local enabled = qwox_util.file.exists(obsidian_dir .. "/" .. templates_subdir)
if not enabled then return end

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
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Control how wiki links are completed with these (mutually exclusive) options:
        --
        -- 1. Whether to add the note ID during completion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = true,
        -- 2. Whether to add the note path during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
        prepend_note_path = false,
        -- 3. Whether to only use paths during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
        use_path_only = false,
    },

    templates = {
        subdir = templates_subdir,
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {}
    },
}


-- line wrap in obsidian
autocmd("BufEnter", { pattern = obsidian_dir .. "/*.md", command = ":set wrap" })
autocmd("BufLeave", { pattern = obsidian_dir .. "/*.md", command = ":set nowrap" })

nmap("<leader>ot", vim.cmd.ObsidianTemplate, { desc = "[O]bsidian [T]emplate" })
nmap("<leader>on", function()
    ---@type string
    local input = vim.fn.input("File name > ")
    if input == "" then return end
    local file = input:remove_end(".md") .. ".md"

    vim.cmd.cd(obsidian_dir)
    vim.cmd.edit(file)
    vim.cmd.ObsidianTemplate()
end, { desc = "[O]bsidian [N]ew" })
nmap("<leader>of", vim.cmd.ObsidianSearch, { desc = "[O]bsidian [F]ind" })

local default = {
    dir = "~/obsidian",

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "notes",

    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
    log_level = vim.log.levels.DEBUG,

    daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "notes/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
    },

    -- Optional, completion.
    completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Whether to add the output of the node_id_func to new notes in autocompletion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        prepend_note_id = true
    },

    -- Optional, key mappings.
    mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = require("obsidian").util.gf_passthrough(),
        ["gd"] = require("obsidian").util.gf_passthrough(),
    },

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
            end
        end
        return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, alternatively you can customize the frontmatter data.
    note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
            for k, v in pairs(note.metadata) do
                out[k] = v
            end
        end
        return out
    end,

    -- Optional, for templates (see below).
    templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {}
    },

    -- Optional, customize the backlinks interface.
    backlinks = {
        -- The default height of the backlinks pane.
        height = 10,
        -- Whether or not to wrap lines.
        wrap = true,
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    -- Optional, by default commands like `:ObsidianSearch` will attempt to use
    -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
    -- first one they find. By setting this option to your preferred
    -- finder you can attempt it first. Note that if the specified finder
    -- is not installed, or if it the command does not support it, the
    -- remaining finders will be attempted in the original order.
    finder = "telescope.nvim",

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example `:ObsidianQuickSwitch`
    -- will show the notes sorted by latest modified time
    sort_by = "modified",
    sort_reversed = true,

    -- Optional, determines whether to open notes in a horizontal split, a vertical split,
    -- or replacing the current buffer (default)
    -- Accepted values are "current", "hsplit" and "vsplit"
    open_notes_in = "current"
}
