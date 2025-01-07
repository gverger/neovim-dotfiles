local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("req", fmt([[local {} = require('{}')]], { f(
    function(import_name)
      local parts = vim.split(import_name[1][1], ".")
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
