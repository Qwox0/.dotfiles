local Colors = {}

Colors.hl_groups = {}

---@class Color

---@param name string Highlight group name
---@return Color
function Colors.get_hl(name)
    local color = vim.api.nvim_get_hl(0, { name = name })

    if color.link ~= nil then return Colors.get_hl(color.link) end

    return color
end

---uses `vim.api.nvim_set_hl`. See |nvim_set_hl()|
---@param name string Highlight group name
---@param color Color
function Colors.set_hl(name, color)
    -- 0: global space (for every window)
    vim.api.nvim_set_hl(0, name, color)
    Colors.hl_groups[name] = color
end

---@param name string Highlight group name
---@param color Color
function Colors.update_hl(name, color)
    local old = Colors.get_hl(name)
    local new = vim.tbl_deep_extend("force", old, color)
    Colors.replace_hl(name, new)
end

---@type string|table
Colors.scheme = "gruvbox"

---@param scheme string|table
function Colors.set_scheme(scheme)
    if type(scheme) == "string" then scheme = { name = scheme } end
    if scheme.name == nil then return end

    vim.cmd.colorscheme(scheme.name)
    if scheme.setup == "function" then scheme.setup() end

    Colors.scheme = scheme

    vim.opt.background = "dark"

    local hl = Colors.update_hl

    -- type :highlight to show highlight groups

    hl("Normal", {
        bg = "none"
    })

    --[[
    hl("NormalFloat", {
        bg = "none"
    })
    ]]
    hl("SignColumn", {
        bg = "none",
    })

    --[[
    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#fb4934",
        --link = "GruvboxRedSign",
    })
    ]]

    hl("CursorLineNR", {
        bg = "None"
    })

    --[[
    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })
    ]]
end

return Colors
