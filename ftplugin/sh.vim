set tabstop=4 shiftwidth=4 softtabstop=4

augroup SH_LINT
  autocmd!
  au BufWritePost *.sh :silent! lua require('lint').try_lint()
augroup end
