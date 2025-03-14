vim.keymap.set("n", "<c-space>", function()
  local line = vim.api.nvim_get_current_line()

  if string.find(line, "- %[ %]") then
    line = string.gsub(line, "- %[ %]", "- [x]", 1)
  elseif string.find(line, "- %[x%]") then
    line = string.gsub(line, "- %[x%]", "- [ ]", 1)
  end

  vim.api.nvim_set_current_line(line)
end, { noremap = true, silent = true, buffer = true })

local function import_file(import_folder)
  local actions_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  local Path = require('pathlib')
  local folder = Path(vim.api.nvim_buf_get_name(0)):parent()

  local print_selected_entry = function(prompt_bufnr)
    local selected_entry = actions_state.get_selected_entry()

    local filepath = Path(selected_entry[1])
    local new_file = vim.fn.input("Filename: images/")

    if new_file == "" then
      vim.notify("No name provided", vim.log.levels.ERROR)
    end

    if Path(new_file):suffix() ~= filepath:suffix() then
      new_file = new_file .. filepath:suffix()
    end

    local new_file_path = folder / "images" / new_file

    if not filepath:copy(new_file_path) then
      vim.notify("Image could not be copied to " .. new_file_path, vim.log.levels.ERROR)
    end
    actions.close(prompt_bufnr)
  end

  require("telescope.builtin").find_files({
    attach_mappings = function(_, map)
      map("n", "<cr>", print_selected_entry)
      map("i", "<cr>", print_selected_entry)
      return true
    end,
    search_dirs = { import_folder },
    find_command = { "rg", "--files", "--color", "never", "--iglob", "*.{jpg,jpeg,png,webp}" },
  })
end


vim.api.nvim_buf_create_user_command(0, "ImportScreenshot", function()
  import_file("/mnt/d/Documents/ShareX/Screenshots")
end, {})
