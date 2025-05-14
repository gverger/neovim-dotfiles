hi! link TestInfo DiagnosticInfo
hi! link TestWarn DiagnosticWarn
hi! link TestError DiagnosticError
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
