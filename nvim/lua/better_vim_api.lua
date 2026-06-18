vim.augroup = {
    new = vim.api.nvim_create_augroup,
    del = vim.api.nvim_del_augroup_by_id,
    del_by_name = vim.api.nvim_del_augroup_by_name,
}
vim.autocmd = {
    new = vim.api.nvim_create_autocmd,
    del = vim.api.nvim_del_autocmd,
    list = vim.api.nvim_get_autocmds,
}
vim.autocmd.create = vim.autocmd.new
vim.autocmd.set = vim.autocmd.new
vim.autocmd.delete = vim.autocmd.del
vim.autocmd.get = vim.autocmd.list

---@class vim.command.SetCallbackOpts
---@field name string Command name
---@field args string The args passed to the command, if any |<args>|
---@field fargs table The args split by unescaped whitespace (when more than one argument is allowed), if any |<f-args>|
---@field nargs string Number of arguments |:command-nargs|
---@field bang boolean "true" if the command was executed with a ! modifier |<bang>|
---@field line1 number The starting line of the command range |<line1>|
---@field line2 number The final line of the command range |<line2>|
---@field range number The number of items in the command range: 0, 1, or 2 |<range>|
---@field count number Any count supplied |<count>|
---@field reg string The optional register, if specified |<reg>|
---@field mods string Command modifiers, if any |<mods>|
---@field smods table Command modifiers in a structured format. Has the same structure as the "mods" key of |nvim_parse_cmd()|.

---Lua callback can return true to delete the autocommand
---@alias vim.command.SetCallback fun(opts: vim.command.SetCallbackOpts): boolean|nil

---@class vim.command.SetOpts: vim.api.keyset.user_command
---@field buffer? integer Buffer handle, or `0` for current buffer. `nil` for global command.
---@field desc? string a string describing the command.
---@field force? boolean (default: `true`) set to `false` Override any previous definition.
---@field preview? fun() |:command-preview|
---@field bang? boolean "true" if the command was executed with a ! modifier |<bang>|
---@field bar? boolean |:command-bar|
---@field complete? string|fun(ArgLead: unknown, CmdLine: string, CursorPos: integer): string[] see |:command-complete| or |:command-completion-customlist|.

vim.command = {
    set_global = vim.api.nvim_create_user_command,
    set_buf = vim.api.nvim_buf_create_user_command,
    ---@param name string|string[] Name of the new user command. Must begin with an uppercase letter.
    ---@param command (string|vim.command.SetCallback) Replacement command to execute when this user command is executed. When called from Lua, the command can also be a Lua function. The function is called with a single table argument that contains the following keys:
    ---@param opts? vim.command.SetOpts See |command-attributes|
    ---@see vim.api.nvim_create_user_command
    ---@see vim.api.nvim_buf_create_user_command
    set = function(name, command, opts)
        opts = opts or {}
        local buffer = opts.buffer
        opts.buffer = nil

        if type(name) == "string" then name = { name } end
        for _, n in ipairs(name) do
            if buffer == nil then
                return vim.api.nvim_create_user_command(n, command, opts)
            else
                return vim.api.nvim_buf_create_user_command(buffer, n, command, opts)
            end
        end
    end
}

---Creates a Normal mode mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.nmap = function(lhs, rhs, opts) return vim.keymap.set("n", lhs, rhs, opts) end
---Creates an Insert mode mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.imap = function(lhs, rhs, opts) return vim.keymap.set("i", lhs, rhs, opts) end
---Creates a Visual mode (Visual + Select) mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.vmap = function(lhs, rhs, opts) return vim.keymap.set("v", lhs, rhs, opts) end
---Creates a Visual mode (only Visual) mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.xmap = function(lhs, rhs, opts) return vim.keymap.set("x", lhs, rhs, opts) end
---Creates a Select mode mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.smap = function(lhs, rhs, opts) return vim.keymap.set("s", lhs, rhs, opts) end
---Creates a Command line mapping
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun(): string? Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts Table of |:map-arguments|.
---@see vim.keymap.set
vim.keymap.cmap = function(lhs, rhs, opts) return vim.keymap.set("c", lhs, rhs, opts) end

local old_del = vim.keymap.del
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.del = function(modes, lhs, opts) pcall(old_del, modes, lhs, opts) end

---@alias vim.ColorValue string|integer color name or "#RRGGBB" or number value

