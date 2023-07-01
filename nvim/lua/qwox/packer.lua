local packer_path = require("qwox.util").paths.packer

local packer_bootstrap = vim.fn.empty(vim.fn.glob(packer_path)) > 0
if packer_bootstrap then
    vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path }
    vim.cmd([[packadd packer.nvim]])
end

return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" } -- Packer can manage itself

    --use { "nvim-lua/popup.nvim" } -- dependency

    use {
        "nvim-telescope/telescope.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-dap.nvim",
        requires = { "nvim-lua/plenary.nvim" }
    }

    use {
        -- LSP
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",        -- Useful status UI for LSP
        "ray-x/lsp_signature.nvim", -- show block signature
        "onsails/lspkind-nvim",     -- LSP Symbols

        -- Debugger
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",            -- configuaration for nvim-dap
        "theHamsta/nvim-dap-virtual-text", -- show debugger state as virtual text

        -- rust
        "simrat39/rust-tools.nvim",

    }

    -- -- -- CMP
    use { "hrsh7th/nvim-cmp",
        requires = {
            -- completion sources
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-cmdline",
            "rcarriga/cmp-dap",
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

    -- -- -- Harpoon
    use { "theprimeagen/harpoon" }
    use { "ThePrimeagen/vim-be-good" }

    -- Treesitter: Syntax highlighting (see after/plugins/treesitter.lua
    use { "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
    }
    use { "nvim-treesitter/playground" }     -- show treesitter AST (for plugin development)
    use { "romgrk/nvim-treesitter-context" } -- show current context (function) at the top

    use { "norcalli/nvim-colorizer.lua" }    -- highlight color codes

    use { "mbbill/undotree" }

    use { "tpope/vim-fugitive" } -- Git

    use { "tpope/vim-surround" } -- ds": "word" -> word | cs"(: "word" -> ( word )
    --use { "jiangmiao/auto-pairs" }
    use { "windwp/nvim-autopairs" }

    use {
        "nvim-lualine/lualine.nvim",    -- bottom statusline
        "akinsho/bufferline.nvim",      -- show open buffers at the top

        "kyazdani42/nvim-web-devicons", -- needed icons
    }
    --use { "lukas-reineke/indent-blankline.nvim" } -- show indentation

    -- Themes
    use { "folke/tokyonight.nvim" }
    use { "gruvbox-community/gruvbox" }
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "rose-pine/neovim", as = "rose-pine" }

    if packer_bootstrap then require("packer").sync() end
end)
