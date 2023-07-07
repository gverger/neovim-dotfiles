set shell=/bin/bash

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  " set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Required:
call plug#begin('~/.vim/plug/')
Plug 'dstein64/vim-startuptime'

Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-rhubarb' " github extension to fugitive
Plug 'tpope/vim-eunuch' " :Delete, :Rename
Plug 'tpope/vim-projectionist'
Plug 'jeetsukumaran/vim-filebeagle' " File explorer
" Plug 'vim-scripts/tComment' " Comment code
Plug 'numToStr/Comment.nvim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tmhedberg/matchit'
Plug 'sickill/vim-pasta' " Correct indentation with pasting
Plug 'tpope/vim-dispatch'
Plug 'christoomey/vim-tmux-navigator'
Plug 'janko-m/vim-test'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-vim-test'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'sbdchd/neoformat'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'stevearc/dressing.nvim' " windows instead of vim input at the bottom
Plug 'nvim-tree/nvim-web-devicons'
" Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

Plug 'lukas-reineke/lsp-format.nvim'
Plug 'mileszs/ack.vim'
Plug 'christoomey/vim-system-copy'
Plug 'qpkorr/vim-bufkill'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'folke/neodev.nvim'
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Plug 'gfanto/fzf-lsp.nvim'
Plug 'https://gitlab.com/schrieveslaach/sonarlint.nvim'

Plug 'alok/notational-fzf-vim'

" Navigation
Plug 'unblevable/quick-scope'
Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-line'
Plug 'thinca/vim-textobj-between'
Plug 'Julian/vim-textobj-variable-segment', { 'branch': 'main' }
" Plug 'b4winckler/vim-angry' " argument text objects

" Languages
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'chrisbra/csv.vim'
Plug 'LnL7/vim-nix'
Plug 'mfussenegger/nvim-jdtls'
Plug 'mfussenegger/nvim-lint'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'b0o/schemastore.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }

" Themes
" Plug 'nanotech/jellybeans.vim'
" Plug 'morhetz/gruvbox'
" Plug 'ellisonleao/gruvbox.nvim'
" Plug 'vim-scripts/xoria256.vim'
" Plug 'zcodes/vim-colors-basic'
" Plug 'sam4llis/nvim-tundra'
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Plug 'Shatur/neovim-ayu'
Plug 'savq/melange'

Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'

" Plug 'ryanoasis/vim-devicons' " Always load the vim-devicons as the very last one.

" Completion https://github.com/hrsh7th/nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'rcarriga/cmp-dap'

" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/vim-vsnip-integ'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'
Plug 'fico-xpress/mosel-vim-plugin'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'

Plug 'sindrets/diffview.nvim'

Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

" Pick one at some point
Plug 'nvim-neorg/neorg'
Plug 'nvim-orgmode/orgmode'

" Fixes a bug with CursorHold
" Plug 'antoinemadec/FixCursorHold.nvim'

Plug 'jpalardy/vim-slime', { 'branch': 'main' } " C-c C-c to send text to terminal

Plug 'ellisonleao/carbon-now.nvim'
call plug#end()

let mapleader=" "

function! HasPlug(name)
  let found = has_key(g:plugs, a:name)
  if ! found
    echo "Not installed : " . a:name
  endif
  return found
endfunction


"
" PLUGIN vim-slime
if HasPlug("vim-slime")
  if exists('$TMUX')
    let g:slime_target="tmux"
    let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.2"}

    nmap <leader>cc <Plug>SlimeParagraphSend
  endif
endif

" PLUGIN Neoformat
if HasPlug("neoformat")
  let g:neoformat_enabled_python = ['black', 'isort']
  let g:neoformat_enabled_json = ['prettier']
  let g:neoformat_enabled_csharp = ['csharpier']
  let g:neoformat_run_all_formatters = 1


  nnoremap <leader>fl V:Neoformat<CR>==
  nnoremap <leader>ff :Neoformat<CR>
endif

" set shortmess+=c
set shortmess=aF " short messages + do not show file name when switching to the file


if HasPlug("LuaSnip")
lua <<EOF
  local ls = require('luasnip')

  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.expandable() then
      ls.expand()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set({ "i" }, "<c-h>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })

  require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})
  require("luasnip.loaders.from_vscode").lazy_load() -- for friendly-snippets

  vim.keymap.set({ "n" }, "<leader><leader>s", function()
    require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})
    require("luasnip.loaders.from_vscode").lazy_load() -- for friendly-snippets
  end)

  vim.keymap.set({ "n" }, "<leader>se", require("luasnip.loaders").edit_snippet_files)

  local types = require("luasnip.util.types")

  ls.setup({
    update_events = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = {{"<-- choose (<c-h>)", "Comment"}},
          hl_group = "GitSignsChangeLn",
        },
      },
    },
    ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
