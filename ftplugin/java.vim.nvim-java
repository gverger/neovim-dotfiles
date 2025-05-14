
"let test#java#maventest#executable = 'mvnd'

function! java#GetPosition()
  let filename_modifier = get(g:, 'test#filename_modifier', ':.')
  let path = expand('%')

  let position = {}
  let position['file'] = fnamemodify(path, filename_modifier)
  let position['line'] = line('.')
  let position['col']  = col('.')

  return position
endfunction

nnoremap <buffer> <leader>sy :call system('/mnt/c/windows/system32/clip.exe ', test#java#maventest#executable . ' ' . test#java#maventest#build_position("nearest", java#GetPosition())[0])<CR>

setlocal tabstop=4 shiftwidth=4 softtabstop=4
