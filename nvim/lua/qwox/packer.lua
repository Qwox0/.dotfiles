local packer_path = require("qwox.util").paths.packer

local packer_bootstrap = vim.fn.empty(vim.fn.glob(packer_path)) > 0
if packer_bootstrap then
    vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path }
    vim.cmd([[packadd packer.nvim]])
end

local nmap = require("qwox.keymap").nmap
nmap("<leader>ps", require("packer").sync, { desc = "[P]acker [S]ync" })

return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" } -- Packer can manage itself

    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
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
