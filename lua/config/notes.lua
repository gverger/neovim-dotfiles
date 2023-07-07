local M = {}

local utils = require('config.utils')

local function setup_neorg()
  if not utils.has_plug('neorg') then
    vim.notify("neorg is not installed")
    return
  end
  require('neorg').setup {
    load = {
      ["core.defaults"] = {},  -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.dirman"] = {      -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/norg/notes",
            entretiens = "~/norg/entretiens"
          },
          default_workspace = "notes",
        },
      },
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.keybinds"] = {
        config = {
          hook = function(keybinds)
            keybinds.map_event("norg", "i", "<M-O>", "core.itero.previous-iteration")
            keybinds.map_event("norg", "i", "<M-o>", "core.itero.next-iteration")
          end,
        }
      },
    },
  }
end

local function setup_orgmode()
  if not utils.has_plug('orgmode') then
    vim.notify("orgmode is not installed")
    return
  end

  local orgmode = require('orgmode')

  orgmode.setup_ts_grammar()
  -- vim.b.org_template = {}

  orgmode.setup {
    org_agenda_files = "~/org/**/*",
    org_default_notes_file = "~/org/refile.org",
    win_split_mode = "tabnew",
    org_todo_keywords = { 'TODO(t)', 'STARTED(s)', 'WAITING(w)', 'BLOCKED(b)', '|', 'DONE(d)' },
    org_todo_keyword_faces = {
      DONE = ':foreground green',
      BLOCKED = ':foreground orange',
      STARTED = ':foreground lightblue',
    },
  }
  utils.noremap("n", "<leader>n", ':Telescope find_files search_dirs={"~/norg"} path_display={"truncate"} <CR>')
end

function M.setup()
  setup_neorg()
  setup_orgmode()
end

return M
