local Colors = {}

Colors.hl_groups = {}

---@alias ColorValue string|integer color name or "#RRGGBB" or number value

---@class Color: vim.api.keyset.highlight
---@field fg? ColorValue
---@field foreground? ColorValue Alias for `fg`.
---@field bg? ColorValue
---@field background? ColorValue Alias for `bg`.
---@field sp? ColorValue
---@field special? ColorValue Alias for `sp`.
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

---@param ... string Highlight group name
---@return Color ...
function Colors.get_hl(...)
    local colors = {}
    for _, name in ipairs({...}) do
        table.insert(colors, vim.api.nvim_get_hl(0, { name = name }))
    end
    return table.unpack(colors)
end

---@param name string Highlight group name
---@return Color
function Colors.get_active_hl(name)
    local color = Colors.get_hl(name)
    if color.link == nil then return color end
    return Colors.get_active_hl(color.link)
end

---If link is `nil` this does nothing.
---If you want to remove the `name` group use `clear_hl(name)` instead.
---@see Color.sethl
---@param name string Highlight group name
---@param link? string target group name
function Colors.link_hl(name, link)
    if link == nil then return end
    Colors.set_hl(name, { link = link })
end

---@param name string Highlight group name
function Colors.unlink_hl(name)
    local color = Colors.get_hl(name)
    color.link = nil
    Colors.set_hl(name, color)
end

---@param name string Highlight group name
---@param ordering "keep"|"force" whether to keep group data or replace (force) it with the linked data.
function Colors.flatten_unlink_hl(name, ordering)
    local function get_active(n)
        local color = Colors.get_hl(n)
        if color.link == nil then return color end
        local linked = get_active(color.link)
        color.link = nil
        return vim.tbl_deep_extend(ordering, color, linked)
    end
    Colors.set_hl(name, get_active(name))
end

---uses `vim.api.nvim_set_hl`. See |nvim_set_hl()|
---This removes any existing configurations of the highlight group `name`.
---If you want to update the existing configuration, use `update_hl` instead.
---
---If `color` contains `link`, nvim will ignore all other attributes (see `:h nvim_set_hl`).
---To use the other attribute use `unlink_hl(name)`
---
---@see Color.update_hl
---@see vim.api.nvim_set_hl
---@param name string Highlight group name
---@param color Color
function Colors.set_hl(name, color)
    -- 0: global space (for every window)
    vim.api.nvim_set_hl(0, name, color)
    Colors.hl_groups[name] = color
end

---@param ... string Highlight group names
function Colors.clear_hl(...)
    for _, name in ipairs({ ... }) do
        Colors.set_hl(name, {})
    end
end

---This updates any existing configurations of the highlight group `name`.
---If you want to replace any existing configuration, use `set_hl` instead.
---@see Color.set_hl
---
---If the `color` table contains the `link` field, the group is linked (and overwritten) first.
---
---@param name string Highlight group name
---@param color Color
function Colors.update_hl(name, color)
    local old = Colors.get_hl(name)
    Colors.set_hl(name, vim.tbl_deep_extend("keep", color, old))

    --[[
    Colors.link_hl(name, color.link)
    color.link = nil

    if table.count(color) == 0 then return end

    local old = Colors.get_active_hl(name)
    color.link = old.link
    print(name, old.link)
    local new = vim.tbl_deep_extend("force", old, color)
    Colors.set_hl(name, new)
]]
end

return Colors
