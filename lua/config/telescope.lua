local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('telescope.nvim') then
    vim.notify('telescope.nvim plugin not installed')
    return
  end

  local actions = require("telescope.actions")
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
      preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = { 'png', 'jpg' } -- Supported image formats
            local split_path = vim.split(filepath:lower(), '.', { plain = true })
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. '\r\n')
              end
            end
            vim.fn.jobstart(
              {
                'ascii-image-converter', '-b', '--dither', '-C', filepath
              },
              { on_stdout = send_output, stdout_buffered = true, pty = true })
          else
            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          end
        end
      },
      dynamic_preview_title = true,
      disable_devicons = false,
      path_display = { "truncate" },
    },
    windblend = 50,
    pickers = {
      buffers = {
        sort_mru = true,
        ignore_current_buffer = true,
      },
      tags = {
        only_sort_tags = true,
        show_line = false,
        layout_strategy = 'vertical',
        path_display = { "tail" },
      },
      current_buffer_fuzzy_find = {
        layout_strategy = 'vertical'
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown()
      }
    }
  }
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')

  -- utils.noremap("n", "<leader>rl", ':Telescope git_files<CR>')
  -- utils.noremap("n", "<leader>rf", ':Telescope find_files<CR>')
  -- utils.noremap("n", "<leader>ra", ':Telescope grep_string<CR>')
  -- utils.noremap("n", "<leader>bl", ":Telescope buffers<CR>")
  -- utils.noremap("n", "<leader>hl", ":Telescope oldfiles<CR>")
  -- utils.noremap("n", "<leader>l", ":Telescope current_buffer_fuzzy_find<CR>")
  -- utils.noremap("n", "<leader>j", ":Telescope lsp_document_symbols<CR>")
  -- utils.noremap("n", "<leader>rh", ':Telescope resume<CR>')

  utils.noremap("n", "<leader>gr", ":Telescope lsp_references<CR>")
  utils.noremap("n", "<leader>gd", ":Telescope lsp_definitions<CR>")
  utils.noremap("n", "<leader>gi", ":Telescope lsp_implementations<CR>")

  utils.noremap("n", "<leader>tg", ':Telescope git_files<CR>')
  utils.noremap("n", "<leader>tf", ':Telescope find_files<CR>')
  utils.noremap("n", "<leader>ta", ':Telescope grep_string<CR>')
  utils.noremap("n", "<leader>ts", ':Telescope git_status<CR>')
  utils.noremap("n", "<leader>tb", ":Telescope buffers<CR>")
  utils.noremap("n", "<leader>th", ":Telescope oldfiles<CR>")
  utils.noremap("n", "<leader>tl", ":Telescope current_buffer_fuzzy_find<CR>")
  utils.noremap("n", "<leader>tj", ":Telescope lsp_document_symbols<CR>")
  utils.noremap("n", "<leader>tt", ":Telescope tags<CR>")
  utils.noremap("n", "<leader>tr", ':Telescope resume<CR>')
  utils.noremap("n", "<leader>tq", ":Telescope quickfix<CR>")

  utils.noremap("n", "<leader>n",
    ':Telescope find_files search_dirs={"~/norg/notes","~/notes"} path_display={"truncate"} <CR>')
  utils.noremap("n", "<leader>tn",
    ':Telescope grep_string only_sort_text=true search_dirs={"~/norg/notes","~/notes"} shorten_path=true search=""<CR>')
end

return M
