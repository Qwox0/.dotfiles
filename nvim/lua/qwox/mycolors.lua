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

    local hl = require("typed.colors").update_hl

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

return mycolors
