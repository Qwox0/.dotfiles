---@class CommandCallbackOpts
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
---@alias CommandCallback fun(opts: CommandCallbackOpts): boolean|nil

---@class CreateCommandOpts
---@field buffer? integer Buffer handle, or `0` for current buffer. `nil` for global command.
---@field desc? string a string describing the command.
---@field force? boolean (default: `true`) set to `false` Override any previous definition.
---@field preview? fun() |:command-preview|
---@field bang? boolean "true" if the command was executed with a ! modifier |<bang>|
---@field bar? boolean |:command-bar|
---@field complete? string|fun(ArgLead: unknown, CmdLine: string, CursorPos: integer): string[] see |:command-complete| or |:command-completion-customlist|.

local function _create_command(buffer, n, command, opts)
    if buffer == nil then
        return vim.api.nvim_create_user_command(n, command, opts)
    else
        return vim.api.nvim_buf_create_user_command(buffer, n, command, opts)
    end
end

---Like `vim.api.nvim_create_user_command` or `vim.api.nvim_buf_create_user_command`.
---
---Creates a global or buffer-local command |user-commands| based on `opts.buffer`.
--- `nil` -> global
--- `integer` -> buffer-local
---
---For Lua usage see |lua-guide-commands-create|.
---
---Examples:
---```vim
--- :call nvim_create_user_command('SayHello', 'echo "Hello world!"', {'bang': v:true})
--- :SayHello
--- Hello world!
---```
---
---For example:
---```lua
--- vim.api.nvim_create_user_command('Upper', function(opts)
---     print(string.upper(opts.fargs[1]))
--- end, { nargs = 1 })
---
--- vim.cmd.Upper('foo')
--- --> FOO
---```
---
---@param name string|string[] Name of the new user command. Must begin with an uppercase letter.
---@param command (string|CommandCallback) Replacement command to execute when this user command is executed. When called from Lua, the command can also be a Lua function. The function is called with a single table argument that contains the following keys:
---@param opts? CreateCommandOpts See |command-attributes|
---@see vim.api.nvim_create_user_command
---@see vim.api.nvim_buf_create_user_command
local function create_command(name, command, opts)
    opts = opts or {}
    local buffer = opts.buffer
    opts.buffer = nil

    if type(name) == "string" then name = { name } end
    for _, n in ipairs(name) do
        _create_command(buffer, n, command, opts)
    end
end

return create_command
