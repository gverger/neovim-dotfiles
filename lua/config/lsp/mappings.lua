local M = {}

-- local utils = require('config.utils')

function M.setup()
  vim.cmd([[
  nnoremap <silent><c-]> <cmd> lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><leader>rn <cmd> lua vim.lsp.buf.rename()<CR>
  nnoremap <silent>K <cmd> lua vim.lsp.buf.hover()<CR>
  nnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.code_action()<CR>
  vnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.range_code_action()<CR>
  ]])
end

return M
