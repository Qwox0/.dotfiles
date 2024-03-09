---@class VimMode
---@field type VimModeType
local mode = {}

---@enum VimModeType
local mode_type = {
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
    -- command-line modes (see `getcmdtype()`)

    --- normal Ex command
    cmd_exec = ":",
    --- debug mode command `debug-mode`
    cmd_debug = ">",
    --- forward search command
    cmd_search = "/",
    --- backward search command
    cmd_backsearch = "?",
    --- `input()` command
    cmd_input = "@",
    --- `:insert` or `:append` command
    cmd_insert = "-",
    --- `i_CTRL-R_=`
    cmd_equal = "=",

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

mode_type.vis_modes = {
    mode_type.visual,
    mode_type.visual_select,
    mode_type.visual_line,
    mode_type.visual_line_select,
    mode_type.visual_block,
    mode_type.visual_block_select,
}

mode_type.cmd_modes = {
    mode_type.cmd_exec,
    mode_type.cmd_debug,
    mode_type.cmd_search,
    mode_type.cmd_backsearch,
    mode_type.cmd_input,
    mode_type.cmd_insert,
    mode_type.cmd_equal,

    mode_type.cmd_overstrike,
    mode_type.vim_ex,
    mode_type.vim_ex_overstrike,
}

mode_type.search_modes = {
    mode_type.cmd_search,
    mode_type.cmd_backsearch,
}

---@param char string
---@return boolean
function mode_type.is_valid_char(char)
    for _, type in pairs(mode_type) do
        if type == char then return true end
    end
    return false
end

---@param char string
---@return VimModeType
function mode_type.new(char)
    assert(mode_type.is_valid_char(char), "Invalid VimModeType char")
    return char
end

---Returns the currently active `VimMode`
---@return VimMode
function mode_type.current()
    local basic = vim.api.nvim_get_mode().mode
    if basic == "c" then
        basic = vim.fn.getcmdtype()
    end
    return mode.new(basic)
end

---@param char string
---@return VimMode
function mode.new(char)
    local type = mode_type.new(char)
    return setmetatable({ type = type }, { __index = mode })
end

---Returns whether `self` is any visual mode.
---@return boolean
function mode.is_any_vis(self)
    return table.contains(mode_type.vis_modes, self.type)
end

---Returns whether `self` is any command mode (including search, ...).
---@return boolean
function mode.is_any_cmd(self)
    return table.contains(mode_type.cmd_modes, self.type)
end

---@return boolean
function mode.is_search(self)
    return table.contains(mode_type.search_modes, self.type)
end

return mode_type
