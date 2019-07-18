if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

augroup tf.fmt
  autocmd!
  autocmd BufWritePost *.tf call tf#fmt()
augroup END

function! tf#fmt()
  let l:curw = winsaveview()
  call system('terraform fmt ' . bufname('%'))
  edit
  call winrestview(l:curw)
endfunction
