set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'altercation/vim-colors-solarized.git'
Plugin 'nanotech/jellybeans.vim'

Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'shougo/vimfiler.vim'

Plugin 'shougo/unite.vim'
Plugin 'shougo/vimproc.vim'
Plugin 'shougo/neomru.vim'
Plugin 'tsukkee/unite-tag'
Plugin 'h1mesuke/unite-outline'

Plugin 'sjl/gundo.vim'

Plugin 'vim-scripts/tComment'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-endwise'
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'

Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'

Plugin 'vim-ruby/vim-ruby'
Plugin 'saltstack/salt-vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'derekwyatt/vim-scala'
Plugin 'elixir-lang/vim-elixir'

call vundle#end()
filetype plugin indent on    " required

let g:airline#extensions#tabline#enabled = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:vimfiler_as_default_explorer = 1

" teach vim how to fish
if $SHELL =~ "fish" | set shell=/bin/bash | endif

" enable mouse
if has("mouse") | set mouse=a | endif

" show me colours
syntax on
set background=dark
colorscheme solarized

" force encoding to utf-8
set encoding=utf-8

" show me line numbers
set number
set relativenumber
" highlight current line
set cursorline
" enforce the 80 character rule
set textwidth=79 colorcolumn=+1

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" always show status line
set laststatus=2
" airline already shows the mode
set noshowmode

" leave some lines above/below cursor
set scrolloff=3
" scroll more lines
set scrolljump=3

" display whitespace characters
set list
set listchars=tab:▸\ ,trail:·,nbsp:␣,extends:>,precedes:<
let &showbreak='↪ '

" show matching brackets
set showmatch

" lets get wild with tab completion
set wildmenu wildmode=longest,list

" don't scan included files when looking for completions
set complete-=i

" enable folding, but have folds open by default
set foldmethod=syntax
set foldlevelstart=99

" split to right and below
set splitright
set splitbelow

" incremental search and highlight
set incsearch hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

" hide buffers when closing windows
set hidden

" if a file is changed outside of vim, automatically reload it without asking
set autoread
" automatically write file when changing between buffers
set autowriteall

" persist undo history
set undofile
set undodir=/tmp

" no need for backups or swapfiles
set nobackup
set noswapfile

" default indentation
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
" indent per file type preferences
au! FileType ruby,eruby,yaml setlocal ts=2 sts=2 sw=2 et ai

" bash like keys for command line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
" move left/right by word
cnoremap <c-h> <s-left>
cnoremap <c-l> <s-right>
" alternative to arrow keys
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-f> <left>
cnoremap <c-g> <right>
" paste
cnoremap <c-v> <c-r>"

" use comma for leader, easier to reach
let mapleader=","
" make use comma function is still available
nnoremap \ ,

" toggle between two files
nnoremap <leader><leader> <c-^>

" makes Y work like D
map Y y$
" yank to system clipboard
map <leader>y "*y
" paste from system clipboard
noremap <leader>p :silent! set paste<cr>"*p:set nopaste<cr>

" use jj as esc
inoremap jj <esc>
" exits insert mode and write
inoremap <c-s> <esc>:w<cr>
noremap <c-s> <esc>:w<cr>

" intuitive movement over wrapped lines
nnoremap k gk
nnoremap j gj

" no arrow keys
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" always use very magic regex mode when searching
nnoremap / /\v
nnoremap ? ?\v
" keep current highlight at center of screen and open folds
nnoremap n nzzzv
nnoremap N Nzzzv
" clear highlight search
nnoremap <leader><space> :noh<cr>

" faster spliting
nnoremap _ <C-w>s
nnoremap <bar> <C-w>v
" move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" resize windows with the arrow keys
noremap <up>    <c-w>+
noremap <down>  <c-w>-
noremap <left>  3<c-w><
noremap <right> 3<c-w>>

" move between buffers quickly
noremap <c-a> :bp<cr>
noremap <c-x> :bn<cr>
" delete buffer
nnoremap K :bd<cr>
" close window
nnoremap <c-q> :close<cr>
" save session and quit vim
nnoremap Q :mks!<cr>:qa<cr>

" HERESY
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" jump to first non-blank character of the line
noremap H ^
" jump to the last non-blank character of the line
noremap L $
vnoremap L g_

" moving lines up and down
" nnoremap <c-j> :m .+1<cr>==
" nnoremap <c-k> :m .-2<cr>==
inoremap <c-j> <esc>:m .+1<cr>==gi
inoremap <c-k> <esc>:m .-2<cr>==gi
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" insert new lines without going into insert mode
map <enter> o<esc>

" evaluate selection as ruby and replace with output
vnoremap <leader>r :!ruby<cr>

" fast edit/source of vimrc
noremap <leader>ev :tabedit $MYVIMRC<cr>
noremap <leader>sv :source $MYVIMRC<cr>:noh<cr>

" fugitive
noremap <leader>g :Git
noremap <leader>gb :Gblame<cr>
noremap <leader>gc :Gcommit<cr>
noremap <leader>gd :Gdiff<cr>
noremap <leader>gp :Git push<cr>
noremap <leader>gr :Gremove<cr>
noremap <leader>gs :Gstatus<cr>
noremap <leader>ga :Gwrite<cr>

" gundo
noremap <leader>u :GundoToggle<cr>

" explorer
noremap <leader>f :VimFilerExplorer<cr>

" unite options
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

let g:unite_source_history_yank_enable = 1
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

" the prefix key
nnoremap [unite] <Nop>
nmap <space> [unite]
" general purpose
nnoremap [unite]<space> :Unite -no-split -start-insert source<cr>
" files
nnoremap [unite]f :Unite -no-split -start-insert file_rec/git:--cached:--others:--exclude-standard<cr>
" grepping
nnoremap [unite]g :Unite -no-split grep:.<cr>
" content
nnoremap [unite]o :Unite -no-split -start-insert -auto-preview outline<cr>
nnoremap [unite]l :Unite -no-split -start-insert line<cr>
nnoremap [unite]t :!ctags -R<cr>:Unite -no-split -auto-preview -start-insert -input=<c-r><c-w> tag<cr>
" quickly switch between recent things
nnoremap [unite]r :Unite -no-split buffer tab file_mru directory_mru<cr>
nnoremap [unite]b :Unite -no-split buffer<cr>
" yank history
nnoremap [unite]y :Unite -no-split history/yank<cr>
