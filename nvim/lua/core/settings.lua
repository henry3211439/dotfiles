local opt = vim.opt

---------- Options ----------
opt.laststatus = 3
opt.showmode = false

opt.clipboard = 'unnamedplus'
opt.cursorline = true

opt.wrap = false
opt.termguicolors = true

-- Indenting --
opt.expandtab   = true
opt.smartindent = true
opt.tabstop     = 4
opt.softtabstop = 4
opt.shiftwidth  = 4

opt.list = true
opt.listchars:append('space:⋅')
opt.listchars:append('eol:↴')

opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'a'

-- Line Numbers --
opt.number = true
opt.numberwidth = 3
opt.ruler = false

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true

opt.formatoptions = opt.formatoptions - 'cro'

vim.cmd [[ colorscheme tokyonight ]]
vim.cmd [[ highlight LineNr ctermbg=0 guifg=DarkCyan ]]
vim.cmd [[ highlight CursorLineNr ctermbg=0 guifg=Yellow ]]
