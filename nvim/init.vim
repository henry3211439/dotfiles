" 
set nocompatible 
set t_Co=256

" Enable syntax highlighting
syntax on
autocmd BufNewFile,BufRead *.sp setfiletype cpp

" Highlighting cursor line horizontally
set cursorline
highlight CursorLine cterm=none ctermbg=DarkGray

" Show tabs, spaces
set list
set listchars=tab:-->,space:.

" Highlighting cursor line vertically
" set cursorcolumn

" Show numbers of each line
set number

" Disable line wrap.
set nowrap

" 
set cindent

" Use space characters instead of tabs
set expandtab

" Set tab width to 4 spaces
set tabstop=4

" Set shift width to 4 spaces
set shiftwidth=4

"
set softtabstop=4

" Use highlighting when doing a search.
set hlsearch

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %#FilePath#%F\ %#NormalCol#\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ %p%%\  

" Show the status on the second to last line.
set laststatus=2

highlight StatusLine cterm=bold ctermbg=DarkBlue
highlight FilePath cterm=bold ctermbg=DarkBlue ctermfg=LightGreen
highlight NormalCol cterm=bold ctermfg=White

set ttyfast

filetype off

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" On-demand loading
Plug 'preservim/nerdtree'

" Sidebar file explorer
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

"
Plug 'airblade/vim-gitgutter'

"
Plug 'jiangmiao/auto-pairs'


Plug 'junegunn/vim-easy-align'

" Initialize plugin system
call plug#end()

" coc.nvim settings
so ~/.config/nvim/coc-config.vim

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Keymap
nnoremap <F5> :NERDTreeToggle <CR>

autocmd BufEnter * pwd
