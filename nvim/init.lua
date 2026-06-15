-- type hints
require("better_vim_api")
require("typed.table")
require("typed.string")

-- basics
qwox = require("qwox") ---@diagnostic disable-line: lowercase-global
qwox.numbers.setup()

-- plugins
local lazypath = qwox.paths.lazy
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "plugins" },
}, {
    defaults = {
        lazy = true,
    }
})

vim.keymap.nmap("<leader>ps", function() require("lazy").sync() end, { desc = "[P]ackages [S]ync" })
