call plug#begin()

Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'

call plug#end()

set smartindent
set autoindent
set softtabstop=4 shiftwidth=4 expandtab
syntax on

if ( has ( "termguicolors" ) )
	set termguicolors
endif

set background=dark
colorscheme gruvbox

set number
set relativenumber
set guifont=Iosevka:h14
set showmatch
set clipboard=unnamedplus
set mouse=a
