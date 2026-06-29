local mason_packages = "$HOME/.local/share/nvim/mason/packages/"

local bundles = {
  vim.fn.glob(mason_packages .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
}

local vscode_java_test = mason_packages .. "java-test/extension/"

local java_test_bundles = vim.split(vim.fn.glob(vscode_java_test .. "server/*.jar", 1), "\n")
local excluded = {
  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
  "jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ":t")
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end

vim.list_extend(bundles, require("spring_boot").java_extensions())

-- bundles = vim.tbl_filter(function(s)
--   return not vim.endswith(s, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
-- end, bundles) or {}

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities;
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;

local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

local config = {
  root_dir= require("jdtls").setup.find_root({".git"}),
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require('jdtls').setup_dap()
    require('config.lsp.codelens').on_attach(client, bufnr)

    vim.cmd([[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorMoved,CursorMovedI,BufHidden,InsertEnter,InsertCharPre,WinLeave <buffer> lua vim.lsp.buf.clear_references()
      augroup end
      ]])
  end,
  settings = {
    java = {
      -- autobuild = { enabled = false }, -- if disabled, it doesn't build when testing from vim
      -- if enabled, it takes time at launch
      signatureHelp = {
        enabled = true,
        description = {
          enabled = true,
        },
      },
      server = {
        launchMode = "Hybrid",
      },
      contentProvider = { preferred = 'fernflower' },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      maxConcurrentBuilds = 8,
      references = {
        includeAccessors = true,
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          -- enabled = "none", -- literals, all, none
          enabled = "all", -- literals, all, none
        },
      },
      compile = {
        nullAnalysis = {
          mode = "automatic",
          nonnull = 'org.jetbrains.annotations.NotNull',
          nullable = 'org.jetbrains.annotations.Nullable',
          nonnullbydefault = 'org.eclipse.jdt.annotation.NonNullByDefault',
        },
      },
      configuration = {
        maven = {
          userSettings = "/home/gverger/artelys/powsybl-griffin/.mvn/local-settings.xml"
        },
        updateBuildConfiguration = "automatic",
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/home/gverger/.asdf/installs/java/temurin-8.0.362+9/",
          },
          {
            name = "JavaSE-11",
            path = "/home/gverger/.asdf/installs/java/openjdk-11.0.2/",
          },
          {
            name = "JavaSE-17",
            path = "/home/gverger/.asdf/installs/java/openjdk-17.0.2/",
            default = true,
          },
          {
            name = "JavaSE-21",
            path = "/home/gverger/.asdf/installs/java/temurin-21.0.0+35.0.LTS/",
          },
        },
      },
      format = {
        settings = {
          url = "file:/home/gverger/.config/custom/artelys-style.xml",
        }
      },
      saveActions = {
        organizeImports = false
      },
      sources = {
        organizeImports = {
          starThreshold = 5,
          staticStarThreshold = 3,
        }
      },
      -- memberSortOrder= {"T", "SI", "SF", "F", "SM", "C", "I", "M"},
      codeGeneration = {
        generateComments = false,
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      completion = {
        overwrite = true,
        importOrder = {
          "",
          "javax",
          "java",
          "#" -- static starts with #
        },
        filteredTypes = { "java.awt.*", "com.sun.*", "sun.*", "jdk.*", "org.graalvm.*", "io.micrometer.shaded.*", "javax.*", "groovy*" },
        favoriteStaticMembers = { "java.util.Objects.*", "org.assertj.core.api.Assertions.*", "org.junit.Assert.*", "org.junit.Assume.*", "org.junit.jupiter.api.Assertions.*", "org.junit.jupiter.api.Assumptions.*", "org.junit.jupiter.api.DynamicContainer.*", "org.junit.jupiter.api.DynamicTest.*", "org.mockito.Mockito.*", "org.mockito.ArgumentMatchers.*", "org.mockito.Answers.*" },
        guessMethodArguments = true,
        chain = {
          enabled = true,
        },
      }
    }
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  handlers = {
    ["language/status"] = function() end,
    -- apparently, textDocument/didSave is not triggered
    -- ["textDocument/didSave"] = function()
    --   vim.notify("saved")
    --
    --   require('jdtls').compile()
    -- end,
  },
}

if vim.g.custom_jdtls_config then
  config = vim.tbl_deep_extend("force", config, vim.g.custom_jdtls_config)
end

return config