--    load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
--      markdown = {"lua", "json", "mermaid", "ruby", "python", "bash", "java"}
--    })
  })
  -- ls.filetype_set("cs", { "csharp" })

EOF
endif

" Navigation quick-scope
if HasPlug("quick-scope")
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
endif


if HasPlug("lightline.vim")
  let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'component': {
        \   'lineinfo': ' %3l:%-2v',
        \   'filename': '%f'
        \ },
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'currentfunction', 'lsp_diagnostic_hints', 'readonly', 'modified', 'filename' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'filetype' ],
        \              [ 'fugitive' ]]
        \ },
        \ 'component_function': {
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \   'currentfunction': 'CocCurrentFunction',
        \   'lsp_diagnostic_hints': 'LspHints',
        \   'filename': 'Filename'
        \ },
        \ 'subseparator': { 'left': '|', 'right': '|' }
        \ }

  function! LightlineReadonly()
    return &readonly ? '' : ''
  endfunction

  function! LightlineFugitive()
    if exists('*fugitive#head')
      let branch = fugitive#head()
      return branch !=# '' ? ' '.branch : ''
    endif
    return ''
  endfunction

  function! Filename()
    let file = expand("%:f")
    if file[0:5] == "jdt://"
      return split(file, "?")[0]
    endif
    return file
  endfunction

  set noshowmode " don't show mode at the bottom as it is displayed in lightline
endif

set guifont=Roboto\ Mono\ for\ Powerline:h12

if HasPlug('Comment.nvim')
lua <<COMMENT
require('Comment').setup()
COMMENT
endif

" Notational Velocity
if HasPlug("notational-fzf-vim")
  " nnoremap <leader>n :NV!<CR>
  nnoremap <leader>org :e ~/notes/organisation.md<CR>
  let g:nv_search_paths= ['~/org']
  let g:nv_default_extension = '.org'
  let g:nv_create_note_key = 'ctrl-x'
endif

" Ag
nmap <Leader>a :Ack! 

set updatetime=100

" Signify
if HasPlug("gitsigns.nvim")

  lua << GITSIGN
  require('gitsigns').setup({
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    numhl = true,
  }
  )
GITSIGN
  nmap <leader>hi :Gitsigns preview_hunk<CR>
  nmap <leader>hu :Gitsigns reset_hunk<CR>
  nmap <leader>hn :Gitsigns next_hunk<CR>
  nmap <leader>hN :Gitsigns prev_hunk<CR>
  nmap <leader>hs :Gitsigns stage_hunk<CR>
  nmap <leader>hb :Gitsigns blame_line<CR>
endif

" Git commands
if HasPlug("vim-fugitive")
  nmap <leader>gs :Git<CR>

  let g:fugitive_gitlab_domains = ['https://gitlab.artelys.com']
endif

" Tests
if HasPlug("vim-test")
  nmap <leader>sf :TestFile<CR>
  nmap <leader>ss :TestNearest<CR>
  nmap <leader>sl :TestLast<CR>
  nmap <leader>sg :TestVisit<CR>
  let test#strategy = "dispatch"
  let g:test#preserve_screen = 1
endif

if HasPlug("neotest")
lua<<NEOTEST
require("neotest").setup({
  adapters = {
  require("neotest-vim-test")({ignore_file_types = {}}),
  },
})
NEOTEST
endif

set tags=.tags/tags,.git/tags,tags;

