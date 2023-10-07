local Colors = {}

Colors.hl_groups = {}

---@class Color
---@field fg? string color name or "#RRGGBB", see note.
---@field foreground? string Same as `fg`.
---@field bg? string color name or "#RRGGBB", see note.
---@field background? string Same as `bg`.
---@field sp? string color name or "#RRGGBB"
---@field special? string Same as `sp`.
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

---@param name string Highlight group name
---@return Color
function Colors.get_hl(name)
    ---@type Color
    local color = vim.api.nvim_get_hl(0, { name = name })

    if color.link == nil then return color end

    return Colors.get_hl(color.link)
end

---If link is `nil` this does nothing.
---If you want to remove the `name` group use `set_hl(name, nil)` instead.
---@see Color.sethl
---@param name string Highlight group name
---@param link? string target group name
function Colors.link_hl(name, link)
    if link == nil then return end
    Colors.set_hl(name, { link = link })
end

---uses `vim.api.nvim_set_hl`. See |nvim_set_hl()|
---This removes any existing configurations of the highlight group `name`.
---If you want to update the existing configuration, use `update_hl` instead.
---@see Color.update_hl
---@param name string Highlight group name
---@param color Color
function Colors.set_hl(name, color)
    -- 0: global space (for every window)
    vim.api.nvim_set_hl(0, name, color)
    Colors.hl_groups[name] = color
end

---This removes any existing configurations of the highlight group `name`.
---If you want to replace any existing configuration, use `set_hl` instead.
---@see Color.set_hl
---
---If the `color` table contains the `link` field, the group is linked (and overwritten) first.
---
---@param name string Highlight group name
---@param color Color
function Colors.update_hl(name, color)
    Colors.link_hl(name, color.link)
    color.link = nil

    if table.count(color) == 0 then return end

    local old = Colors.get_hl(name)
    local new = vim.tbl_deep_extend("force", old, color)
    Colors.set_hl(name, new)
end

---@type string|table
Colors.scheme = "gruvbox"

---@param scheme string|table
function Colors.set_scheme(scheme)
    if type(scheme) == "string" then scheme = { name = scheme } end
    if scheme.name == nil then return end

    vim.cmd.colorscheme(scheme.name)
    if type(scheme.setup) == "function" then scheme.setup() end

    Colors.scheme = scheme

    local hl = Colors.update_hl

    -- type :highlight to show highlight groups
    hl("Normal", { bg = "none" })
    --hl("NormalFloat", { bg = "none" })

    hl("SignColumn", { bg = "none", })

    --[[
    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#fb4934",
        --link = "GruvboxRedSign",
    })
    ]]

    hl("CursorLineNR", { bg = "None" })

    --hl("LineNr", { fg = "#5eacd3" })

    --hl("netrwDir", { fg = "#5eacd3" })
end

return Colors
