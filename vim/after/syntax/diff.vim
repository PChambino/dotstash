hi! DiffAdd NONE ctermfg=71
hi! DiffDelete NONE ctermfg=203
hi! diffFile NONE cterm=bold ctermfg=124
hi! link diffIndexLine diffFile
hi! diffLine NONE ctermfg=14
hi! link diffSubname Constant
hi! link diffAdded DiffAdd
hi! link diffChange DiffChanged
hi! link diffRemoved DiffDelete

syn match diffMode "^new file mode .*"
hi link diffMode diffFile
