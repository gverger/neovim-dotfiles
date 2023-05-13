" Use rubocop daemon for more speed
" let g:neomake_rubocop_maker = {
"       \ 'exe': 'rubocop-daemon-wrapper',
"       \ 'args': ['--format', 'emacs', '--force-exclusion', '--no-display-cop-names'],
"       \ 'errorformat': '%f:%l:%c: %t: %m,%E%f:%l: %m',
"       \ 'postprocess': function('neomake#makers#ft#ruby#RubocopEntryProcess'),
"       \ 'output_stream': 'stdout',
"       \ }
"
" let g:neomake_ruby_enabled_makers = ['rubocop']
" nnoremap <leader>sy :let @*=expand("%") . ':' . line(".")<CR>


" folding comments
" autocmd FileType ruby,eruby
"       \ set foldmethod=expr |
"       \ set foldexpr=getline(v:lnum)=~'^\\s*#'

" Copié de ~/.vim/plug/neoformat/autoload/neoformat/formatters/ruby.vim
" let g:neoformat_ruby_rubocop_daemon = {
"         \ 'exe': 'rubocop-daemon-wrapper',
"         \ 'args': ['--auto-correct', '--stdin', '"%:p"', '2>/dev/null', '|', 'sed "1,/^====================$/d"'],
"         \ 'stdin': 1,
"         \ 'stderr': 1
"         \ }
"
" let g:neoformat_enabled_ruby = ['rubocop_daemon']

augroup ruby
  au!
  autocmd BufNewFile,BufRead *.rbi   set syntax=ruby
augroup END

" Sorbet Highlighting
" :autocmd BufWinEnter * syntax region SorbetSig start="sig {" end="}"
" :autocmd ColorScheme * highlight link SorbetSig Comment
" :autocmd BufWinEnter * syntax region SorbetSigDo start="sig do" end="end"
" :autocmd ColorScheme * highlight link SorbetSigDo Comment

" augroup fmt
"   autocmd!
"   autocmd BufWritePre Gemfile,*.rb,*.ru lua vim.lsp.buf.formatting_sync(nil, 1000)
" augroup END
