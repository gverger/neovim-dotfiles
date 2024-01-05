return {
  -- 'unblevable/quick-scope',
  {
    'Julian/vim-textobj-variable-segment',
    dependencies = {
      'thinca/vim-textobj-between',
    },
  },
  {
    'thinca/vim-textobj-between',
    dependencies = {
      'kana/vim-textobj-user',
    },
  },
  {
    'ggandor/leap.nvim',
  },
}