---@class vim.Color: vim.api.keyset.highlight
---@field fg? vim.ColorValue
---@field foreground? vim.ColorValue Alias for `fg`.
---@field bg? vim.ColorValue
---@field background? vim.ColorValue Alias for `bg`.
---@field sp? vim.ColorValue
---@field special? vim.ColorValue Alias for `sp`.
---@field blend? integer between 0 and 100
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string name of another highlight group to link to. When the `link` attribute is defined in the highlight definition map, other attributes will not be taking effect (see |:hi-link|).
---@field default? boolean Don't override existing definition |:hi-default|
---@field ctermfg? unknown Sets foreground of cterm color |ctermfg|
---@field ctermbg? unknown Sets background of cterm color |ctermbg|
---@field cterm? unknown cterm attribute map, like |highlight-args|. If not set, cterm attributes will match those from the attribute map documented above.

vim.colors = {
    ---@type table<string, vim.Color>
    hl_groups = {},

    ---uses `vim.api.nvim_set_hl`. See |nvim_set_hl()|
    ---This removes any existing configurations of the highlight group `name`.
    ---If you want to update the existing configuration, use `update_hl` instead.
    ---
    ---If `color` contains `link`, nvim will ignore all other attributes (see `:h nvim_set_hl`).
    ---To use the other attribute use `unlink_hl(name)`
    ---
    ---@see vim.color.update
    ---@see vim.api.nvim_set_hl
    ---@param name string Highlight group name
    ---@param color vim.Color
    set = function(name, color)
        if color.link and table.count(color) > 1 then
            local linked = vim.colors.get(color.link)
            color = vim.tbl_deep_extend("keep", color, linked)
            color.link = nil
        end
        -- 0: global space (for every window)
        vim.api.nvim_set_hl(0, name, color)
        vim.colors.hl_groups[name] = color
    end,
    ---@param colors table<string, vim.Color>
    ---@see vim.colors.set
    ---@see vim.api.nvim_set_hl
    set_many = function(colors)
        for name, color in pairs(colors) do
            vim.colors.set(name, color)
        end
    end,

    ---@param ... string Highlight group names
    del = function(...)
        for _, name in ipairs({ ... }) do
            vim.colors.set(name, {})
        end
    end,

    ---@param color string Highlight group name
    ---@param flat? boolean (default: false) Don't follow links
    ---@return vim.Color
    get = function(color, flat)
        flat = flat or false
        return vim.api.nvim_get_hl(0, { name = color, link = flat })
    end,

    ---If link is `nil` this does nothing.
    ---If you want to remove the `name` group use `clear_hl(name)` instead.
    ---@see vim.color.sethl
    ---@param name string Highlight group name
    ---@param link? string target group name
    link = function(name, link)
        if link == nil then return end
        vim.colors.set(name, { link = link })
    end,
    ---@param name string Highlight group name
    unlink = function(name)
        local color = vim.colors.get(name, true)
        color.link = nil
        vim.colors.set(name, color)
    end,
    ---@param name string Highlight group name
    ---@param ordering "keep"|"force" whether to keep group data or replace (force) it with the linked data.
    flatten_unlink = function(name, ordering)
        local function get_active(n)
            local color = vim.colors.get(n, true)
            if color.link == nil then return color end
            local linked = get_active(color.link)
            color.link = nil
            return vim.tbl_deep_extend(ordering, color, linked)
        end
        vim.colors.set(name, get_active(name))
    end,

    ---This updates any existing configurations of the highlight group `name`.
    ---If you want to replace any existing configuration, use `set` instead.
    ---@see vim.color.set
    ---
    ---If the `color` table contains the `link` field, the group is linked (and overwritten) first.
    ---
    ---@param name string Highlight group name
    ---@param color vim.Color
    update = function(name, color)
        vim.colors.link(name, color.link)
        color.link = nil

        if table.count(color) == 0 then return end

        if color.reverse ~= nil then
            color.cterm = color.cterm or {}
            if color.cterm.reverse == nil then color.cterm.reverse = color.reverse end
        end

        local old = vim.colors.get(name)
        color.link = old.link
        local new = vim.tbl_deep_extend("force", old, color)
        vim.colors.set(name, new)
    end,

    reapply_all = function() vim.colors.set_many(vim.colors.hl_groups) end,
}

vim.mode = {}

---@return VimMode
function vim.mode.get()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "c" then mode = vim.fn.getcmdtype() end
    for _, type in pairs(vim.mode.modes) do
        if type == mode then return mode end
    end
    error("unknown VimMode " .. vim.inspect(mode))
end

function vim.mode.is_visual() return vim.mode.get() == "v" end

function vim.mode.is_visual_line() return vim.mode.get() == "V" end

function vim.mode.is_visual_block() return vim.mode.get() == vim.mode.modes.visual_block end

function vim.mode.is_visual_any()
    local mode = vim.mode.get()
    for _, v in pairs(vim.mode.modes_visual) do
        if v == mode then return true end
    end
    return false
