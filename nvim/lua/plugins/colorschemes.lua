local default_colorscheme = "gruvbox"
local active_colorscheme = ""

local function colorscheme_config(config)
    config = config or function() end
    return function(lazy_plugin)
        local status_ok, _ = pcall(vim.cmd.colorscheme, lazy_plugin.name)
        if not status_ok then
            vim.notify("colorscheme " .. lazy_plugin.name .. " not found!", "error")
            return
        end

        active_colorscheme = lazy_plugin.name

        config(lazy_plugin)

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
end

local colorschemes = {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        config = colorscheme_config(function()
            vim.g.tokyonight_transparent_sidebar = true
            vim.g.tokyonight_transparent = true
        end),
    },
    {
        "gruvbox-community/gruvbox",
        name = "gruvbox",
        config = colorscheme_config(function()
            vim.g.gruvbox_contrast_dark = "hard"

            for _, color in ipairs({ "Red", "Yellow", "Green", "Orange", "Blue", "Aqua" }) do
                require("typed.colors").update_hl("Gruvbox" .. color .. "Sign", { bg = "none" })
            end
        end),
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = colorscheme_config(),
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = colorscheme_config(function()
            require("rose-pine").setup {
                dark_variant = "moon",
            }
        end),
    },
}

-- load default colorscheme immediately
for _, scheme in ipairs(colorschemes) do
    if scheme.name == default_colorscheme then
        scheme.lazy = false
        scheme.priority = 1000
    end
end

require("typed.command")("FixColorscheme", function()
    local scheme = table.find(colorschemes, function(x) return x.name == active_colorscheme end)
    if scheme then scheme.config(scheme) end
end)

return colorschemes
