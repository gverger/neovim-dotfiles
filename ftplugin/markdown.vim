augroup MD_LINT
  autocmd!
  au BufWritePost *.md :silent! lua require('lint').try_lint()
augroup end
