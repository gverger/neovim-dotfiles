local function prev_line()
  local lastline = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, lastline-2, lastline-1, false)
  return lines[1] or ""
end

return {
  s("--", f(function ()
    return string.rep("-",string.len(prev_line()))
  end)),
  s("==", f(function ()
    return string.rep("=",string.len(prev_line()))
  end)),
  s("^^", f(function ()
    return string.rep("^",string.len(prev_line()))
  end)),
}, nil
