local luasnip = require('luasnip')
local s = luasnip.s
local i = luasnip.i
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local function node_text(node)
  return ts.get_node_text(node, 0)
end

local function match_for(name, query, match)
  for id, node in pairs(match) do
    if name == query.captures[id] then
      return node
    end
  end
  return nil
end

local function next_line_contains_cursor(node)
  local cursor = vim.api.nvim_win_get_cursor(0)
  return ts.is_in_node_range(node, cursor[1]+1, cursor[2]-1)
end

return {
  s("writeline", fmt([[Console.WriteLine($"{}");]], { i(1, "message") })),
  s("summary",
  fmt([[{}]], {f(function ()
    local tree = ts.get_parser(0, 'c_sharp')
    local root = tree:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local query = ts.query.parse('c_sharp', [[
    [
    (method_declaration type: _ @ret name: _ @name parameters: (parameter_list (parameter name: _ @par))) @decl
    ]
    ]])

    local next_method_line = -1

    for pattern, match, metadata in query:iter_matches(root, bufnr) do
      local method_node = match_for('decl', query, match)
      if next_line_contains_cursor(method_node) then
        local name_node = match_for('name', query, match)
        local res = {
          "/// <summary>",
          "/// "..node_text(name_node),
          "/// </summary>",
        }
        for id, node in pairs(match) do
          if "par" == query.captures[id] then
            table.insert(res, "/// <param name=\""..node_text(node).."\">desc</param>")
          end
        end
        table.insert(res, "/// <returns>A "..node_text(match_for("ret", query, match)).."</returns>")
        return res
      end
    end

    return "not found"


  end)})),
    s("getset",
        fmt([[public {} {} {{ get; set; }}]], { i(1, "string"), i(2, "variable") })),

    s("namespc",
        fmt([[namespace {};]], { f(function()
            local relative_path = vim.fn.expand('%:p:.:h')
            return relative_path:gsub('/', '.')
        end) })),

    s('cls',
        fmt([[
        class {}
        {{
            {}
        }}]], { f(function()
            return vim.fn.expand('%:t'):gsub(".cs$", '')
        end), i(0) })),
}
