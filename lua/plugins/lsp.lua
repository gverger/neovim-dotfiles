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
  },
  'lukas-reineke/lsp-format.nvim',
  {
    'mfussenegger/nvim-jdtls',
    ft = "java",
  },
  'mfussenegger/nvim-lint',
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'b0o/schemastore.nvim',
  'folke/trouble.nvim',
  'onsails/lspkind-nvim',
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
}
