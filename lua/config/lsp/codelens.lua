-- I don't like how nevim refreshes references right now, it kinda flickers...

local M = {}


local log = require('vim.lsp.log')
local util = require('vim.lsp.util')

local active_refreshes = {}

local function resolve_lenses(lenses, bufnr, client_id, callback)
  lenses = lenses or {}
  local num_lens = vim.tbl_count(lenses)
  if num_lens == 0 then
    callback()
    return
  end

  ---@private
  local function countdown()
    num_lens = num_lens - 1
    if num_lens == 0 then
      callback()
    end
  end
  local client = vim.lsp.get_client_by_id(client_id)
  for _, lens in pairs(lenses or {}) do
    if lens.command then
      countdown()
    else
      client.request('codeLens/resolve', lens, function(_, result)
        if vim.api.nvim_buf_is_loaded(bufnr) and result and result.command then
          lens.command = result.command
        end

        countdown()
      end, bufnr)
    end
  end
end

local on_codelens = function(err, result, ctx, _)
  if err then
    active_refreshes[ctx.bufnr] = nil
    local _ = log.error() and log.error('codelens', err)
    return
  end

  vim.lsp.codelens.save(result, ctx.bufnr, ctx.client_id)

  resolve_lenses(result, ctx.bufnr, ctx.client_id, function()
    active_refreshes[ctx.bufnr] = nil
    vim.lsp.codelens.display(result, ctx.bufnr, ctx.client_id)
  end)
end


function M.on_attach(client, bufnr)
  local refresh = function()
    local params = {
      textDocument = util.make_text_document_params(),
    }
    if active_refreshes[bufnr] then
      return
    end
    active_refreshes[bufnr] = true
    vim.lsp.buf_request(0, 'textDocument/codeLens', params, on_codelens)
  end
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({"BufEnter","InsertLeave"}, {
      buffer = bufnr,
      callback = refresh,
    })
  end
end

return M
