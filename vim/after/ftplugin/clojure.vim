nnoremap <leader>j :exe ":Connect " . join(readfile(expand("~/.lein/repl-port")), "\n")<cr>
