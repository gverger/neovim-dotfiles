if exists("g:loaded_projectionist")
  let g:projectionist_heuristics['*.go'] = {
      \ '*.go': { 'alternate': '{}_test.go', 'type': 'source' },
      \ '*_test.go': { 'alternate': '{}.go', 'type': 'test' }
      \ }
endif

lua <<EOF
function org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end
EOF


augroup GO_LSP
  autocmd!
  autocmd BufWritePre *.go :silent! lua org_imports(1000)
  autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

setlocal noexpandtab
