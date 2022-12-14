local ok, _ = pcall(require, "nvim-treesitter")
if not ok then print("Warn: nvim-treesitter is missing!") return end

require("nvim-treesitter.configs").setup({
    ensure_installed = {},
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
