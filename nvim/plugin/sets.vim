" vim settings
set hidden

" audio
set noerrorbells

" swap/backup
set noswapfile
set updatetime=50
set nobackup
set undodir=~/.vim/undodir
set undofile

" left column settings
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber " no relative numbers in insert Mode
autocmd InsertLeave * :set relativenumber 
set signcolumn=yes

" tab settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent

" search
set nohlsearch
set incsearch

" Autocompletion (lsp)
" longest preview noinsert noselect
set completeopt=menuone,preview

" message
set cmdheight=2

set scrolloff=5
