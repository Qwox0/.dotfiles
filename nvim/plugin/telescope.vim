" requirement: 'sudo apt install ripgrep'

" https://github.com/nvim-telescope/telescope.nvim
" https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/plugin/telescope.vim

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>fs :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>

