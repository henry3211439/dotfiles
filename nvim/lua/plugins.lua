local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable', -- latest stable release
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'lukas-reineke/indent-blankline.nvim',
    'numToStr/Comment.nvim',
    'windwp/nvim-autopairs',

    -- Apperance
    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'folke/tokyonight.nvim',
    'bluz71/vim-nightfly-colors',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- nvim-tree
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    -- LSP
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',

        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-nvim-lsp-signature-help',

        -- 'Hoffs/omnisharp-extended-lsp.nvim',
        'Decodetalkers/csharpls-extended-lsp.nvim',
        -- 'onsails/lspkind.nvim',
    },

    -- Trouble
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
})
