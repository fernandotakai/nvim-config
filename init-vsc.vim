let python_home=expand("~/.pyenv/versions/")
let g:python3_host_prog = python_home . '3.10.8/bin/python'
let g:python_host_prog = python_home . '2.7.18/bin/python'

set nocompatible
filetype off

let s:editor_root=expand("~/.config/nvim")

call plug#begin(stdpath('data') . '/plugged')

" from github
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'sophacles/vim-bundle-mako'

Plug 'tpope/vim-rhubarb'

Plug 'tpope/vim-dispatch'
Plug 'tartansandal/vim-compiler-pytest'
Plug 'easymotion/vim-easymotion'

call plug#end()

let ayucolor="dark"

filetype plugin indent on

" from vimscripts

" set vb t_vb=
" colorscheme mustang
" colorscheme sonokai

set number
set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h9
set relativenumber

set hidden
set backspace=indent,eol,start

set nobackup		
set history=100	
set ruler		
set showcmd		
set incsearch	 
set noswapfile
set scrolloff=5
set ttyfast
set lazyredraw

set undofile

set undodir=~/.config/nvim/undodir-vsc
set undolevels=100 "maximum number of changes that can be undone
set undoreload=100 "maximum number lines to save for undo on a buffer reload
set laststatus=2

if has('mouse')
  set mouse=a
endif

syntax on
set hlsearch

set backupskip=/tmp/*,/private/tmp/*"

au VimResized * :wincmd =

set tabstop=4
set shiftwidth=4
set expandtab

" fuck you i want my clipboard to be awesome
set clipboard=unnamed

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

set guioptions-=T
set cot-=preview
set ruler
set nohls

" Search
set incsearch
set ignorecase
set smartcase

" This is done so we can walk around with the cursor
set virtualedit=all
 
nnoremap # :set hlsearch<cr>#
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?
nnoremap * *<c-o>

vmap <F7> "+ygv"zy`>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" nmap <c-m> :nohlsearch<cr>

noremap  <Up> <nop>
noremap  <Down> <nop>

" left de-indents a block/line
nmap <Left>   <<
vmap <Left>   <gv

" right indents a block/line
nmap <Right>  >>
vmap <Right>  >gv

noremap K <nop>

noremap Q @q

nnoremap <tab> :

" \1 \2 \3 : go to buffer 1/2/3 etc
function! s:gotoEditor(...) abort
  let count = a:1
  call VSCodeCall(count ? 'workbench.action.openEditorAtIndex' . count : 'workbench.action.nextEditorInGroup')
endfunction

nnoremap <Leader>1 <Cmd>call <SID>gotoEditor("1", 'next')<CR>
nnoremap <Leader>2 <Cmd>call <SID>gotoEditor("2", 'next')<CR>
nnoremap <Leader>3 <Cmd>call <SID>gotoEditor("3", 'next')<CR>
nnoremap <Leader>4 <Cmd>call <SID>gotoEditor("4", 'next')<CR>
nnoremap <Leader>5 <Cmd>call <SID>gotoEditor("5", 'next')<CR>
nnoremap <Leader>6 <Cmd>call <SID>gotoEditor("6", 'next')<CR>
nnoremap <Leader>7 <Cmd>call <SID>gotoEditor("7", 'next')<CR>
nnoremap <Leader>8 <Cmd>call <SID>gotoEditor("8", 'next')<CR>
nnoremap <Leader>9 <Cmd>call <SID>gotoEditor("9", 'next')<CR>

nnoremap <Leader>d <cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

nnoremap <Leader>e <cmd>call VSCodeNotify('workbench.view.explorer')<CR>
nnoremap <leader>p <cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>q <cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
nnoremap <leader>g <cmd>call VSCodeNotify('filesExplorer.findInFolder')<CR>
nnoremap <leader>[ <cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap <leader>t <cmd>call VSCodeNotify('workbench.action.showCommands')<CR>
nnoremap <leader>f <cmd>call VSCodeNotify('workbench.action.focusActiveEditorGroup')<CR>

nnoremap <leader><tab> <cmd>call VSCodeNotify('scratchpads.newScratchpad')<CR>

nnoremap <leader>bs <cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>
nnoremap <leader>bv <cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.pyc,*.class,*/target/*

map q: <Nop>

set completeopt=menu,menuone,noselect

set foldminlines=3
set foldnestmax=10