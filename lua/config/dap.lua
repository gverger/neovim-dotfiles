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

  dap.adapters.coreclr = {
    type = 'executable',
    command = mason_bin .. 'netcoredbg',
    args = { '--interpreter=vscode' }
  }

  local csharp_dll = nil
  local csharp_dir = nil

  dap.configurations.cs = {
    {
      type = "coreclr",
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
        type = "coreclr",
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
  vim.api.nvim_set_hl_ns(1234)
  vim.api.nvim_set_hl(1234, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f', bold = true })
  vim.api.nvim_set_hl(1234, 'DapLine', { ctermbg = 0, bg = '#31353f' })
  vim.api.nvim_set_hl(1234, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
  vim.api.nvim_set_hl(1234, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

  vim.fn.sign_define('DapBreakpoint', {
    text = '\xee\xae\x8b',
    texthl = 'DapBreakpoint',
    linehl = 'DapLine',
    numhl = 'DapBreakpoint'
  })

  vim.fn.sign_define('DapBreakpointCondition',
    { text = '?', texthl = 'DapBreakpoint', linehl = 'DapLine', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected',
    { text = '!', texthl = 'DapBreakpoint', linehl = 'DapLine', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLine', numhl = 'DapLogPoint' })
  vim.fn.sign_define('DapStopped', { text = '\xee\xab\x93', texthl = 'DapStopped', linehl = 'DapLine', numhl = 'DapStopped' })
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

  if not utils.has_plug('nvim-dap-virtual-text') then
    vim.notify('dap-virtual-text not installed')
    return
  end

  local dap = require("dap")
  local dapui = require("dapui")
  -- local dapvt = require("nvim-dap-virtual-text")

  -- local a = require'plenary.async'
  -- local sender, receiver = a.control.channel.mpsc()

  dapui.setup()
  -- dapvt.setup({
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    --- @diagnostic disable-next-line: unused-local
    -- display_callback = function(variable, buf, stackframe, node, options)
    --
    --   dap.session():evaluate(variable.name .. ".toString()", function (err, resp)
    --     local res = "no value"
    --     if err ~= nil then
    --       res = "err"
    --     else
    --       vim.print(resp)
    --       res = resp.result
    --     end
    --     sender.send(res)
    --   end)
    --
    --   local res = receiver.recv()
    --   vim.print(res)
    --   if options.virt_text_pos == 'inline' then
    --     return ' = ' .. res
    --   else
    --     return variable.name .. ' = ' .. res
    --   end
    -- end,
  -- })

  configure_csharp(dap)

  define_keymaps(dap, dapui)
  configure_style()
end

return M
