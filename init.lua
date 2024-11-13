vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Lazy initialization
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
  {
    spec = "plugins",
    change_detection = {
      enabled = false,
      notification = false
    }
  }
)

vim.g.shortmess = "aFW" -- short messages + do not show file name when switching to the file
vim.g.ackprg = 'rg --vimgrep -M 1000 --max-columns-preview'

local set = vim.opt

set.updatetime = 101
set.tags = ".tags/tags,.git/tags,tags;"
set.grepprg = "rg --nogroup --nocolor"
set.backup = false
set.swapfile = false
set.tw = 99
set.synmaxcol = 1000
set.redrawtime = 10000
set.conceallevel = 2
set.backspace = "indent,eol,start"
set.expandtab = true
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.wildmode = "list:longest"
set.number = true
set.relativenumber = false
set.cursorline = true
set.spell = false
set.tagrelative = false
set.exrc = true -- use local vimrc files
set.completeopt = { "menu", "menuone", "noselect" }
set.foldenable = false
vim.cmd [[
augroup MyComments
  autocmd!
  " Don't automatically continue comments after newline
  autocmd BufNewFile,BufRead * setlocal formatoptions-=o
augroup end
]]

-- vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { noremap = true })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<esc>:w<CR>', { noremap = true })

-- vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
-- vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
-- vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
-- vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })

-- Move selected lines up or down
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true })
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true })

-- Not sure it is useful. Disabling it for now
-- vim.g.vim_markdown_frontmatter = 1
-- vim.g.vim_markdown_folding_disabled = 1
-- vim.g.vim_markdown_new_list_item_indent = 2
-- vim.g.markdown_fenced_languages = { "python", "json", "ruby", "bash" }

require('config').setup()

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.mos" },
  callback = function(ev)
    set.filetype = "mosel"
  end
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.props" },
  callback = function(ev)
    set.filetype = "xml"
  end
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "appsettings.*.model" },
  callback = function(ev)
    set.filetype = "json"
  end
})

-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--   callback = function(args)
--     if vim.fn.mode() == "i" then
--       vim.notify("tokens received")
--     end
--   end,
-- })
