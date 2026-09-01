vim.keymap.set("n", "<leader>ff", function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local input = table.concat(lines, "\n")

  local result = vim.system(
    { "jq", "." },
    { stdin = input, text = true }
  ):wait()

  if result.code == 0 then
    local new_lines = vim.split(result.stdout, "\n", { plain = true })
    table.remove(new_lines, #new_lines)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
  else
    vim.notify(
      ("jq failed (code %d):\n%s"):format(result.code, result.stderr),
      vim.log.levels.ERROR
    )
  end
end, { noremap = true, silent = true, buffer = true })
