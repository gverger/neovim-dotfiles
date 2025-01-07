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

        -- only 3 working atm
        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
        vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),

        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarlintomnisharp.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonariac.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar")
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonartext.jar"),
        -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
      },
      settings = { -- Hack, sinon fait lagger les LSP : https://gitlab.com/schrieveslaach/sonarlint.nvim/-/issues/14
        sonarlint = {
          test = 'test',
        },
      },
    },

    filetypes = { 'python', 'java', 'cpp' },
  })
end



function M.setup()
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
      library = {
        plugins = { "nvim-dap-ui", types = true },
      }
    }
  end


  local lspconfig = require 'lspconfig'


  local capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  )
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

  -- trying this as some lsps are very slow at the moment (june 2024)
  -- https://www.reddit.com/r/neovim/comments/161tv8l/lsp_has_gotten_very_slow/

  local function on_attach(client, bufnr)
    -- don't use codelens yet python lsp doesn't execute any of them
    -- require('config.lsp.codelens').on_attach(client, bufnr)
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
    lspconfig.bashls,
    lspconfig.cmake,
    lspconfig.cssls,
    lspconfig.docker_compose_language_service,
    lspconfig.dockerls,
    lspconfig.dotls,
    lspconfig.esbonio,
    -- lspconfig.groovyls,
    -- lspconfig.harper_ls,
    lspconfig.marksman,
    -- lspconfig.pylsp,
    lspconfig.ruff,
    lspconfig.rnix,
    lspconfig.ruby_lsp,
    lspconfig.rust_analyzer,
    lspconfig.tailwindcss,
    lspconfig.taplo,
    -- lspconfig.typos_lsp,
    lspconfig.ts_ls,
    lspconfig.vimls,
    lspconfig.zls,
  }

  for _, server in pairs(simple_lsps) do
    server.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  -- require('java').setup({
  --   jdk = {
  --     auto_install = false,
  --   },
  -- })
  -- lspconfig.jdtls.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   handlers = {
  --     -- By assigning an empty function, you can remove the notifications
  --     -- printed to the cmd
  --     ["$/progress"] = function(_, result, ctx) end,
  --   },
  --   settings = {
  --     java = {
  --       -- autobuild = { enabled = false }, -- if disabled, it doesn't build when testing from vim
  --       -- if enabled, it takes time at launch
  --       signatureHelp = {
  --         enabled = true,
  --         description = {
  --           enabled = true,
  --         },
  --       },
  --       server = {
  --         launchMode = "Hybrid",
  --       },
  --       contentProvider = { preferred = 'fernflower' },
  --       eclipse = {
  --         downloadSources = true,
  --       },
  --       maven = {
  --         downloadSources = true,
  --       },
  --       implementationsCodeLens = {
  --         enabled = true,
  --       },
  --       referencesCodeLens = {
  --         enabled = true,
  --       },
  --       maxConcurrentBuilds = 4,
  --       references = {
  --         includeAccessors = true,
  --         includeDecompiledSources = true,
  --       },
  --       inlayHints = {
  --         parameterNames = {
  --           enabled = "none", -- literals, all, none
  --         },
  --       },
  --       configuration = {
  --         maven = {
  --           userSettings = "/home/gverger/artelys/powsybl-griffin/.mvn/local-settings.xml"
  --         },
  --         runtimes = {
  --           {
  --             name = "JavaSE-1.8",
  --             path = "/home/gverger/.asdf/installs/java/temurin-8.0.362+9/",
  --           },
  --           {
  --             name = "JavaSE-11",
  --             path = "/home/gverger/.asdf/installs/java/openjdk-11.0.2/",
  --           },
  --           {
  --             name = "JavaSE-17",
  --             path = "/home/gverger/.asdf/installs/java/openjdk-17.0.2/",
  --             default = true,
  --           },
  --         },
  --       },
  --       format = {
  --         settings = {
  --           url = "file:/home/gverger/.config/custom/artelys-style.xml",
  --         }
  --       },
  --       saveActions = {
  --         organizeImports = false
  --       },
  --       sources = {
  --         organizeImports = {
  --           starThreshold = 5,
  --           staticStarThreshold = 3,
  --         }
  --       },
  --       -- memberSortOrder= {"T", "SI", "SF", "F", "SM", "C", "I", "M"},
  --       codeGeneration = {
  --         generateComments = false,
  --         toString = {
  --           template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
  --         },
  --         hashCodeEquals = {
  --           useJava7Objects = true,
  --         },
  --         useBlocks = true,
  --       },
  --       completion = {
  --         overwrite = true,
  --         importOrder = {
  --           "",
  --           "javax",
  --           "java",
  --           "#" -- static starts with #
  --         },
  --         filteredTypes = { "java.awt.*", "com.sun.*", "sun.*", "jdk.*", "org.graalvm.*", "io.micrometer.shaded.*", "javax.*", "groovy*" },
  --         favoriteStaticMembers = { "java.util.Objects.*", "org.assertj.core.api.Assertions.*", "org.junit.Assert.*", "org.junit.Assume.*", "org.junit.jupiter.api.Assertions.*", "org.junit.jupiter.api.Assumptions.*", "org.junit.jupiter.api.DynamicContainer.*", "org.junit.jupiter.api.DynamicTest.*", "org.mockito.Mockito.*", "org.mockito.ArgumentMatchers.*", "org.mockito.Answers.*" },
  --         guessMethodArguments = true,
  --         chain = {
  --           enabled = true,
  --         },
  --       }
  --     }
  --   },
  -- })

  lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    configurationSection = { "html", "css", "javascript" },
    filetypes = { "html", "templ", "eruby" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  }


  lspconfig.ccls.setup {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    init_options = {
      compilationDatabaseDirectory = ".",
    }
  }

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

  -- lspconfig.csharp_ls.setup {
  --   cmd = { "/home/gverger/bin/csharp-ls" },
  --   -- filetypes = { "cs", "csharp" },
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   root_dir = root_directory,
  -- }

  lspconfig.omnisharp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
      ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
      ["textDocument/references"] = require('omnisharp_extended').references_handler,
      ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
    },
    settings = {
      cake = {
        enabled = false,
      },
      script = {
        enabled = false,
      },
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        enableAnalyzersSupport = true,
        enableImportCompletion = true,
        enableDecompilationSupport = true,
        inlayHintsOptions = {
          enableForParameters = false,
          forLiteralParameters = true,
          forIndexerParameters = true,
          forObjectCreationParameters = true,
          forOtherParameters = true,
          suppressForParametersThatDifferOnlyBySuffix = false,
          suppressForParametersThatMatchMethodIntent = false,
          suppressForParametersThatMatchArgumentName = false,
          enableForTypes = false,
          forImplicitVariableTypes = true,
          forLambdaParameterTypes = true,
          forImplicitObjectCreation = true
        },
      },
    },
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
    end,
    settings = {
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
          maxLineWidth = 200,
          preserveAttributeLineBreaks = false,
          preservedNewlines = 2,
          spaceBeforeEmptyCloseTag = true,
        }
      }
    }
  }

  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
  }

  lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["/home/gverger/.config/custom/itools-config-schema.json"] = { "*/.itools/config.yml", "*/*itools*.yml" },
        },
      },
    },
  }

  lspconfig.tinymist.setup {
    offset_encoding = "utf-8", -- semantic tokens error
    settings = {
      exportPdf = "never", -- Choose onType, onSave or never.
      formatterMode = "typstfmt",
    }
  }

  manual_sonarlint_configuration()
end

return M
