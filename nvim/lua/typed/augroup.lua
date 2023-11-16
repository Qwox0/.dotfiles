---@class AugroupOpts
---@field clear? boolean defaults to true. Clear existing commands if the group already exists |autocmd-groups|.

---Create or get an autocommand group |autocmd-groups|.
---
---To get an existing group id, do:
---```lua
--- local id = vim.api.nvim_create_augroup("MyGroup", {
---     clear = false
--- })
---```
---
---See also:
---  • |autocmd-groups|
---
---@param name string The name of the group
---@param opts AugroupOpts Dictionary Parameters
---@return integer id Integer id of the created group.
---@see vim.api.nvim_create_augroup
local function nvim_create_augroup(name, opts)
    return vim.api.nvim_create_augroup(name, opts)
end

return nvim_create_augroup
