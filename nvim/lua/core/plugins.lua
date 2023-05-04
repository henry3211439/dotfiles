require('core.plugins_config')

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- My plugins here
    -- use 'foo1/bar1.nvim'
    -- use 'foo2/bar2.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'numToStr/Comment.nvim'
    use 'nvim-lualine/lualine.nvim'

    -- Apperance
    use 'nvim-tree/nvim-web-devicons'
    use 'folke/tokyonight.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = {{ 'nvim-lua/plenary.nvim' }}
    }

    -- 
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    -- nvim-Tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    -- LSP
    use {
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
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
