call plug#begin('~/.vim/plugged')
" install with :PlugInstall

Plug 'terryma/vim-multiple-cursors' " CTRL + N for new cursor
Plug 'tpope/vim-surround' " ds': 'word' -> word | cs'(: 'word' -> ( word )
Plug 'jiangmiao/auto-pairs'

""" Fuzzy finder: Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
"Plug 'nvim-telescope/telescope-fzy-native.nvim'

""" language support
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/vim-vsnip'

""" Rust support
" build rust-analyzer language server: cargo xtask install --server

"" other: https://sharksforarms.dev/posts/neovim-rust/
"" other (see https://rust-analyzer.github.io/manual.html#installation):
Plug 'simrat39/rust-tools.nvim'

" Plug 'neoclide/coc.nvim' , {'branch': 'release'} " Auto Completion
" Plug 'fannheyward/coc-rust-analyzer' " default settings for rust-analyzer in coc-settings.json
"run ':CocInstall coc-rust-analyzer'


""" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ThePrimeagen/vim-be-good' " train vim movements with :VimBeGood5

""" Themes
Plug 'gruvbox-community/gruvbox'
Plug 'ryanoasis/vim-devicons'

call plug#end()



""" Mappings
set notimeout

let mapleader = " "
" <leader> = <Leader>  = <SPACE>
" mode [no recursive] map

" move entire line with V + K or J 5
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