if executable('rg')
  set grepprg=rg\ --nogroup\ --nocolor
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy/<C-R><C-R>=substitute(
      \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy?<C-R><C-R>=substitute(
      \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
" :set incsearch
:set hlsearch

nnoremap <CR> :noh<CR><CR>

" nnoremap q: :q

augroup MyColors
  autocmd!

  " autocmd ColorScheme * highlight CursorLine cterm=NONE ctermbg=darkgrey gui=NONE guibg=254
  " autocmd ColorScheme * highlight CursorLine cterm=undercurl guibg=NONE gui=underline

  autocmd ColorScheme * highlight ColorColumn ctermbg=darkgrey guibg=darkgrey
  autocmd BufWinEnter * syntax match ExtraWhitespace /\s\+$/

  autocmd ColorScheme * hi NormalFloat guibg=#292522
  autocmd ColorScheme * hi FloatBorder guibg=#292522 guifg=#915245
  autocmd ColorScheme * hi Comment gui=NONE " disable italics in comments
  autocmd ColorScheme * hi String gui=NONE " disable italics in Strings

  autocmd ColorScheme * hi clear SignColumn
  autocmd ColorScheme * hi link GitSignsChange Function  " GitSignsChange has a blue background
  autocmd ColorScheme * hi DiffDelete guifg=NONE
  autocmd ColorScheme * hi clear Folded
  autocmd ColorScheme * hi link Folded Comment
augroup end

set nobackup
set noswapfile

" execute "set colorcolumn=" . 100
set tw=99
" call matchadd('ColorColumn', '\%101v', -100)

" Syntax coloring lines that are too long just slows down the world
" set synmaxcol=10000
set synmaxcol=1000
" Large files not being colored well (default is 2000)
set redrawtime=10000


" Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Markdown
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:markdown_fenced_languages = [ "python", "json", "ruby", "bash" ]
set conceallevel=2

autocmd BufNewFile,BufReadPost *.mmd,*.mermaid set filetype=mermaid

set backspace=indent,eol,start
syntax on             " Enable syntax highlighting
filetype plugin indent on    " Enable filetype-specific plugins
set hidden            " don't need to save buffer before changing
set ffs=unix

set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
" set wildmenu
set wildmode=list:longest

set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Fast scrolling in terminal
set ttyfast
" set lazyredraw "" DISABLED to use Noice
set number
set nocursorline
set nospell
" Disabling this since I don't remember what it does and it slows RST files down too much
" set regexpengine=1

set notagrelative

set mouse=a

" fzf
if HasPlug("fzf.vim")
  " nnoremap <leader>rl :GFiles --exclude-standard --others --cached<CR>
  " nnoremap <leader>rf :Files<CR>
  " nnoremap <leader>bl :Buffers<CR>
  " nnoremap <leader>hl :History<CR>
  " nnoremap <leader>l :BLines<CR>
  " nnoremap <leader>j :BTags<CR>
  " nnoremap <leader>t :Tags<CR>

  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
endif

" Rg or Ag instead of Ack
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Indent html tags
let g:html_indent_inctags = "html,body,head,thead,tbody,p"

" Use local vimrc in folders
set exrc

augroup MyComments
  autocmd!
  " Don't automatically continue comments after newline
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
augroup end

nmap k gk
nmap j gj
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

" LSP

" completion

set completeopt=menu,menuone,noselect

if HasPlug("nvim-cmp")
lua <<EOF

  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local ls = require('luasnip')

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      or require("cmp_dap").is_dap_buffer()
    end,
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
      },

    snippet = {
      expand = function(args)
         -- vim.fn["vsnip#anonymous"](args.body)
         ls.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<C-l>'] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'path', },
      { name = 'orgmode' },
    }, {
      { name = 'buffer',
        option = {
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end
        },
      },
    }),
   formatting = {
     format = require'lspkind'.cmp_format({
       mode = "symbol_text",
       menu = ({
         buffer = "[buf]",
         nvim_lsp = "[lsp]",
         luasnip = "[snip]",
         nvim_lua = "[lua]",
         path = "[path]",
         orgmode = "[org]",
         nvim_lsp_signature_help = "[sig]",
       })
     }),
   },
--    formatting = {
--      format = require'lspkind'.cmp_format({with_text = false }),
--    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'buffer' },
      { name = 'path' },
      { name = 'cmdline' }
    })
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    }
  })

  cmp.setup.filetype({'dap-repl', 'dapui_watches', 'dapui_hover'}, {
    sources = {
      { name = 'dap' }, -- You can specify the `cmp_git` source if you were installed it.
    },
  })

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice", { silent = true })
EOF
endif

" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
" highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
" highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4


nnoremap <silent><c-]> <cmd> lua vim.lsp.buf.definition()<CR>
nnoremap <silent><c-$> <cmd> lua vim.lsp.buf.definition()<CR>
nnoremap <silent><leader>rn <cmd> lua vim.lsp.buf.rename()<CR>
nnoremap <silent>K <cmd> lua vim.lsp.buf.hover()<CR>
nnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.code_action()<CR>
vnoremap <silent><leader>ch <cmd> lua vim.lsp.buf.range_code_action()<CR>

if HasPlug("markdown-preview.nvim")
  let g:mkdp_markdown_css = expand('~/notes/mermaid.css')
  let g:mkdp_refresh_slow = 1
endif

lua << CUSTOM_CONFIG
  require('config').setup()
CUSTOM_CONFIG

lua << CARBONNOW
local carbon = require('carbon-now')
carbon.setup({
  use_reg="+",
  -- open_cmd="",
  open_cmd="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
  options = {
    theme = "material",
    -- font_size = "14px",
    font_family="",
    font_size="",
    bg="white",
    titlebar="",
    drop_shadow=true,
    window_theme="",
    line_numbers=false,
    line_height = "",
    watermark = false,
    width = "",
  }
})
CARBONNOW
