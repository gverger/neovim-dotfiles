
"let test#java#maventest#executable = 'mvnd'

function! java#GetPosition()
  let filename_modifier = get(g:, 'test#filename_modifier', ':.')
  let path = expand('%')

  let position = {}
  let position['file'] = fnamemodify(path, filename_modifier)
  let position['line'] = line('.')
  let position['col']  = col('.')

  return position
endfunction

nnoremap <buffer> <leader>sy :call system('/mnt/c/windows/system32/clip.exe ', test#java#maventest#executable . ' ' . test#java#maventest#build_position("nearest", java#GetPosition())[0])<CR>

augroup JAVA
  au!

  au BufWritePost *.java lua require('lint').try_lint()
augroup END

setlocal tabstop=4 shiftwidth=4 softtabstop=4

set tw=119

lua <<LSP
local lspconfig = require'lspconfig'

local root_files = {
  -- Single-module projects
  {
    '.vim-workspace',
  },
  {
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  -- Multi-module projects
  { 'build.gradle', 'build.gradle.kts' },
}

function root_directory()
  local fname = vim.fn.getcwd()
  for _, patterns in ipairs(root_files) do
    local root = lspconfig.util.root_pattern(unpack(patterns))(fname)
    if root then
      return root
    end
  end
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/home/gverger/.local/share/jdtls-workspace/' .. project_name

capabilities = require('cmp_nvim_lsp').default_capabilities()


local on_attach = function(client, bufnr)
  require('jdtls').setup_dap({hotcodereplace = 'auto'})
  require('config.lsp.codelens').on_attach(client, bufnr)
  vim.cmd([[
  augroup lsp_document_highlight
  autocmd! * <buffer>
  autocmd CursorMoved,CursorMovedI,BufHidden,InsertEnter,InsertCharPre,WinLeave <buffer> lua vim.lsp.buf.clear_references()
  augroup end
  ]])
end

local mason_packages = "$HOME/.local/share/nvim/mason/packages/"

local bundles = {
  vim.fn.glob(mason_packages .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
}

-- local vscode_java_test = "$HOME/bin/vscode-java-test/"
-- when using mason
local vscode_java_test = mason_packages .. "java-test/extension/"

vim.list_extend(bundles, vim.split(vim.fn.glob(vscode_java_test .. "server/*.jar", 1), "\n"))

bundles = vim.tbl_filter(function(s)
  return not vim.endswith(s, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
end, bundles) or {}

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities;
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;

vim.fn.setenv("JAVA_HOME", "/home/gverger/.asdf/installs/java/openjdk-17.0.2/")

local config = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {'/home/gverger/.local/share/nvim/mason/bin/jdtls', '-data', workspace_dir, '--jvm-arg=-Dlog.level=ALL', '--jvm-arg=-Dlog.protocol=true'},
    root_dir = root_directory(),
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
        maxConcurrentBuilds = 4,
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
        configuration = {
          maven = {
            userSettings="/home/gverger/artelys/powsybl-griffin/.mvn/local-settings.xml"
          },
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
          filteredTypes = {"java.awt.*","com.sun.*","sun.*","jdk.*","org.graalvm.*","io.micrometer.shaded.*", "javax.*", "groovy*"},
          favoriteStaticMembers ={"java.util.Objects.*", "org.assertj.core.api.Assertions.*", "org.junit.Assert.*","org.junit.Assume.*","org.junit.jupiter.api.Assertions.*","org.junit.jupiter.api.Assumptions.*","org.junit.jupiter.api.DynamicContainer.*","org.junit.jupiter.api.DynamicTest.*","org.mockito.Mockito.*","org.mockito.ArgumentMatchers.*","org.mockito.Answers.*"},
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
}

if vim.g.custom_jdtls_config then
  config = vim.tbl_deep_extend("force", config, vim.g.custom_jdtls_config)
end

config.on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
end

-- lspconfig.jdtls.setup {
--   -- root_dir = lspconfig.util.root_pattern('.vim-workspace') or lspconfig.util.root_pattern('pom.xml'),
--   root_dir = function(fname)
--     for _, patterns in ipairs(root_files) do
--       local root = lspconfig.util.root_pattern(unpack(patterns))(fname)
--       if root then
--         return root
--       end
--     end
--   end,
config.handlers = config.handlers or {}
-- config.handlers['language/status'] = function() end
require('jdtls').start_or_attach(config)

vim.keymap.set({ "n" }, "<leader>dt", function()
  local l, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_mark(0, "T", l, c, {})
  require'jdtls'.test_nearest_method()
end)

vim.keymap.set({ "n" }, "<leader>dc", function()
  require'jdtls'.test_class()
end)

vim.keymap.set({ "n" }, "gu", require('jdtls').super_implementation)
LSP
nnoremap <leader>dg 'T

" command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
" command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
" command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
" command! -buffer JdtJol lua require('jdtls').jol()
" command! -buffer JdtBytecode lua require('jdtls').javap()
" command! -buffer JdtJshell lua require('jdtls').jshell()

