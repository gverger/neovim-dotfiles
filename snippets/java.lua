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

local function contains_cursor(node)
  local cursor = vim.api.nvim_win_get_cursor(0)
  return ts.is_in_node_range(node, cursor[1]-1, cursor[2]-1)
end

return {
  s({
    trig = "log",
    show_condition = function ()
      local node = ts_utils.get_node_at_cursor(0, false)
      print(node)
      if node == nil then
        return false
      end

      return node:type() == "class_body" or node:type() == "field_declaration"
    end
  }, fmt([[private static final Logger LOGGER = LoggerFactory.getLogger({}.class);]], {f(function ()
    local tree = ts.get_parser(0, 'java')
    local root = tree:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local query = ts.query.parse('java', [[
    [
    (class_declaration name: (identifier) @name body: (class_body) @body)
    (record_declaration name: (identifier) @name body: (class_body) @body)
    ]
    ]])

    local class_first_line = -1
    local class_name = ""

    for pattern, match, metadata in query:iter_matches(root, bufnr) do
      local body_node = match_for('body', query, match)
      assert(body_node ~= nil)

      local outerclass_first_line = body_node:range()

      if outerclass_first_line > class_first_line and contains_cursor(body_node) then
        class_first_line = outerclass_first_line

        local name_node = match_for('name', query, match)
        class_name = node_text(name_node)
      end
    end
    return class_name


  end)})),
  s("test", fmt([[
  @Test
  void {}() {{
    {}
  }}
  ]], {i(1, "testName"), i(0)})),
  s("cst", fmt([[{} static final {} {} = {};]], {c(1, {t 'private', t 'public'}), i(2, "String"), i(3, "CSTE"), i(4, "nil")})),
}, nil
