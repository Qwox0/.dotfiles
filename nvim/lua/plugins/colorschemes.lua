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

        -- type :highlight to show highlight groups
        vim.colors.update("Normal", { bg = "none" })

        vim.colors.link("NormalFloat", "Pmenu")

        vim.colors.update("SignColumn", { bg = "none", })

        --[[
        hl("ColorColumn", {
            ctermbg = 0,
            bg = "#fb4934",
            --link = "GruvboxRedSign",
        })
        ]]

        vim.colors.update("CursorLineNR", { bg = "None" })

        --hl("LineNr", { fg = "#5eacd3" })

        --hl("netrwDir", { fg = "#5eacd3" })

        -- Fix
        vim.colors.set("CmpItemKindDefault", { fg = "Orange" })
        for _, sev in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
            vim.colors.link("DiagnosticFloating" .. sev, "Diagnostic" .. sev)
        end

        require("qwox.markdown").set_heading_colors() -- this is not called in `ftplugin/markdown.lua` because markdown highlighting might be injected into other file types.

        vim.colors.set("@variable.mutable", { italic = true })

        vim.colors.reapply_all() -- prevent colorscheme from overwriting manually set colors
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
                vim.colors.update("Gruvbox" .. color .. "Sign", { bg = "none" })
            end
            vim.colors.update("GruvboxGrayBold", { link = "GruvboxGray", bold = true })
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

vim.command.set("FixColorscheme", function()
    local scheme = table.find(colorschemes, function(x) return x.name == active_colorscheme end)
    if scheme then scheme.config(scheme) end
end)

return colorschemes
