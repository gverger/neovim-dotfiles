local M = {}

local utils = require('config.utils')

local function manual_sonarlint_configuration()
  if not utils.has_plug('sonarlint.nvim') then
    return
  end
  -- manual installation. come back later to check if we can use mason to install it
  require('sonarlint').setup({
    server = {
      cmd = {
        'sonarlint-language-server',
        -- Ensure that sonarlint-language-server uses stdio channel
        '-stdio',
        '-analyzers',

        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),

        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarlintomnisharp.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonariac.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar")
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonartext.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
      },
    },

    filetypes = {
      'java',
      -- 'python',
      -- 'cpp',
      -- 'go',
    },
  })
end



function M.setup()
  if not utils.has_plug('nvim-lspconfig') then
    vim.notify('nvim-lspconfig plugin not installed')
    return
  end

  -- local neodev = require('neodev')
  --
  -- if neodev then
  --   neodev.setup {
  --     override = function(_, library)
  --       library.enabled = true
  --       library.plugins = true
  --     end,
  --     library = {
  --       plugins = { "nvim-dap-ui", types = true },
  --     }
  --   }
  -- end



  local capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  )
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

  -- trying this as some lsps are very slow at the moment (june 2024)
  -- https://www.reddit.com/r/neovim/comments/161tv8l/lsp_has_gotten_very_slow/

  local function on_attach(client, bufnr)
    -- don't use codelens yet python lsp doesn't execute any of them
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
  -- local simple_lsps = {
  --   lspconfig.bashls,
  --   lspconfig.cmake,
  --   lspconfig.cssls,
  --   lspconfig.docker_compose_language_service,
  --   lspconfig.dockerls,
  --   lspconfig.dotls,
  --   lspconfig.esbonio,
  --   -- lspconfig.groovyls,
  --   -- lspconfig.harper_ls,
  --   lspconfig.marksman,
  --   lspconfig.nil_ls,
  --   -- lspconfig.pylsp,
  --   lspconfig.ruff,
  --   -- lspconfig.rnix,
  --   lspconfig.ruby_lsp,
  --   lspconfig.rust_analyzer,
  --   lspconfig.tailwindcss,
  --   lspconfig.taplo,
  --   -- lspconfig.typos_lsp,
  --   lspconfig.ts_ls,
  --   lspconfig.vimls,
  --   lspconfig.zls,
  -- }
  --
  -- for _, server in pairs(simple_lsps) do
  --   server.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --   }
  -- end

  vim.lsp.config('*', {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("bashls")
  vim.lsp.enable("cmake")
  vim.lsp.enable("dotls")
  vim.lsp.enable("nil_ls")
  vim.lsp.enable("ruby_lsp")
  vim.lsp.enable("ruff")

  -- not sure why I need to repeat the config here
  vim.lsp.config('clangd', {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable("clangd")

  if utils.file_readable("poetry.lock") then
    vim.lsp.config("basedpyright", {
      cmd = { "poetry", "run", "basedpyright-langserver", "--stdio" },
    })
  elseif utils.file_readable("uv.lock") then
    vim.lsp.config("basedpyright", {
      cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
    })
  end

  vim.lsp.enable("basedpyright")

  -- vim.lsp.config("gopls", {
  --   cmd = { 'gopls', '--remote=auto' },
  --   settings = {
  --     gopls = {
  --       analyses = { unusedparams = true },
  --       staticcheck = true,
  --     },
  --   },
  -- })
  vim.lsp.config('gopls', {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  })
  vim.lsp.enable("gopls")

  vim.fn.setenv("JAVA_HOME", "/home/gverger/.asdf/installs/java/temurin-21.0.0+35.0.LTS/")
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = '/home/gverger/.local/share/jdtls-workspace/' .. project_name

  local root_files = {
    -- Single-module projects
    {
      '.vim-workspace',
    },
    {
      'build.xml',           -- Ant
      'pom.xml',             -- Maven
      'settings.gradle',     -- Gradle
      'settings.gradle.kts', -- Gradle
    },
    -- Multi-module projects
    { 'build.gradle', 'build.gradle.kts' },
  }

  -- local function root_directory()
  --   local fname = vim.fn.getcwd()
  --   for _, patterns in ipairs(root_files) do
  --     local root = lspconfig.util.root_pattern(unpack(patterns))(fname)
  --     if root then
  --       return root
  --     end
  --   end
  -- end
  --
  vim.lsp.config("jdtls", {
    cmd = { '/home/gverger/.local/share/nvim/mason/bin/jdtls', '-data', workspace_dir, '--jvm-arg=-Dlog.level=ALL', '--jvm-arg=-Dlog.protocol=true' },
    root_markers = root_files,
  })
  vim.lsp.enable("jdtls")

  -- Try to mark autobuild off, and compile on save, but too many problems
  -- vim.api.nvim_create_autocmd("BufWritePost", {
  --   -- on save, compile the project
  --   -- Need to wait 100ms (experimental) so that the LSP has time to understand the file changed
  --   -- or it will compile without the changes
  --   pattern = "*.java",
  --   callback = function()
  --     vim.defer_fn(function()
  --       vim.cmd("Trouble close")
  --       require("jdtls").compile("incremental", function(items)
  --         if items and #items > 0 then
  --           vim.cmd("Trouble qflist open")
  --         end
  --       end)
  --     end, 100)
  --   end,
  -- })

  -- local root_files = {
  --   -- Single-module projects
  --   {
  --     '.vim-workspace',
  --   },
  --   {
  --     '*.sln',
  --     '.git',
  --   },
  -- }

  -- lspconfig.omnisharp.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   handlers = {
  --     ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
  --     ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
  --     ["textDocument/references"] = require('omnisharp_extended').references_handler,
  --     ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
  --   },
  --   settings = {
  --     cake = {
  --       enabled = false,
  --     },
  --     script = {
  --       enabled = false,
  --     },
  --     FormattingOptions = {
  --       EnableEditorConfigSupport = true,
  --       OrganizeImports = true,
  --     },
  --     RoslynExtensionsOptions = {
  --       enableAnalyzersSupport = true,
  --       enableImportCompletion = true,
  --       enableDecompilationSupport = true,
  --       inlayHintsOptions = {
  --         enableForParameters = false,
  --         forLiteralParameters = true,
  --         forIndexerParameters = true,
  --         forObjectCreationParameters = true,
  --         forOtherParameters = true,
  --         suppressForParametersThatDifferOnlyBySuffix = false,
  --         suppressForParametersThatMatchMethodIntent = false,
  --         suppressForParametersThatMatchArgumentName = false,
  --         enableForTypes = false,
  --         forImplicitVariableTypes = true,
  --         forLambdaParameterTypes = true,
  --         forImplicitObjectCreation = true
  --       },
  --     },
  --   },
  -- }
  --
  -- lspconfig.gopls.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   cmd = { 'gopls', '--remote=auto' },
  --   settings = {
  --     gopls = {
  --       analyses = { unusedparams = true },
  --       staticcheck = true,
  --     },
  --   },
  --   -- root_dir = lspconfig.util.root_pattern('.vim-go-workspace') or lspconfig.util.root_pattern('.git'),
  --   root_dir = function(fname)
  --     local util = lspconfig.util
  --     local function workspace(path)
  --       if util.path.is_file(util.path.join(path, '.vim-go-workspace')) then
  --         return path
  --       end
  --     end
  --     return util.search_ancestors(fname, workspace) or util.find_git_ancestor(fname) or vim.loop.os_homedir()
  --   end,
  -- }
  --

  -- lspconfig.sorbet.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities
  -- }

  vim.lsp.config("lua_ls", {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          -- version = 'LuaJIT'
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          -- library = {
          -- vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
          -- }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
          library = vim.api.nvim_get_runtime_file("", true)
        },
        hint = {
          enable = true,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      })
    end
  })

  vim.lsp.config("lemminx", {
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
          maxLineWidth = 200,
          preserveAttributeLineBreaks = false,
          preservedNewlines = 2,
          spaceBeforeEmptyCloseTag = true,
        },
      },
    },
  })
  vim.lsp.enable("lemminx")

  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas {
          extra = {
            {
              description = "Disaggregation SIME input",
              fileMatch = { "**/disaggregation/**/input.json" },
              name = "disaggregation-input.json",
              url = "/home/gverger/artelys/sime-dataformat/schemas/mari-disaggregation.input.schema.json"
            },
            {
              description = "Devbox schema",
              fileMatch = { "devbox.json" },
              name = "devbox.schema.json",
              url = "https://raw.githubusercontent.com/jetpack-io/devbox/main/.schema/devbox.schema.json",
            },
            -- {
            --   description = "Sherpa configuration",
            --   fileMatch = { "/home/gverger/syleps/HeterogeneousPalletizing/**/appsettings*.{json,model,jsonc}" },
            --   name = "sherpa.schema.json",
            --   url = "/home/gverger/.config/custom/sherpa-config-schema.json"
            -- },
          }
        },
        validate = { enable = true },
      }
    }
  })
  vim.lsp.enable("jsonls")

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemas = {
          ["/home/gverger/.config/custom/itools-config-schema.json"] = { "*/.itools/config.yml", "*/*itools*.yml" },
        },
      },
    },
  })

  vim.lsp.config("tinymist", {
    -- offset_encoding = "utf-8", -- semantic tokens error
    settings = {
      exportPdf = "never", -- Choose onType, onSave or never.
      formatterMode = "typstfmt",
      -- semantic_tokens = "disable",
    }
  })

  manual_sonarlint_configuration()
end

return M
