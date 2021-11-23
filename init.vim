let g:python_host_prog = '/home/ftakai/.pyenv/versions/2.7.18/bin/python2'
let g:python3_host_prog = '/home/ftakai/.pyenv/versions/3.9.9/bin/python3'

set nocompatible
filetype off

let s:editor_root=expand("~/.config/nvim")

call plug#begin(stdpath('data') . '/plugged')

" from github
Plug 'vim-syntastic/syntastic'
Plug 'hdima/python-syntax'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'duff/vim-scratch'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'fholgado/minibufexpl.vim'
Plug 'majutsushi/tagbar'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-markdown'
Plug 'sophacles/vim-bundle-mako'
Plug 'dogrover/vim-pentadactyl'
Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe'
Plug 'rking/ag.vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'posva/vim-vue'
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'

Plug 'elixir-editors/vim-elixir'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'kchmck/vim-coffee-script'
Plug 'mtscout6/vim-cjsx'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" doesn't work anymore
" Bundle 'maxbrunsfeld/vim-yankstack'

" Colors
Plug 'sainnhe/everforest'
Plug 'romainl/Apprentice'
Plug 'sainnhe/sonokai'

Plug 'joshdick/onedark.vim'
Plug 'sainnhe/edge'
Plug 'ayu-theme/ayu-vim'

call plug#end()

let ayucolor="dark"

filetype plugin indent on

" from vimscripts

" set vb t_vb=
" colorscheme mustang
colorscheme sonokai

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

set undodir=~/.config/nvim/undodir
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

autocmd FileType text setlocal textwidth=79
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType vue setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2

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
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
nnoremap * *<c-o>

let maplocalleader=','

vmap <F7> "+ygv"zy`>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

nmap <c-p> <Plug>yankstack_substitute_newer_paste
nmap <c-P> <Plug>yankstack_substitute_older_paste

nmap <c-m> :nohlsearch<cr>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

map <Leader>b :MiniBufExplorer<cr>
map <Leader>t :TagbarToggle<CR> 
map <Leader>y :YRShow<cr>
map <Leader>a :Ag
map <leader>g :GundoToggle<cr>
map <Leader><Tab> :Scratch<cr>
nmap <Leader>c :close<cr>
nmap <Leader>l :Lexplore<CR>

nnoremap / /\v
vnoremap / /\v

noremap  <Up> <nop>
noremap  <Down> <nop>

" left de-indents a block/line
nmap <Left>   <<
vmap <Left>   <gv

" right indents a block/line
nmap <Right>  >>
vmap <Right>  >gv

" FUCKING MAN GO DIE IN HELL
noremap K <nop>

" ASSHOLE EX MODE NEEDS TO DIE TO. FUCKER.
noremap Q @q

nnoremap <tab> :

" Space to toggle folds.
nnoremap <Space> zA
vnoremap <Space> zA

" search buffer by pattern.
function! BufSel(pattern)
  let bufcount = bufnr("$")
  let currbufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while currbufnr <= bufcount
    if(bufexists(currbufnr))
      let currbufname = bufname(currbufnr)
      if(match(currbufname, a:pattern) > -1)
        echo currbufnr . ": ". bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  if(nummatches == 1)
    execute ":buffer ". firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input("Enter buffer number: ")
    if(strlen(desiredbufnr) != 0)
      execute ":buffer ". desiredbufnr
    endif
  else
    echo "No matching buffers"
  endif
endfunction

" splits buffer vertically by number
function! BufVSplit(num)
  execute ":vert sb ". a:num
endfunction

"Bind the BufSel() function to a user-command
command! -nargs=1 Bs :call BufSel("<args>")
command! -nargs=1 Vbuff :call BufVSplit("<args>")

map <leader>be :Bs 
map <leader>bv :Vbuff 
map <leader>bs :sbuff 
map <leader>x :BufClose<CR>
map <leader>q :CtrlPBuffer<cr>


" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" ctags
map <silent> <c-]> :set noic<cr>g<c-]><silent>:set ic<cr>

cmap w!! %!sudo tee > /dev/null %
map <Leader>E :Explore<cr>

map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

let g:pyflakes_use_quickfix = 0

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files', 'find %s -type f']

let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ "libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/" .
    \ ")'"

let my_ctrlp_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps

let my_ctrlp_git_command = "" .
    \ "cd %s && git ls-files | " .
    \ ctrlp_filter_greps

let g:ctrlp_user_command = ['.git/', my_ctrlp_git_command, my_ctrlp_user_command]

let g:ctrlp_map = '<leader>p'
let g:ctrlp_extensions = ['tag', 'buffertag']

map <Leader>[ :CtrlPTag<cr>
map <Leader>] :CtrlPBufTag<cr>

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.pyc,*.class,*/target/*

" MiniBuff explorer settings
let g:vim_markdown_folding_disabled=1

let g:tagbar_autofocus = 1
let g:tagbar_foldlevel = 0

let g:UltiSnipsExpandTrigger="<c-b>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

nnoremap <leader>Y :let g:ycm_auto_trigger=!g:ycm_auto_trigger<CR>

au BufRead,BufNewFile /usr/local/Cellar/nginx/0.7.65/conf/* set ft=nginx 
au BufNewFile,BufRead *pentadactylrc*,*.penta set filetype=pentadactyl
au BufRead,BufNewFile Vagrantfile set filetype=ruby
au BufRead,BufNewFile *.fish set filetype=fish
au BufRead,BufNewFile *.rc,*.rs set filetype=rust
au BufRead,BufNewFile *.thrift set filetype=thrift
au BufRead,BufNewFile *.spec set filetype=json
au BufRead,BufNewFile *.tsx set filetype=typescript

augroup COMMIT_EDITMSG
augroup end

let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
let g:airline_extensions = ['branch', 'ctrlp', 'syntastic']
let g:python_slow_sync = 1

let g:airline#extensions#syntastic#enabled = 1

let python_highlight_all = 1
let python_print_as_function = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:ycm_python_binary_path = 'python'
let g:syntastic_python_checkers = ['flake8', 'python']

let g:syntastic_python_python_exec = '/home/ftakai/bin/python-vim'
let g:syntastic_python_flake8_exec = '/home/ftakai/bin/python-vim'
let g:syntastic_python_flake8_args = ['-m', 'flake8']

if getcwd() =~# '\/olark\/'
    let python_version_2 = 1
endif

map q: <Nop>

" Treesitter configuration
"
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
    disable = {"bash"}
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF

" Folding
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
set foldminlines=3
set foldnestmax=10