end

function vim.mode.set_normal() vim.feed_escaped_keys("<C-\\><C-N>") end

---@enum VimMode
vim.mode.modes = {
    --- Normal
    normal = "n",
    --- Operator-pending
    operator_pending = "no",
    --- Operator-pending (forced charwise |o_v|)
    operator_pending_forced_charwise = "nov",
    --- Operator-pending (forced linewise |o_V|)
    operator_pending_forced_linewise = "noV",
    --- Operator-pending (forced blockwise |o_CTRL-V|)
    operator_pending_forced_blockwise = "no\22",
    --- Normal using |i_CTRL-O| in |Insert-mode|
    normal2 = "niI",
    --- Normal using |i_CTRL-O| in |Replace-mode|
    normal3 = "niR",
    --- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
    normal4 = "niV",
    --- Normal in |terminal-emulator| (insert goes to Terminal mode)
    normal_terminal_emulator = "nt",
    --- Normal using |t_CTRL-\_CTRL-O| in |Terminal-mode|
    normal_terminal_emulator2 = "ntT",

    --- Visual by character
    visual = "v",
    --- Visual by character using |v_CTRL-O| in Select mode
    visual_select = "vs",
    --- Visual by line
    visual_line = "V",
    --- Visual by line using |v_CTRL-O| in Select mode
    visual_line_select = "Vs",
    --- Visual blockwise
    visual_block = "\22",
    --- Visual blockwise using |v_CTRL-O| in Select mode
    visual_block_select = "\22s",

    --- Select by character
    select = "s",
    --- Select by line
    select_line = "S",
    --- Select blockwise
    select_block = "\19", -- CTRL-S

    --- Insert
    insert = "i",
    --- Insert mode completion |compl-generic|
    insert_completion = "ic",
    --- Insert mode |i_CTRL-X| completion
    insert_completion2 = "ix",

    --- Replace |R|
    replace = "R",
    --- Replace mode completion |compl-generic|
    replace_completion = "Rc",
    --- Replace mode |i_CTRL-X| completion
    replace_completion2 = "Rx",
    --- Virtual Replace |gR|
    replace_virtual = "Rv",
    --- Virtual Replace mode completion |compl-generic|
    replace_virtual_completion = "Rvc",
    --- Virtual Replace mode |i_CTRL-X| completion
    replace_virtual_completion2 = "Rvx",

    -- --- Command-line editing
    -- cmd = "c",
    --- command-line modes (see `getcmdtype()`)
    cmd = {
        --- normal Ex command
        exec = ":",
        --- debug mode command `debug-mode`
        debug = ">",
        --- forward search command
        search = "/",
        --- backward search command
        backsearch = "?",
        --- `input()` command
        input = "@",
        --- `:insert` or `:append` command
        insert = "-",
        --- `i_CTRL-R_=`
        equal = "=",
    },

    --- Command-line editing overstrike mode |c_<Insert>|
    cmd_overstrike = "cr",
    --- Vim Ex mode |gQ|
    vim_ex = "cv",
    --- Vim Ex mode while in overstrike mode |c_<Insert>|
    vim_ex_overstrike = "cvr",

    --- Hit-enter prompt
    hit_enter_promt = "r",
    --- The -- more -- prompt
    more_prompt = "rm",
    --- A |:confirm| query of some sort
    confirm_query = "r?",
    --- Shell or external command is executing
    shell = "!",
    --- Terminal mode: keys go to the job
    terminal = "t",
}

vim.mode.modes_visual = {
    vim.mode.modes.visual,
    vim.mode.modes.visual_select,
    vim.mode.modes.visual_line,
    vim.mode.modes.visual_line_select,
    vim.mode.modes.visual_block,
    vim.mode.modes.visual_block_select,
}

vim.mode.modes_cmd = {
    vim.mode.modes.cmd.exec,
    vim.mode.modes.cmd.debug,
    vim.mode.modes.cmd.search,
    vim.mode.modes.cmd.backsearch,
    vim.mode.modes.cmd.input,
    vim.mode.modes.cmd.insert,
    vim.mode.modes.cmd.equal,

    vim.mode.modes.cmd_overstrike,
    vim.mode.modes.vim_ex,
    vim.mode.modes.vim_ex_overstrike,
}

vim.mode.modes_search = {
    vim.mode.modes.cmd.search,
    vim.mode.modes.cmd.backsearch,
}

---@see vim.api.nvim_feedkeys
---@see vim.api.nvim_replace_termcodes
---
---@param keys string
function vim.feed_escaped_keys(keys)
    local escaped = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(escaped, "n", true)
end
