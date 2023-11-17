local luasnip = require('luasnip')
local s = luasnip.s
local i = luasnip.i
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local function node_text(node)
  return ts.get_node_text(node, 0)
end

local function matches_for(name, query, match)
  local res = {}
  for id, node in pairs(match) do
    if name == query.captures[id] then
      table.insert(res, node)
    end
  end
  return res
end

local function match_for(name, query, match)
  return matches_for(name, query, match)[1]
end

local function next_line_contains_cursor(node)
  local cursor = vim.api.nvim_win_get_cursor(0)
  return ts.is_in_node_range(node, cursor[1]+1, cursor[2]-1)
end

return {
  s("writeline", fmt([[Console.WriteLine($"{}");]], { i(1, "message") })),
  s("xmlAttr", fmt([[
  [XmlAttribute("{}")]
  public {} {} {{ get; set; }}]], {rep(1, ""), i(2, "int"), i(1)})),
  s("summary",
  fmt([[{}]], {f(function ()
    local tree = ts.get_parser(0, 'c_sharp')
    local root = tree:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local query = ts.query.parse('c_sharp', [[
    [
    (method_declaration type: _ @ret name: _ @name parameters: (parameter_list )+ @list) @decl
    ]
    ]])

    local param_query = ts.query.parse('c_sharp', [[
    (parameter name: _ @par)
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
        local param_list = matches_for('list', query, match)
        for _, node in pairs(param_list) do
          if node ~= nil then
            for pattern, m, metadata in param_query:iter_matches(node, bufnr) do
              local params = matches_for('par', param_query, m)
              for _, param_node in pairs(params) do
                table.insert(res, "/// <param name=\""..node_text(param_node).."\">desc</param>")
              end
            end
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
}
