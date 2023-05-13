local M = {}

function M.setup()
  vim.cmd([[
  if system('uname -r') =~ "microsoft"
      augroup Yank
          autocmd!
          autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
          augroup END
  endif
  ]])
end

return M
