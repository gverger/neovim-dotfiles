local M = {}

local utils = require('config.utils')

local function define_keymaps(dap, dapui)
  utils.noremap({ "n" }, "<leader>dui", dapui.toggle)
  utils.noremap({ "n", "v" }, "<leader>dk", dapui.eval)
  vim.keymap.set({ "n" }, "<leader>dbt", dap.toggle_breakpoint)

  if utils.has_plug('telescope-dap.nvim') then
    require('telescope').load_extension("dap")
    vim.keymap.set({ "n" }, "<leader>dbl", ":Telescope dap list_breakpoints<CR>")
    vim.keymap.set({ "n" }, "<leader>de", ":Telescope dap commands<CR>")
    vim.keymap.set({ "n" }, "<leader>df", ":Telescope dap frames<CR>")
  end
end

local function configure_csharp(dap)
  local mason_bin = "/home/gverger/.local/share/nvim/mason/bin/"

  dap.adapters.netcoredbg = {
    type = 'executable',
    command = mason_bin .. 'netcoredbg',
    args = { '--interpreter=vscode' }
  }

  local csharp_dll = nil
  local csharp_dir = nil

  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "launch - netcoredbg",
      request = "launch",
      preLaunchTask = "build",
      program = function()
        print(vim.api.nvim_buf_get_name(0))
        if csharp_dll then
          return vim.fn.getcwd() .. "/" .. csharp_dll
        end
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end,
      -- cwd = "${fileDirname}",
      cwd = function()
        return vim.fn.getcwd() .. "/" .. csharp_dir
      end,
      env = {
        DOTNET_ENVIRONMENT = "Development", -- hacky: should check the Properties/lauchSettings.json
      }
    },
  }

  vim.keymap.set({ "n" }, "<Leader>dr", function()
    local ok, program_files = utils.run_sync({ "fdfind", "Program.cs" })
    if not ok then
      return
    end
    local configs = {}
    for _, f in ipairs(program_files) do
      f = f:gsub("/Program.cs$", "")
      -- f = f:gsub("/Properties/launchSettings.json$", "")
      table.insert(configs, f)
    end
    vim.ui.select(configs, { prompt = "Run..." }, function(item, _)
      csharp_dir = item

      vim.notify("Building...")
      local ok = utils.run_sync({ "dotnet", "build" }, vim.fn.getcwd() .. "/" .. csharp_dir)
      if not ok then
        vim.notify("Aborting launch")
        return
      end

      local dll_cmd = { "fdfind", "-I", item .. ".dll", item .. "/bin/Debug" }
      local ok, dll = utils.run_sync(dll_cmd)
      if not ok or not dll then
        vim.notify("Can't find dll: " .. table.concat(dll_cmd, " "), "error")
        return
      end

      local dll_file = dll[1]
      if not dll_file then
        vim.notify("Can't find dll: " .. table.concat(dll_cmd, " "), "error")
        return
      end
      csharp_dll = dll_file

      vim.notify("Running...")

      require('dap').run({
        type = "netcoredbg",
        name = "launch - netcoredbg",
        request = "launch",
        program = function(a)
          return vim.fn.getcwd() .. "/" .. csharp_dll
        end,
        cwd = function()
          return vim.fn.getcwd() .. "/" .. csharp_dir
        end,
        env = {
          DOTNET_ENVIRONMENT = "Development", -- hacky: should check the Properties/lauchSettings.json
        }
      })
    end)
  end, { desc = "run dap" })
end

local function configure_style()
  vim.fn.sign_define('DapBreakpoint', {
    text = '\xee\xae\xb4',
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapBreakpoint'
  })
  vim.fn.sign_define('DapBreakpointCondition', {
    text = '?',
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapBreakpointRejected', {
    text = '!',
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapLogPoint', {
    text = '',
    texthl = 'DapLogPoint',
    linehl = 'DapLine',
    numhl = 'DapLogPoint',
  })
  vim.fn.sign_define('DapStopped', {
    text = '\xee\xab\x93',
    texthl = 'DapStopped',
    linehl = 'DapLine',
    numhl = 'DapStopped',
  })
end

function M.setup()
  if not utils.has_plug('nvim-dap') then
    vim.notify('dap is not installed')
    return
  end

  if not utils.has_plug('nvim-dap-ui') then
    vim.notify('dapui is not installed')
    return
  end

  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()

  configure_csharp(dap)

  define_keymaps(dap, dapui)
  configure_style()
end

return M
