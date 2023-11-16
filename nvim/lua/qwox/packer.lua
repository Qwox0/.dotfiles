local packer_path = require("qwox.util").paths.packer

local packer_bootstrap = vim.fn.empty(vim.fn.glob(packer_path)) > 0
if packer_bootstrap then
    vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path }
    vim.cmd([[packadd packer.nvim]])
end

local nmap = require("typed.keymap").nmap
nmap("<leader>ps", require("packer").sync, { desc = "[P]acker [S]ync" })

---@param use fun(opts: Plugin|(Plugin)[]): nil
return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" } -- Packer can manage itself

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "debugloop/telescope-undo.nvim",
        }
    }

    use { "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-cmdline",
            {
                "saecki/crates.nvim",
                requires = { "nvim-lua/plenary.nvim" },
                config = function() require("crates").setup() end,
            },

            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        }
    }

    use { "neovim/nvim-lspconfig",
        requires = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", tag = "legacy" }, -- Useful status UI for LSP
            "ray-x/lsp_signature.nvim",              -- show block signature
            "onsails/lspkind-nvim",                  -- LSP Symbols
        }
    }

    use { "mfussenegger/nvim-dap",
        requires = {
            "rcarriga/nvim-dap-ui",            -- configuaration for nvim-dap
            "theHamsta/nvim-dap-virtual-text", -- show debugger state as virtual text

            "nvim-telescope/telescope-dap.nvim",
            "rcarriga/cmp-dap",
        }
    }


    -- Treesitter: Syntax highlighting (see after/plugins/treesitter.lua
    use { "nvim-treesitter/nvim-treesitter",
        requires = {
            "nvim-treesitter/playground",    -- show treesitter AST (for plugin development)
            "romgrk/nvim-treesitter-context" -- show current context (function) at the top
        },
        run = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    }

    use("simrat39/rust-tools.nvim")

    use {
        "epwalsh/obsidian.nvim",
        requires = { "nvim-lua/plenary.nvim", },
    }

    use("theprimeagen/harpoon")
    use("tpope/vim-fugitive")          -- Git Ui
    use("lewis6991/gitsigns.nvim")     -- Git: show changes is signcolumn
    use("mbbill/undotree")
    use("windwp/nvim-autopairs")       -- alternative: "jiangmiao/auto-pairs"
    use("tpope/vim-surround")          -- ds": "word" -> word; cs"(: "word" -> ( word )
    use("norcalli/nvim-colorizer.lua") -- highlight color codes

    use { "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons" } }
    use { "akinsho/bufferline.nvim", requires = { "nvim-tree/nvim-web-devicons" } }

    -- Themes
    use { "folke/tokyonight.nvim" }
    use { "gruvbox-community/gruvbox" }
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "rose-pine/neovim", as = "rose-pine" }

    if packer_bootstrap then require("packer").sync() end
end)

---use()		                                       *packer.use()*
---`use` allows you to add one or more plugins to the managed set. It can be
---invoked as follows:
---- With a single plugin location string, e.g. `use <STRING>`
---- With a single plugin specification table, e.g. >lua
---  use {
---    'myusername/example',        -- The plugin location string
---    -- The following keys are all optional
---    -- The following keys all imply lazy-loading
---    cmd = string or list,        -- Specifies commands which load this plugin.  Can be an autocmd pattern.
---    ft = string or list,         -- Specifies filetypes which load this plugin.
---    keys = string or list,       -- Specifies maps which load this plugin. See |packer-plugin-keybindings|
---    event = string or list,      -- Specifies autocommand events which load this plugin.
---    fn = string or list          -- Specifies functions which load this plugin.
---    cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
---    setup = string or function,  -- Specifies code to run before this plugin is loaded. The code is ran even if -- the plugin is waiting for other conditions (ft, cond...) to be met.
---    module = string or list      -- Specifies Lua module names for require. When requiring a string which starts -- with one of these module names, the plugin will be loaded.
---    module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When requiring a string -- which matches one of these patterns, the plugin will be loaded.
---  }
---- With a list of plugins specified in either of the above two forms
---
---For the *cmd* option, the command may be a full command, or an autocommand pattern. If the command contains any
---non-alphanumeric characters, it is assumed to be a pattern, and instead of creating a stub command, it creates
---a CmdUndefined autocmd to load the plugin when a command that matches the pattern is invoked.
---
--- vim:tw=78:ts=2:ft=help:norl:
---@class PluginTable
---@field [1] string
---@field disable? boolean                  Mark a plugin as inactive
---@field as? string                        Specifies an alias under which to install the plugin
---@field installer? function               Specifies custom installer. See |packer-custom-installers|
---@field updater? function                 Specifies custom updater. See |packer-custom-installers|
---@field after? string|string[]            Specifies plugin names to load before this plugin.
---@field rtp? string                       Specifies a subdirectory of the plugin to add to runtimepath.
---@field opt? boolean                      Manually marks a plugin as optional.
---@field bufread? boolean                  Manually specifying if a plugin needs BufRead after being loaded
---@field branch? string                    Specifies a git branch to use
---@field tag? string                       Specifies a git tag to use. Supports '*' for "latest tag"
---@field commit? string                    Specifies a git commit to use
---@field lock? boolean                     Skip updating this plugin in updates/syncs. Still cleans.
---@field run? RunFun|(RunFun)[]            Post-update/install hook. See |packer-plugin-hooks|
---@field requires? string|(Plugin)[]       Specifies plugin dependencies. See |packer-plugin-dependencies|
---@field config? string|fun()              Specifies code to run after this plugin is loaded.
---@field rocks? string|(string|string[])[] Specifies Luarocks dependencies for the plugin

---@alias Plugin string|PluginTable

---`o` includes `PluginTable` and more. See |packer-plugin-hooks|
---@alias RunFun string|fun(o: PluginTable)
