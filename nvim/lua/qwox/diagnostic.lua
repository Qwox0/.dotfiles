-- [Signs](https://github.com/lucax88x/configs/blob/master/dotfiles/.config/nvim/lua/lt/lsp/init.lua)

--[[      󰝤   󰅚 󰀪 󰌶 ]]

local column_signs = {
    { name = "DiagnosticSignError", text = "󰅚" },
    { name = "DiagnosticSignWarn", text = "󰀪" },
    { name = "DiagnosticSignHint", text = "󰌶" }, --
    { name = "DiagnosticSignInfo", text = "" },
}

--[[
local inlay_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" }, --
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" }, -- 
}
]]

-- setup signs
for _, sign in ipairs(column_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config {
    --[[
    virtual_text = {
        --spacing = 15,
        format = function(diagnostic)
            print()
            return string.format("%s: %s", inlay_signs[diagnostic.severity].text, diagnostic.message)
        end
    },]]
    signs = {
        active = column_signs,
    },
    update_in_insert = true,
    severity_sort = true,
}
