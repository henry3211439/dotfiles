require('mason').setup()
require('mason-lspconfig').setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['lua_ls'].setup({ capabilities = capabilities })
require('lspconfig')['csharp_ls'].setup({
    capabilities = capabilities,

    cmd = {
        -- vim.fn.expand('$HOME/.dotnet/tools/csharp-ls'),
        vim.fn.expand('$HOME/.local/share/nvim/mason/packages/csharp-language-server/csharp-ls'),
    },

    filetypes = { 'cs' },

    handlers = {
        [ 'textDocument/definition'  ] = require('csharpls_extended').handler,
        [ 'textDocument/declaration' ] = require('csharpls_extended').handler,
    },

    init_options = { AutomaticWorkspaceInit = true },
})

-- require('lspconfig')['omnisharp'].setup({
--     capabilities = capabilities,
--
--     cmd = {
--         vim.fn.expand('$HOME/.local/share/nvim/mason/bin/omnisharp'),
--         '--languageserver',
--         '--hostPID',
--         tostring(vim.fn.getpid()),
--     },
--
--     handlers = {
--         ["textDocument/definition"] = require('omnisharp_extended').handler,
--     },
--
--     -- Enables support for reading code style, naming convention and analyzer
--     -- settings from .editorconfig.
--     enable_editorconfig_support = true,
--
--     -- If true, MSBuild project system will only load projects for files that
--     -- were opened in the editor. This setting is useful for big C# codebases
--     -- and allows for faster initialization of code navigation features only
--     -- for projects that are relevant to code that is being edited. With this
--     -- setting enabled OmniSharp may load fewer projects and may thus display
--     -- incomplete reference lists for symbols.
--     enable_ms_build_load_projects_on_demand = false,
--
--     -- Enables support for roslyn analyzers, code fixes and rulesets.
--     enable_roslyn_analyzers = false,
--
--     -- Specifies whether 'using' directives should be grouped and sorted during
--     -- document formatting.
--     organize_imports_on_format = false,
--
--     -- Enables support for showing unimported types and unimported extension
--     -- methods in completion lists. When committed, the appropriate using
--     -- directive will be added at the top of the current file. This option can
--     -- have a negative impact on initial completion responsiveness,
--     -- particularly for the first few completion sessions after opening a
--     -- solution.
--     enable_import_completion = false,
--
--     -- Specifies whether to include preview versions of the .NET SDK when
--     -- determining which version to use for project loading.
--     sdk_include_prereleases = true,
--
--     -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
--     -- true
--     analyze_open_documents_only = false,
--
--     on_attach = function(client, bufnr)
--         -- Enable completion triggered by <c-x><c-o>
--         vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--         -- Mappings.
--         -- See `:help vim.lsp.*` for documentation on any of the below functions
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--         vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
--     end,
-- })
