local M = {}

local utils = require('config.utils')

local HIGHLIGHTS = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
  [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
  [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
  [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
}

local SPACE = "space"
local DIAGNOSTIC = "diagnostic"
local OVERLAP = "overlap"
local BLANK = "blank"

local current_win_id = nil
local last_line_number = nil
local last_line = nil
local ns = vim.api.nvim_create_namespace("")

---Returns the distance between two columns in cells.
---
---Some characters (like tabs) take up more than one cell. A diagnostic aligned
---under such characters needs to account for that and add that many spaces to
---its left.
---
---@return integer
local function distance_between_cols(bufnr, lnum, start_col, end_col)
  local lines = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)
  if vim.tbl_isempty(lines) then
    -- This can only happen is the line is somehow gone or out-of-bounds.
    return 1
  end

  local sub = string.sub(lines[1], start_col, end_col)
  return vim.fn.strdisplaywidth(sub, 0) -- these are indexed starting at 0
end


---@param bufnr number
---@param diagnostics table
---@param opts boolean|Opts
function M.show(bufnr, diagnostics, opts)
  if not vim.api.nvim_buf_is_loaded(bufnr) then return end
  vim.validate({
    bufnr = { bufnr, "n" },
    diagnostics = {
      diagnostics,
      vim.tbl_islist,
      "a list of diagnostics",
    },
    opts = { opts, "t", true },
  })

  table.sort(diagnostics, function(a, b)
    if a.lnum ~= b.lnum then
      return a.lnum < b.lnum
    else
      return a.col < b.col
    end
  end)

  if #diagnostics == 0 then
    return
  end
  local highlight_groups = HIGHLIGHTS

  -- This loop reads line by line, and puts them into stacks with some
  -- extra data, since rendering each line will require understanding what
  -- is beneath it.
  local line_stacks = {}
  local prev_lnum = -1
  local prev_col = 0
  for _, diagnostic in ipairs(diagnostics) do
    if line_stacks[diagnostic.lnum] == nil then
      line_stacks[diagnostic.lnum] = {}
    end

    local stack = line_stacks[diagnostic.lnum]

    if diagnostic.lnum ~= prev_lnum then
      table.insert(stack, { SPACE, string.rep(" ", distance_between_cols(bufnr, diagnostic.lnum, 0, diagnostic.col)) })
    elseif diagnostic.col ~= prev_col then
      -- Clarification on the magic numbers below:
      -- +1: indexing starting at 0 in one API but at 1 on the other.
      -- -1: for non-first lines, the previous col is already drawn.
      table.insert(
        stack,
        { SPACE, string.rep(" ", distance_between_cols(bufnr, diagnostic.lnum, prev_col + 1, diagnostic.col) - 1) }
      )
    else
      table.insert(stack, { OVERLAP, diagnostic.severity })
    end

    if diagnostic.message:find("^%s*$") then
      table.insert(stack, { BLANK, diagnostic })
    else
      table.insert(stack, { DIAGNOSTIC, diagnostic })
    end

    prev_lnum = diagnostic.lnum
    prev_col = diagnostic.col
  end

  for lnum, lelements in pairs(line_stacks) do
    local virt_lines = {}

    -- We read in the order opposite to insertion because the last
    -- diagnostic for a real line, is rendered upstairs from the
    -- second-to-last, and so forth from the rest.
    for i = #lelements, 1, -1 do -- last element goes on top
      if lelements[i][1] == DIAGNOSTIC then
        local diagnostic = lelements[i][2]
        local empty_space_hi
        if opts.virtual_lines and opts.virtual_lines.highlight_whole_line == false then
          empty_space_hi = ""
        else
          empty_space_hi = highlight_groups[diagnostic.severity]
        end

        local left = {}
        local overlap = false
        local multi = 0

        -- Iterate the stack for this line to find elements on the left.
        for j = 1, i - 1 do
          local type = lelements[j][1]
          local data = lelements[j][2]
          if type == SPACE then
            if multi == 0 then
              table.insert(left, { data, empty_space_hi })
            else
              table.insert(left, { string.rep("─", data:len()), highlight_groups[diagnostic.severity] })
            end
          elseif type == DIAGNOSTIC then
            -- If an overlap follows this, don't add an extra column.
            if lelements[j + 1][1] ~= OVERLAP then
              table.insert(left, { "│", highlight_groups[data.severity] })
            end
            overlap = false
          elseif type == BLANK then
            if multi == 0 then
              table.insert(left, { "└", highlight_groups[data.severity] })
            else
              table.insert(left, { "┴", highlight_groups[data.severity] })
            end
            multi = multi + 1
          elseif type == OVERLAP then
            overlap = true
          end
        end

        local center_symbol
        if overlap and multi > 0 then
          center_symbol = "┼"
        elseif overlap then
          center_symbol = "├"
        elseif multi > 0 then
          center_symbol = "┴"
        else
          center_symbol = "└"
        end
        -- local center_text =
        local center = {
          { string.format("%s%s", center_symbol, "──── "), highlight_groups[diagnostic.severity] },
        }

        -- TODO: We can draw on the left side if and only if:
        -- a. Is the last one stacked this line.
        -- b. Has enough space on the left.
        -- c. Is just one line.
        -- d. Is not an overlap.

        local msg
        if diagnostic.code then
          msg = string.format("%s: %s", diagnostic.code, diagnostic.message)
        else
          msg = diagnostic.message
        end
        for msg_line in msg:gmatch("([^\n]+)") do
          local vline = {}
          vim.list_extend(vline, left)
          vim.list_extend(vline, center)
          vim.list_extend(vline, { { msg_line, highlight_groups[diagnostic.severity] } })

          table.insert(virt_lines, vline)

          -- Special-case for continuation lines:
          if overlap then
            center = { { "│", highlight_groups[diagnostic.severity] }, { "     ", empty_space_hi } }
          else
            center = { { "      ", empty_space_hi } }
          end
        end
      end
    end

    local lines = {}
    for _, line in pairs(virt_lines) do
      local current = ""
      for _, element in pairs(line) do
        current = current .. element[1]
      end
      table.insert(lines, current)
    end

    local rows = #lines
    local cols = 0
    for _, line in pairs(lines) do
      cols = math.max(cols, #line)
    end

    local float_buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buffer, 0, 0, true, lines)

    for idx_line, line in pairs(virt_lines) do
      local idx = 0
      for _, element in pairs(line) do
        local txt = element[1]
        local hl = element[2]
        -- local len = vim.fn.strdisplaywidth(txt)
        local len = #txt
        print("[" .. txt .. "]" .. " size = " .. len .. " idx = " .. idx .. " line = " .. idx_line .. " hl = " .. hl)
        vim.highlight.range(float_buffer, ns, hl, { idx_line - 1, idx }, { idx_line - 1, idx + len })
        idx = idx + len
      end
    end

    -- vim.highlight.range(float_buffer, ns, "DiagnosticVirtualTextError", { 0, 18 }, { 0, 71 })

    local col_number = vim.api.nvim_win_get_cursor(0)[2]
    current_win_id = vim.api.nvim_open_win(float_buffer, false,
      {
        relative = 'win',
        row = vim.fn.winline(),
        col = vim.fn.wincol() - col_number - 1,
        width = cols,
        height = rows,
        style = "minimal",
      })

    require("config.utils").put(lines)
  end
end

local function load_lsp_lines()
  local lsp_lines = require('lsp_lines')

  lsp_lines.setup()

  utils.noremap("", "<Leader>d", function()
  end, { desc = "cancel deletion on mistyping leader d" })

  utils.noremap("", "<Leader>dl", function()
    local current = vim.diagnostic.config().virtual_text
    if current then
      vim.diagnostic.config({ virtual_text = false })
    else
      vim.diagnostic.config({ virtual_text = { severity = "Error" } })
    end
    lsp_lines.toggle()
  end, { desc = "Toggle lsp_lines" })
end

---close the window
---@param win_id integer?
function M.close(win_id)
  if not win_id then
    return
  end
  local float_buffer = vim.api.nvim_win_get_buf(win_id)
  vim.api.nvim_buf_clear_namespace(float_buffer, ns, 0, -1)
  vim.api.nvim_win_close(win_id, true)
  vim.api.nvim_buf_delete(float_buffer, { force = true })
end

function M.show_at_cursor()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local lsp_line_number = line_number - 1;
  local diags = vim.diagnostic.get(0, { lnum = lsp_line_number })
  require("config.utils").put(diags)
  local last_winid = current_win_id
  current_win_id = nil
  M.show(0, diags, {})
  M.close(last_winid)
  last_line_number = lsp_line_number
  last_line = vim.api.nvim_get_current_line()
end

function M.setup()
  load_lsp_lines()

  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
      vim.schedule(function()
        if current_win_id then
          M.close(current_win_id)
          current_win_id = nil
          last_line_number = nil
          last_line = nil
        end
      end)
    end
  })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      local line_number = vim.api.nvim_win_get_cursor(0)[1]
      local lsp_line_number = line_number - 1;
      if last_line_number == lsp_line_number then
        local line = vim.api.nvim_get_current_line()
        if line ~= last_line then
          print("show " .. line)
          M.show_at_cursor()
        end

        return
      end
      if not current_win_id then
        return
      end

      M.close(current_win_id)
      current_win_id = nil
      last_line_number = nil
      last_line = nil
    end
  })

  vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
    callback = function()
      M.show_at_cursor()
    end
  })
end

return M
