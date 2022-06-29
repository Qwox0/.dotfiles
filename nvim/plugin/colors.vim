fun! ColorVim()

    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
    highlight Normal guibg=none
    " for airline
    "let g:airline_theme='gruvbox'
endfun

" let g:colorscheme = "gruvbox"
call ColorVim()
