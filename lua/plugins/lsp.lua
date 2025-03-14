return {
  {
    'williamboman/mason.nvim',
    lazy = true,
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      registries = {
        'github:nvim-java/mason-registry',
        'github:mason-org/mason-registry',
      },
    },
  },
  {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    ft = "java",
    dependencies = {
      'neovim/nvim-lspconfig',
    },
  },
  'lukas-reineke/lsp-format.nvim',
  -- {
  --   'mfussenegger/nvim-jdtls',
  --   ft = "java",
  -- },
  {
    'nvim-java/nvim-java',
    -- ft = 'java',
  },
  'mfussenegger/nvim-lint',
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'leoluz/nvim-dap-go',
    }
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local checkstyle_file = vim.env.CHECKSTYLE_FILE
      if checkstyle_file == nil then
        checkstyle_file = vim.env.HOME .. "/.config/custom/artelys-style.xml"
      end

      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.alex,
          null_ls.builtins.diagnostics.dotenv_linter,
          -- null_ls.builtins.diagnostics.editorconfig_checker, -- wrong intentation warning
          null_ls.builtins.diagnostics.hadolint,
          -- null_ls.builtins.diagnostics.proselint,
          null_ls.builtins.diagnostics.rstcheck,
          null_ls.builtins.diagnostics.selene,
          -- null_ls.builtins.diagnostics.semgrep.with({
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          null_ls.builtins.diagnostics.checkstyle.with({
            -- generator_opts = vim.tbl_extend("force", null_ls.builtins.diagnostics.checkstyle.generator_opts,
            --   { multiple_files = true }),
            runtime_condition = function(utils)
              if string.find(vim.fn.expand('%:h'), 'target') then
                return false
              end
              return true
            end,
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            extra_args = { "-c", checkstyle_file },
          }),
        }
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  'rcarriga/nvim-dap-ui',
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require 'nvim-dap-virtual-text'.setup {
        -- virt_lines = true,
        all_references = true,
        virt_text_pos = 'eol'
      }
    end,
  },
  'b0o/schemastore.nvim',
  'folke/trouble.nvim',
  'onsails/lspkind-nvim',
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'Hoffs/omnisharp-extended-lsp.nvim',
}
