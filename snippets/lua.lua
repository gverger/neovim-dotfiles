return {
  s("req", fmt([[local {} = require('{}')]], { f(
    function(import_name)
      local parts = vim.split(import_name[1][1], ".", true)
      return parts[#parts] or ""
    end, { 1 }), i(1) })),
  s("mod", fmt([[
  local M = {{}}

  local utils = require('config.utils')

  function M.setup()
    {}
  end

  return M
  ]], { i(0) })),
  s("new", fmt(
    [[
  ---@return {}
  function {}:new(o)
    return new({}, o)
  end
  ]], { rep(1), i(1), rep(1) })),
  s("tos", fmt(
    [[
  ---@return string
  function {}:__tostring()
    return {}
  end
  ]], { i(1), i(0, "") }))
}, nil
