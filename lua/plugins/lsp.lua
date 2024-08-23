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
        -- 'github:nvim-java/mason-registry',
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
  {
    'mfussenegger/nvim-jdtls',
    ft = "java",
  },
  'mfussenegger/nvim-lint',
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
    }
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
}
