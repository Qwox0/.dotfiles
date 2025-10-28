-- [Signs](https://github.com/lucax88x/configs/blob/master/dotfiles/.config/nvim/lua/lt/lsp/init.lua)

local _ = {}

--[[      󰝤   󰅚 󰀪 󰌶 ]]

--[[
local column_signs = {
    { name = "DiagnosticSignError", text = "󰅚" },
    { name = "DiagnosticSignWarn", text = "󰀪" },
    { name = "DiagnosticSignHint", text = "󰌶" }, --
    { name = "DiagnosticSignInfo", text = "" },
}

local inlay_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" }, --
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" }, -- 
}

-- setup signs
for _, sign in ipairs(column_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
]]

function _.setup()
    vim.diagnostic.config {
        virtual_text = false, -- see `lsp_inline_diagnostic.lua`
        update_in_insert = true,
        severity_sort = true,
    }
end

return _
