local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f
local i = luasnip.i
local fmt = require("luasnip.extras.fmt").fmt
local rep = require('luasnip.extras').rep

local function current_line()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, current - 1, current, false)
  return lines[1] or ""
end

local ts_utils = require('nvim-treesitter.ts_utils')

local function put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

local function assign_caller()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return ""
  end

  if current_node:type() ~= "argument_list" then
    return ""
  end

  local attr = current_node:prev_named_sibling()

  for i = 0, attr:named_child_count() - 1, 1 do
    local child = attr:named_child(i)
    local type = child:type()

    if type == 'identifier' or type == 'operator_name' then
      return (ts_utils.get_node_text(child))
    end
  end
  return ""
end

return {
  s("caller", fmt([[ {}! {} ]], { i(1), f(function(args, parent, user_args)
    return assign_caller()
  end, { 1 }) })),
  s("category", fmt([[{}={}.{}.astype("category")]], { i(1), f(assign_caller), rep(1) })),
  s("pvar", fmt([[print(f"{} = {{vars({}) if '__dict__' in dir({}) else {}}} ({{type({}).__name__}})")]], { rep(1), i(1), rep(1), rep(1), rep(1) })),
  s("definit", fmt([[
  def __init__(self, {}):
  {}
  ]], { i(1), f(function(args, parent, user_args)
    local parameters = args[1][1]
    if parameters == "" then
      return "\t..."
    end
    local lines = vim.split(parameters, ",")
    local res = {}
    for _, p in pairs(lines) do
      local name = vim.trim(vim.split(p, ":")[1])
      table.insert(res, "\tself." .. name .. " = " .. name)
    end
    return res
  end, { 1 }) })),
  s("meth", fmt([[
  def {}(self{}):
      {}
  ]], { i(1), i(2), i(0) })),
  s("adventinit", fmt([[
  import sys

  class {}:
      def __init__(self, input):
          self.{} = self._load(input)

      def part1(self):
          ...

      def part2(self):
          ...

      def _load(self, file):
          with open(file) as input:
              {}

  if __name__ == "__main__":
      file = sys.argv[1] if len(sys.argv) > 1 else "input/sample.txt"

      {}(file).part1()
      {}(file).part2()
  ]], { i(1), i(2), i(0), rep(1), rep(1) })),
}, nil
