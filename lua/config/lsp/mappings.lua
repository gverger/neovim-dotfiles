local M = {}

-- local utils = require('config.utils')

function M.setup()
  vim.cmd([[
  nnoremap <silent><c-]> <cmd> lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><leader>rn <cmd> lua vim.lsp.buf.rename()<CR>
  nnoremap <silent>K <cmd> lua vim.lsp.buf.hover()<CR>
  nnoremap <silent>L <cmd> lua vim.lsp.buf.document_highlight()<CR>
  nnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.code_action()<CR>
  vnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.range_code_action()<CR>
    " autocmd CursorMoved,CursorMovedI,BufHidden,InsertEnter,InsertCharPre,WinLeave <buffer> lua vim.lsp.buf.clear_references()
    " autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  ]])
end

return M
