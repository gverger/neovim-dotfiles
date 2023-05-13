return {
  s("req", fmt([[local {} = require('{}')]], {f(
  function (import_name)
    local parts = vim.split(import_name[1][1], ".", true)
    return parts[#parts] or ""
  end, { 1 }), i(1)})),
  s("mod", fmt([[
  local M = {{}}

  local utils = require('config.utils')

  function M.setup()
    {}
  end

  return M
  ]], {i(0)})),
}, nil
