---@class AutocmdCallbackOpts
---@field id number autocommand id
---@field event string name of the triggered event |autocmd-events|
---@field group number|nil autocommand group id, if any
---@field match string expanded value of |<amatch>|
---@field buf number expanded value of |<abuf>|
---@field file string expanded value of |<afile>|
---@field data any arbitrary data passed from |nvim_exec_autocmds()|

---Lua callback can return true to delete the autocommand
---@alias AutocmdCallback fun(opts: AutocmdCallbackOpts): boolean|nil

---@class AutocmdOpts
---@field group? string|integer autocommand group name or id to match against.
---@field pattern? string|string[] pattern(s) to match literally |autocmd-pattern|.
---@field buffer? integer buffer number for buffer-local autocommands |autocmd-buflocal|. Cannot be used with {pattern}.
---@field desc? string description (for documentation and troubleshooting).
---@field callback? string|AutocmdCallback Lua function (or Vimscript function name, if string) called when the event(s) is triggered.
---@field command? string Vim command to execute on event. Cannot be used with {callback}
---@field once? boolean defaults to false. Run the autocommand only once |autocmd-once|.
---@field nested? boolean defaults to false. Run nested autocommands |autocmd-nested|.

---Creates an |autocommand| event handler, defined by `callback` (Lua function or Vimscript function name string) or `command` (Ex command string).
---
---Example using Lua callback:
---```lua
--- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
---     pattern = {"*.c", "*.h"},
---     callback = function(ev)
---         print(string.format('event fired: s', vim.inspect(ev)))
---     end
--- })
---```
---
---Example using an Ex command as the handler:
---```lua
--- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
---     pattern = {"*.c", "*.h"},
---     command = "echo 'Entering a C or C++ file'",
--- })
---```
---
---Note: `pattern` is NOT automatically expanded (unlike with |:autocmd|), thus names like
---"$HOME" and "~" must be expanded explicitly:
---```lua
--- pattern = vim.fn.expand("~") .. "/some/path/*.py"
---```
---
---See also:
---  • |autocommand|
---  • |nvim_del_autocmd()|
---
---@param event string | string[] Event(s) that will trigger the handler (`callback` or `command`).
---@param opts AutocmdOpts Options dict
---@return number id Autocommand id
---@see vim.api.nvim_create_autocmd
local function nvim_create_autocmd(event, opts)
    return vim.api.nvim_create_autocmd(event, opts)
end

return nvim_create_autocmd
