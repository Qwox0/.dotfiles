-- vim.g    = let (in vimscript)
-- vim.opt  = set (in vimscript)

vim.opt.hidden = true       -- hide vim in bg when closing

vim.opt.number = true           -- show line numbers
vim.opt.relativenumber = true   -- show relative numbers
vim.opt.signcolumn = "yes"      -- have column for symbols

vim.opt.tabstop = 4         -- tab: tab char length
vim.opt.shiftwidth = 4      -- tab: indentation length
vim.opt.expandtab = true    -- tab: convert tabs to spaces
vim.opt.softtabstop = 4     -- tab: convert tabs to spaces
vim.opt.smarttab = true     -- tab:
vim.opt.autoindent = true   -- tab:
vim.opt.smartindent = true  -- tab:

vim.opt.scrolloff = 8       -- scroll before cursor reaches edge

vim.opt.termguicolors = true    -- colors: all 24-bit RGB colors

vim.opt.errorbells = false      -- audio: no bells

-- for listchars: see after/plugin/indent.lua

vim.opt.swapfile = false    -- swap: buffer in memory not swap
vim.opt.updatetime = 50     --
vim.opt.backup = false      -- backup: no backup of edited file
vim.opt.undofile = true     -- backup: store undo buffer in file
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- backup: store undofiles in '~/.vim/undodir'

vim.opt.clipboard = "unnamedplus" -- clipboard: shared with OS (otherwise use '"*y' and '"*p')

vim.opt.hlsearch = false    -- search: doesn't stay highlighted
vim.opt.incsearch = true    -- search:

vim.opt.ignorecase = true   -- search/cmds: ignore case
vim.opt.smartcase = true    -- search/cmds: uppercase -> ignorecase: OFF

vim.opt.cmdheight = 2       -- messages: more space


vim.opt.lazyredraw = true   -- performance: dont redraw on macros etc.

vim.opt.splitright = true   -- split: to right (instead of left) on ':vsplit'
vim.opt.splitbelow = false


-- cmp
vim.opt.completeopt = { "menu", "menuone", "noselect" }
--vim.opt.shortmess:append "c"      -- Don't show the dumb matching stuff.
