local M = {}

local utils = require('config.utils')

local function manual_sonarlint_configuration()
  if not utils.has_plug('sonarlint.nvim') then
    return
  end
  -- manual installation. come back later to check if we can use mason to install it
  require('sonarlint').setup({
    -- server = {
    --   -- Basic command to start sonarlint-language-server. Will be enhanced with additional command line options
    --   cmd = {
    --     "java", "-jar", "/home/gverger/bin/sonarlint/sonarlint-language-server-2.17.0-SNAPSHOT.jar",
    --     "-stdio",
    --     "-analyzers",
    --     "/home/gverger/bin/sonarlint/plugins/sonarpython.jar",
    --     "/home/gverger/bin/sonarlint/plugins/sonarjava.jar",
    --   }
    -- },
    server = {
    cmd = {
         'sonarlint-language-server',
         -- Ensure that sonarlint-language-server uses stdio channel
         '-stdio',
         '-analyzers',
         -- paths to the analyzers you need, using those for python and java in this example
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
      },
    },

    filetypes = { 'python', 'java' }
  })
end



function M.setup()
  manual_sonarlint_configuration()

  if not utils.has_plug('nvim-lspconfig') then
    vim.notify('nvim-lspconfig plugin not installed')
    return
  end

  local neodev = require('neodev')

  if neodev then
    neodev.setup {
      override = function(_, library)
        library.enabled = true
        library.plugins = true
      end,
    }
  end


  local lspconfig = require 'lspconfig'


  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  --
  -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local on_attach = function(client, bufnr)
    require('config.lsp.codelens').on_attach(client, bufnr)
    vim.cmd([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorMoved,CursorMovedI,BufHidden,InsertEnter,InsertCharPre,WinLeave <buffer> lua vim.lsp.buf.clear_references()
    " autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    augroup end
    ]])
  end

  -- LSP servers that only need the default configuration
  local simple_lsps = {
    lspconfig.azure_pipelines_ls,
    lspconfig.bashls,
    lspconfig.ccls,
    lspconfig.docker_compose_language_service,
    lspconfig.dockerls,
    lspconfig.esbonio,
    lspconfig.groovyls,
    lspconfig.marksman,
    lspconfig.mosel,
    lspconfig.rnix,
    lspconfig.ruby_ls,
    lspconfig.rust_analyzer,
    lspconfig.sourcery,
    lspconfig.tailwindcss,
    lspconfig.tsserver,
    lspconfig.vimls,
  }

  for _, server in pairs(simple_lsps) do
    server.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- Take care of Poetry: if this is a poetry project, pyright should be a dependency
  local pyright_cmd = lspconfig.pyright.cmd

  if utils.file_readable("poetry.lock") then
    pyright_cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
  end

  lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = pyright_cmd,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
        },
      },
      pyright = {
        disableOrganizeImports = false,
      }
    }
  }

  local root_files = {
    -- Single-module projects
    {
      '.vim-workspace',
    },
    {
      '*.sln',
      '.git',
    },
  }

  local root_directory = function()
    local fname = vim.fn.getcwd()
    for _, patterns in ipairs(root_files) do
      local root = lspconfig.util.root_pattern(unpack(patterns))(fname)
      if root then
        return root
      end
    end
  end

  lspconfig.csharp_ls.setup {
    cmd = { "/home/gverger/bin/csharp-ls" },
    -- filetypes = { "cs", "csharp" },
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = root_directory,
  }

  lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'gopls', '--remote=auto' },
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
    -- root_dir = lspconfig.util.root_pattern('.vim-go-workspace') or lspconfig.util.root_pattern('.git'),
    root_dir = function(fname)
      local util = lspconfig.util
      local function workspace(path)
        if util.path.is_file(util.path.join(path, '.vim-go-workspace')) then
          return path
        end
      end
      return util.search_ancestors(fname, workspace) or util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
  }

  lspconfig.solargraph.setup {
    flags = {
      debounce_text_changes = 150,
    },
    on_attach = on_attach,
    settings = {
      solargraph = {
        useBundler = true,
      }
    },
    capabilities = capabilities
  }

  -- lspconfig.sorbet.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities
  -- }

  lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        -- runtime = { -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        --   version = 'LuaJIT',
        -- },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  lspconfig.lemminx.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      formatting = {
        insertSpaces = true,
        tabSize = 4,
      }
    },
    settings = {
      xml = {
        format = {
          enabled = true,
        }
      }
    }
  }

  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      json = {
        schemas = vim.list_extend(
          {
            {
              description = "Disaggregation SIME input",
              fileMatch = { "**/disaggregation/**/input.json" },
              name = "disaggregation-input.json",
              url = "/home/gverger/artelys/sime-dataformat/schemas/mari-disaggregation.input.schema.json"
            }
          }, require('schemastore').json.schemas()),
        validate = { enable = true },
      }
    }
  }
end

return M
