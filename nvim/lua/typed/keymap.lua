local keymap = {}

---@class KeymapOpts
---@field nowait? boolean (default: `false`)
---@field silent? boolean (default: `false`)
---@field script? boolean (default: `false`)
---@field expr? boolean (default: `false`)
---@field unique? boolean (default: `false`)
---@field noremap? boolean (default: `true`) non-recursive mapping |:noremap|
---@field remap? boolean (default: `false`) Make the mapping recursive. Inverses "noremap".
---@field desc? string human-readable description.
---@field callback? fun(): nil Lua function called when the mapping is executed.
---@field replace_keycodes? boolean (default: `true` if "expr" is `true`) When "expr" is true, replace keycodes in the resulting string (see |nvim_replace_termcodes()|). Returning nil from the Lua "callback" is equivalent to returning an empty string.
---@field buffer? number|boolean Creates buffer-local mapping, `0` or `true` for current buffer.

---Adds a new |mapping|.
---
---Examples:
---```lua
--- -- Map to a Lua function:
--- vim.keymap.set('n', 'lhs', function() print("real lua function") end)
--- -- Map to multiple modes:
--- vim.keymap.set({'n', 'v'}, '<leader>lr', vim.lsp.buf.references, { buffer=true })
--- -- Buffer-local mapping:
--- vim.keymap.set('n', '<leader>w', "<cmd>w<cr>", { silent = true, buffer = 5 })
--- -- Expr mapping:
--- vim.keymap.set('i', '<Tab>', function()
---   return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
--- end, { expr = true })
--- -- <Plug> mapping:
--- vim.keymap.set('n', '[%', '<Plug>(MatchitNormalMultiBackward)')
---```
---
---See also:
---  • |nvim_set_keymap()|
---
---@param mode string|string[] Mode short-name, see |nvim_set_keymap()|. Can also be list of modes to create mapping on multiple modes.
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun() Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? KeymapOpts Table of |:map-arguments|.
function keymap.map(mode, lhs, rhs, opts)
    return vim.keymap.set(mode, lhs, rhs, opts)
end

---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun() Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? KeymapOpts Table of |:map-arguments|.
function keymap.nmap(lhs, rhs, opts) return keymap.map("n", lhs, rhs, opts) end

---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun() Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? KeymapOpts Table of |:map-arguments|.
function keymap.imap(lhs, rhs, opts) return keymap.map("i", lhs, rhs, opts) end

---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun() Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? KeymapOpts Table of |:map-arguments|.
function keymap.vmap(lhs, rhs, opts) return keymap.map("v", lhs, rhs, opts) end

---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|fun() Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? KeymapOpts Table of |:map-arguments|.
function keymap.xmap(lhs, rhs, opts) return keymap.map("x", lhs, rhs, opts) end

return keymap
