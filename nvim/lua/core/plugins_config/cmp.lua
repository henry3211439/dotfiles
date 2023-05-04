local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- Key mapping
    mapping = cmp.mapping.preset.insert({
        [ '<C-b>' ] = cmp.mapping.scroll_docs(-4),
        [ '<C-f>' ] = cmp.mapping.scroll_docs(4),
        [ '<C-o>' ] = cmp.mapping.complete(),
        [ '<C-e>' ] = cmp.mapping.abort(),

        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- [ '<C-Space>' ] = cmp.mapping.confirm({ select = true }),

        ['<Tab>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        -- [ '<CR>' ] = cmp.mapping({
        --     i = function(fallback)
        --         if cmp.visible() and cmp.get_active_entry() then
        --             cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        --         else
        --             fallback()
        --         end
        --     end,
        --     s = cmp.mapping.confirm({ select = true }),
        --     c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        -- }),

        -- [ '<C-j>' ] = cmp.mapping(function()
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif vim.fn["vsnip#available"](1) == 1 then
        --         feedkey("<Plug>(vsnip-jump-next)", "")
        --     end
        -- end, { 'i', 's' }),
        --
        -- [ '<C-k>' ] = cmp.mapping(function()
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif vim.fn["vsnip#available"](-1) == 1 then
        --         feedkey("<Plug>(vsnip-jump-prev)", "")
        --     end
        -- end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
        -- { name = 'luasnip'   }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy'    }, -- For snippy users.
    }, {
        { name = 'buffer' },
    }),

    -- formatting = {
    --     format = require('lspkind').cmp_format({
    --         mode = 'symbol_test',
    --         menu = {
    --             buffer        = '[Buffer]',
    --             nvim_lsp      = '[LSP]',
    --             luasnip       = '[LuaSnip]',
    --             nvim_lua      = '[Lua]',
    --             latex_symbols = '[Latex]',
    --         },
    --     }),
    -- },

    formatting = {
        format = function(entry, vim_item)
            -- Kind Icons
            vim_item.kind = string.format('%s %s',
                kind_icons[vim_item.kind], vim_item.kind)

            -- Source
            vim_item.menu = ({
                buffer        = '[Buffer]',
                nvim_lsp      = '[LSP]',
                luasnip       = '[LuaSnip]',
                nvim_lua      = '[Lua]',
                latex_symbols = '[Latex]',
            })[entry.source.name]

            return vim_item
        end,
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
