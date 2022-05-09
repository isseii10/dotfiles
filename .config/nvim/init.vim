set shell=/bin/zsh
set number
set shiftwidth=4
set tabstop=4
set expandtab
set textwidth=0
set autoindent
set clipboard=unnamed

syntax on

inoremap <silent> jj <ESC>

call plug#begin()
Plug 'ntk148v/vim-horizon'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

let g:coc_node_path = "~/.nvm/versions/node/v17.1.0/bin/node"

let g:gitgutter_highlight_lines = 1
nnoremap <C-n> :NERDTree<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" if you don't set this option, this color might not correct
set termguicolors

colorscheme horizon

" lightline
let g:lightline = {}
let g:lightline.colorscheme = 'horizon'

