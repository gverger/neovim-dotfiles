lua vim.keymap.set("n", "<leader>ff", ":Neoformat prettier<CR>" , { noremap = true, silent = true, buffer = true })

augroup MD_LINT
  autocmd!
  au BufWritePost *.md :silent! lua require('lint').try_lint()
augroup end
