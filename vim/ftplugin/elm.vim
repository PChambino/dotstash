setlocal foldmethod=indent

let b:ale_linters = ['make']
let b:ale_fixers = ['format']

let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 0

nnoremap <buffer> K :!open https://package.elm-lang.org/<cr><cr>
