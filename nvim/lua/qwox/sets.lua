local language = "en_US.UTF-8"
if not pcall(vim.cmd.language, language) then
    vim.notify("Warn: Cannot set language. Try uncommenting \"" .. language .. "\" in `/etc/locale.gen` and executing `sudo locale-gen`.", vim.log.levels.WARN)
end

vim.opt.hidden = true         -- hide vim in bg when closing

vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- show relative numbers
vim.opt.signcolumn = "yes"    -- have column for symbols
vim.opt.colorcolumn = "100"

vim.opt.tabstop = 4          -- tab: tab char length
vim.opt.shiftwidth = 4       -- tab: indentation length
vim.opt.expandtab = true     -- tab: convert tabs to spaces
vim.opt.softtabstop = 4      -- tab: convert tabs to spaces
vim.opt.smarttab = true      -- tab:
vim.opt.autoindent = true    -- tab:
vim.opt.smartindent = true   -- tab:

vim.opt.scrolloff = 8        -- scroll before cursor reaches edge

vim.opt.wrap = false
vim.opt.showbreak = "⤷"                  -- wrap character (alternative: ↳)
vim.opt.breakindent = true               -- set indent wrapped lines
vim.opt.breakindentopt:append("sbr")     -- show 'showbreak' at start of wrapped line
vim.opt.breakindentopt:append("shift:1") -- indent wrapped lines more (sadly also affects "list:-1")
vim.opt.breakindentopt:append("list:-1") -- smartwrap numbered lists
local default_formatlistpat = "^\\s*\\d\\+[\\]:.)}\\t ]\\s*"
vim.opt.formatlistpat = "\\("..default_formatlistpat.."\\|^\\s*\\*\\s*\\)\\ze " -- fixes the problem that "shift:1" affects "list:-1" and smartwraps bulleted lists

vim.opt.termguicolors = true -- colors: all 24-bit RGB colors

vim.opt.errorbells = false   -- audio: no bells

vim.opt.list = true
vim.opt.listchars:append("eol:⤵") -- ↴
vim.opt.listchars:append("tab:-->")
vim.opt.listchars:append("space: ")
vim.opt.listchars:append("multispace:⋅")
vim.opt.listchars:append("leadmultispace:⋅⋅⋅│")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("extends:…")
vim.opt.listchars:append("precedes:…")
vim.opt.listchars:append("nbsp:+")        -- Character to show for a non-breakable space character (0xA0 (160 decimal) and U+202F).

vim.opt.swapfile = false                  -- swap: buffer in memory not swap
vim.opt.updatetime = 50                   --
vim.opt.backup = false                    -- backup: no backup of edited file
vim.opt.undofile = true                   -- backup: store undo buffer in file
local home = require("qwox.util").paths.home
vim.opt.undodir = home .. "/.vim/undodir" -- backup: store undofiles in "~/.vim/undodir"

vim.opt.clipboard = "unnamedplus"         -- clipboard: shared with OS (otherwise use '"*y' and '"*p')

vim.opt.incsearch = true                  -- search: highlight next match while typing
-- see <./hlsearch.lua>

vim.opt.shortmess:append("S")             -- disable normal search count

vim.opt.ignorecase = true                 -- search/cmds: ignore case
vim.opt.smartcase = true                  -- search/cmds: uppercase -> ignorecase: OFF

vim.opt.cmdheight = 2                     -- messages: more space


vim.opt.lazyredraw = true -- performance: dont redraw on macros etc.

vim.opt.splitright = true -- split: to right (instead of left) on `:vsplit`
vim.opt.splitbelow = false

-- vim.opt.shortmess:append("s") -- Disable search wrap messages
-- vim.opt.shortmess:append "c"  -- Don't show the dumb matching stuff.
