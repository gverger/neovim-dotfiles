local ts = vim.treesitter

local function node_text(node)
  return ts.get_node_text(node, 0)
end

local function match_for(name, query, match)
  for id, nodes in pairs(match) do
    if name == query.captures[id] then
      for _, node in ipairs(nodes) do
        return node
      end
    end
  end
  return nil
end


local function format_params(query, root, num_params_break)
  local matches = {}
  local match_idx = {}
  local idx = 1
  for pattern, match, metadata in query:iter_matches(root, bufnr) do
    local params = match_for("decl", query, match)
    assert(params ~= nil)
    local key = params:id()
    if match_idx[key] == nil then
      match_idx[key] = idx
      local list = match_for("list", query, match)
      matches[idx] = { params, list }
      idx = idx + 1
    end
    table.insert(matches[match_idx[key]], match_for("param", query, match))
  end

  local sorted = {}
  for _, m in ipairs(matches) do
    table.insert(sorted, 1, m)
  end

  for _, m in ipairs(sorted) do
    if #m > num_params_break + 2 then
      local _, indent = m[1]:range()
      local row, start_init, end_row, end_update = m[2]:range()
      local replace = {}
      table.remove(m, 1)
      table.remove(m, 1)
      table.insert(replace, "")
      for i, node in ipairs(m) do
        local line = string.rep(" ", indent + 8) .. node_text(node)
        if i ~= #m then
          line = line .. ","
        end
        table.insert(replace, line)
      end
      vim.api.nvim_buf_set_text(0, row, start_init + 1, end_row, end_update - 1, replace)
    end
  end
end

local function format_as_florian()
  local tree = ts.get_parser(0, 'cpp')
  local root = tree:parse()[1]:root()

  local query = ts.query.parse('cpp', [[
    [
    (for_statement initializer: (_) @init condition: (_) @cond update: (_) @update) @for
    ]
    ]])

  local matches = {}
  for pattern, match, metadata in query:iter_matches(root, bufnr) do
    table.insert(matches, 1, match)
  end

  for _, match in ipairs(matches) do
    local init_node = match_for('init', query, match)
    assert(init_node ~= nil)
    local cond_node = match_for('cond', query, match)
    assert(cond_node ~= nil)
    local update_node = match_for('update', query, match)
    assert(update_node ~= nil)

    local row, start_init = init_node:range()
    local _, _, end_row, end_update = update_node:range()

    vim.api.nvim_buf_set_text(0, row, start_init, end_row, end_update,
      {
        node_text(init_node),
        string.rep(" ", start_init + 3) .. node_text(cond_node) .. ";",
        string.rep(" ", start_init + 3) .. node_text(update_node),
      })
  end
  tree = ts.get_parser(0, 'cpp')
  root = tree:parse()[1]:root()
  query = ts.query.parse('cpp', [[
      [
      (function_definition (function_declarator (parameter_list [ (parameter_declaration) (optional_parameter_declaration) ] @param) @list)) @decl
      ]
      ]])

  format_params(query, root, 0)

  tree = ts.get_parser(0, 'cpp')
  root = tree:parse()[1]:root()
  query = ts.query.parse('cpp', [[
      [
    (declaration (function_declarator (parameter_list [ (parameter_declaration) (optional_parameter_declaration) ] @param) @list)) @decl
    (field_declaration (function_declarator (parameter_list [ (parameter_declaration) (optional_parameter_declaration) ] @param) @list)) @decl
      ]
      ]])

  format_params(query, root, 1)


  tree = ts.get_parser(0, 'cpp')
  root = tree:parse()[1]:root()
  query = ts.query.parse('cpp', [[
      [
(class_specifier body: (_) @body)
    ]
        ]])

  matches = {}
  for pattern, match, metadata in query:iter_matches(root, bufnr) do
    table.insert(matches, 1, match)
  end

  for _, match in ipairs(matches) do
    local n = match_for("body", query, match)
    assert(n ~= nil)
    local last_child = nil
    for c in n:iter_children() do
      last_child = c
    end
    local r, c, r2, c2 = last_child:range()
    vim.api.nvim_buf_set_text(0, r, c, r2, c2, { "", node_text(last_child) })
  end
end
vim.keymap.set("n", "<leader>ff", function()
  vim.lsp.buf.format({ async = false })
  format_as_florian()
end, { noremap = true, silent = true, buffer = true })
