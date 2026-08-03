" Git worktree helpers, ordered newest-created first.
" Vimscript, not lua: vim/link.sh points ~/.vimrc and init.vim at the same file.

" resolve() sees through the symlinked autoload dir into the dotstash checkout.
let s:preview = shellescape(
      \ fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/scripts/wt-preview')

" fish's __wt_list emits: birthtime, path, name, branch, age.
function! s:worktrees() abort
  let lines = systemlist('fish -c __wt_list')
  if v:shell_error != 0
    return []
  endif

  let entries = []
  for line in lines
    let f = split(line, "\t")
    if len(f) < 5
      continue
    endif
    call add(entries, f[1] . "\t" . printf('%-50s %s', f[2], f[4]))
  endfor
  return entries
endfunction

function! s:main_checkout() abort
  let lines = systemlist('git worktree list --porcelain')
  if v:shell_error != 0 || empty(lines)
    return ''
  endif
  return substitute(lines[0], '^worktree ', '', '')
endfunction

function! s:warn(msg) abort
  echohl WarningMsg | echomsg a:msg | echohl NONE
endfunction

" :tcd not :cd, so :GFiles/:Files/:Rg scope per tab.
function! s:open_worktree(line) abort
  let path = split(a:line, "\t")[0]
  tabnew
  execute 'tcd' fnameescape(path)
  echo 'worktree: ' . fnamemodify(path, ':t')
endfunction

function! wt#switch() abort
  let entries = s:worktrees()
  if empty(entries)
    call s:warn('wt: no worktrees here')
    return
  endif

  call fzf#run({
        \ 'source': entries,
        \ 'sink': function('s:open_worktree'),
        \ 'options': ['--delimiter', "\t", '--with-nth', '2', '--ansi',
        \             '--prompt', 'worktree> ',
        \             '--preview', s:preview . ' {1}'],
        \ })
endfunction

" Repairs the current tab's :tcd, so deliberately no new tab.
function! wt#main() abort
  let main = s:main_checkout()
  if empty(main)
    call s:warn('wt: not inside a git repository')
    return
  endif
  execute 'tcd' fnameescape(main)
  echo 'worktree: ' . fnamemodify(main, ':t') . ' (main)'
endfunction

function! s:goto_tab(line) abort
  execute split(a:line, "\t")[0] . 'tabnext'
endfunction

" Labelled by cwd, which the airline tabline doesn't show.
function! wt#tabs() abort
  let entries = []
  for nr in range(1, tabpagenr('$'))
    let bufs = tabpagebuflist(nr)
    let name = bufname(bufs[tabpagewinnr(nr) - 1])
    let file = empty(name) ? '[No Name]' : fnamemodify(name, ':t')
    let more = len(bufs) > 1 ? printf(' (+%d)', len(bufs) - 1) : ''
    let cwd = getcwd(-1, nr)
    call add(entries, printf("%d\t%s\t", nr, cwd) . printf('%-3d %-40s %s%s',
          \ nr, fnamemodify(cwd, ':t'), file, more))
  endfor

  call fzf#run({
        \ 'source': entries,
        \ 'sink': function('s:goto_tab'),
        \ 'options': ['--delimiter', "\t", '--with-nth', '3', '--ansi',
        \             '--prompt', 'tab> ',
        \             '--preview', s:preview . ' {2}'],
        \ })
endfunction
