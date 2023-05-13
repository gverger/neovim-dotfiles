local M = {}

---check if the plugin is installed
---@param name string
function M.has_plug(name)
  return vim.g.plugs[name] ~= nil
end

---map a key
---@param mode string|table
---@param mapping string
---@param value string|function
function M.map(mode, mapping, value)
  vim.keymap.set(mode, mapping, value)
end

---map a key and forbid remap
---@param mode string|table
---@param mapping string
---@param value string|function
function M.noremap(mode, mapping, value)
  vim.keymap.set(mode, mapping, value, { noremap = true })
end

---Run a commandline synchronously
---@param command table the command
---@param cwd string|nil the working directory
---@return boolean true if all went well
---@return string the output
function M.run_sync(command, cwd)
  cwd = cwd or vim.fn.getcwd()
  local out = {}
  local err = ""
  local job_id = vim.fn.jobstart(command, {
    cwd = cwd,
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data == nil then
        return
      end

      for _, f in ipairs(data) do
        if f and f ~= "" then
          table.insert(out, f)
        end
      end
    end,
    on_stderr = function(_, data)
      if data == nil then
        return
      end

      err = data
    end,
  })
  local status = vim.fn.jobwait({ job_id }, 15000)[1]
  if status ~= 0 then
    vim.notify("Cannot run command '" .. table.concat(command, " ") .. "': error " .. M.put(status), "error")
    return false, err
  end

  return true, out
end

function M.file_readable(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else return false end
end

function M.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function M.put_text(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, '\n'), '\n')
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

return M
