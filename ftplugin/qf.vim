hi! link TestInfo DiagnosticSignInfo
hi! link TestWarn DiagnosticSignWarn
hi! link TestError DiagnosticSignError
hi! TestSuccess guifg=Green

augroup TestsColors
  autocmd!

  " Maven
  autocmd BufWinEnter * syn match TestInfo /\[INFO\]/
  autocmd BufWinEnter * syn match TestWarn /\[WARN\]/
  autocmd BufWinEnter * syn match TestError /\[ERROR\]/
  autocmd BufWinEnter * syn match TestError /\[ERROR\].*FAILURE\!/
  autocmd BufWinEnter * syn match TestSuccess /BUILD SUCCESS/
augroup end
