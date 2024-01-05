return {
  "folke/lazy.nvim",

  {
    'tpope/vim-fugitive',
    keys = {
      { "<leader>gs", "<cmd>Git<CR>" },
    },
    config = function()
      vim.g.fugitive_gitlab_domains = { 'https://gitlab.artelys.com' }
    end
  },
  'shumphrey/fugitive-gitlab.vim',
  'tpope/vim-rhubarb',
  'tpope/vim-eunuch',
  'tpope/vim-projectionist',
  'jeetsukumaran/vim-filebeagle',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  'bronson/vim-trailing-whitespace',
  'tmhedberg/matchit',
  'sickill/vim-pasta',
  'tpope/vim-dispatch',
  'christoomey/vim-tmux-navigator',
  {
    'janko-m/vim-test',
    keys = {
      { "<leader>sf", ":TestFile<CR>" },
      { "<leader>ss", ":TestNearest<CR>" },
      { "<leader>sl", ":TestLast<CR>" },
      { "<leader>sg", ":TestVisit<CR>" },
    },
    config = function()
      vim.g["test#strategy"] = "dispatch"
      vim.g["test#preserve_screen"] = 1
    end,
  },
  {
    'nvim-neotest/neotest',
    lazy = true,
    dependencies = {
      'nvim-neotest/neotest-vim-test',
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vim-test")({ ignore_file_types = {} }),
        },
      })
    end
  },
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'AndrewRadev/splitjoin.vim',
  'junegunn/fzf',
  {
    'junegunn/fzf.vim',
    build = function()
      vim.cmd("fzf#install()")
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufWinEnter",
    keys = {
      { "<leader>hi", ":Gitsigns preview_hunk<CR>", desc = "Preview Git Hunk" },
      { "<leader>hu", ":Gitsigns reset_hunk<CR>",   desc = "Reset Hunk" },
      { "<leader>hn", ":Gitsigns next_hunk<CR>",    desc = "Go to next hunk" },
      { "<leader>hN", ":Gitsigns prev_hunk<CR>",    desc = "Go to prev hunk" },
      { "<leader>hs", ":Gitsigns stage_hunk<CR>",   desc = "Stage hunk" },
      { "<leader>hb", ":Gitsigns blame_line<CR>",   desc = "Blame line" },
    },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        },
        numhl = true,
      }
      )
    end
  },
  'stevearc/dressing.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    'mileszs/ack.vim',
    keys = {
      { "<leader>a", ":Ack! ", desc = "Ack" },
    },
  },
  'christoomey/vim-system-copy',
  'qpkorr/vim-bufkill',
  'folke/neodev.nvim',
  -- 'alok/notational-fzf-vim',
  'sindrets/diffview.nvim',
  {
    'ellisonleao/carbon-now.nvim',
    lazy = true,
    config = function()
      local carbon = require('carbon-now')
      carbon.setup({
        use_reg = "+",
        -- open_cmd="",
        open_cmd = "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
        options = {
          theme = "material",
          -- font_size = "14px",
          font_family = "",
          font_size = "",
          bg = "white",
          titlebar = "",
          drop_shadow = true,
          window_theme = "",
          line_numbers = false,
          line_height = "",
          watermark = false,
          width = "",
        }
      })
    end
  },
  {
    'itchyny/lightline.vim',
    dependencies = {
      'tpope/vim-fugitive',
    },
    config = function()
      vim.cmd([[
    let g:lightline = {
          \ 'component': {
          \   'lineinfo': "\ %3l\xee\xaa\x9d\xee\xaa\x9f%-2v%<",
          \ },
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'currentfunction', 'lsp_diagnostic_hints', 'readonly', 'is_modified', 'filename' ] ],
          \   'right': [ [ 'lineinfo' ],
          \              [ 'filetype' ],
          \              [ 'fugitive' ],
          \              [ 'macro' ] ]
          \ },
          \ 'component_function': {
          \   'readonly': 'LightlineReadonly',
          \   'is_modified': 'LightlineModified',
          \   'fugitive': 'LightlineFugitive',
          \   'currentfunction': 'CocCurrentFunction',
          \   'lsp_diagnostic_hints': 'LspHints',
          \   'filename': 'Filename',
          \   'macro': 'Macro'
          \ },
          \ 'subseparator': { 'left': "\xee\x82\xb9", 'right': "\xee\x82\xbb" },
          \ 'separator' : { 'left': "\xee\x82\xb8", 'right': "\xee\x82\xba" },
          \ }

    function! Macro()
    return ""
      " if ! luaeval("require('noice').api.statusline.mode.has()")
      "   return ""
      " endif
      " return luaeval("require('noice').api.statusline.mode.get()")
    endfunction

    function! LightlineModified()
      return &modified ? "\xee\x89\x80" : ''
    endfunction

    function! LightlineReadonly()
      return &readonly ? '' : ''
    endfunction

    function! LightlineFugitive()
      if ! FugitiveIsGitDir()
        return 'not in git'
      endif
      let branch = FugitiveHead()
      return branch !=# '' ? ' '.branch : FugitiveStatusline()
    endfunction

    function! Filename()
      let file = expand("%:f")
      if file[0:5] == "jdt://"
        return split(file, "?")[0]
      endif
      return file
    endfunction

    set noshowmode " don't show mode at the bottom as it is displayed in lightline
    ]])
    end
  },

  {
    'jpalardy/vim-slime',
    lazy = true,
    config = function()
      vim.cmd([[
      let g:slime_target="tmux"
      let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.2"}

      nmap <leader>cc <Plug>SlimeParagraphSend
      ]])
    end,
  },
  {
    'sbdchd/neoformat',
    config = function()
      vim.g.neoformat_enabled_python = { "black", "isort" }
      vim.g.neoformat_enabled_json = { "prettier" }
      vim.g.neoformat_enabled_csharp = { "csharpier" }
      vim.g.neoformat_run_all_formatters = 1
    end,
  },
}
