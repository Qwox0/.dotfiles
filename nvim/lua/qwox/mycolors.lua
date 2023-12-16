local mycolors = {}

---@type string|table
mycolors.scheme = "gruvbox"

---@param scheme string|table
function mycolors.set_scheme(scheme)
    if type(scheme) == "string" then scheme = { name = scheme } end
    if scheme.name == nil then return end

    vim.cmd.colorscheme(scheme.name)
    if type(scheme.setup) == "function" then scheme.setup() end

    mycolors.scheme = scheme

    local update_hl = require("typed.colors").update_hl
    local set_hl = require("typed.colors").set_hl
    local link_hl = require("typed.colors").link_hl

    -- type :highlight to show highlight groups
    update_hl("Normal", { bg = "none" })

    link_hl("NormalFloat", "Pmenu")

    update_hl("SignColumn", { bg = "none", })

    --[[
    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#fb4934",
        --link = "GruvboxRedSign",
    })
    ]]

    update_hl("CursorLineNR", { bg = "None" })

    --hl("LineNr", { fg = "#5eacd3" })

    --hl("netrwDir", { fg = "#5eacd3" })

    -- Fix
    set_hl("CmpItemKindDefault", { fg = "Orange" })
    link_hl("DiagnosticFloatingError", "DiagnosticError")
    link_hl("DiagnosticFloatingWarn", "DiagnosticWarn")
    link_hl("DiagnosticFloatingInfo", "DiagnosticInfo")
    link_hl("DiagnosticFloatingHint", "DiagnosticHint")
    link_hl("DiagnosticFloatingOk", "DiagnosticOk")
end

return mycolors
