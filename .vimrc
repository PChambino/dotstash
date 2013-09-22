syntax on
set number splitright

" identation
set softtabstop=2 shiftwidth=2 expandtab autoindent

" 80 character rule
set textwidth=80 colorcolumn=+1

" enable mouse
if has("mouse")
  set mouse=a
endif

" support fish
if $SHELL =~ "fish"
  set shell=/bin/bash
endif

" enable copy paste
vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
nmap <C-v> :call setreg("\"", system("pbpaste"))<CR>p

