local M = {}

function M.setup()
  vim.cmd([[
    set encoding=utf-8
    set ambiwidth=single

    set t_ut=                " fix 256 colors in tmux http://sunaku.github.io/vim-256color-bce.html

    if has("termguicolors")  " set true colors
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
    colorscheme melange
  ]])
end

return M
