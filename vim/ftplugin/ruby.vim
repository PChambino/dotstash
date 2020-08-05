let b:ale_linters = ['ruby']
let b:ale_fixers = []

call system('test -e .rubocop.yml')

if v:shell_error == 0
    call add(b:ale_linters, 'rubocop')
    call add(b:ale_fixers, 'rubocop')
endif

call system('grep -w standard Gemfile')

if v:shell_error == 0
    call add(b:ale_linters, 'standardrb')
    call add(b:ale_fixers, 'standardrb')
endif

if b:ale_fixers == []
    call add(b:ale_linters, 'standardrb')
    call add(b:ale_fixers, 'standardrb')
endif

let g:ruby_indent_block_style = 'do'

nnoremap <buffer> K :!open https://ruby-doc.org/<cr><cr>
nnoremap <buffer> KK :!open https://api.rubyonrails.org/<cr><cr>
