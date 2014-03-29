" vim plugin providing godef support
Plugin 'dgryski/vim-godef'                        

" A Go bundle for Vundle or Pathogen
Plugin 'Blackrush/vim-gocode'

" Vim compiler plugin for Go (golang)
Plugin 'rjohnsondev/vim-compiler-go'

let g:golang_goroot=$GOROOT

autocmd BufRead,BufNewFile *.go set filetype=go
autocmd BufRead,BufNewFile *.tpl set filetype=html
autocmd FileType go nnoremap <buffer> <C-]> :call GodefUnderCursor()<cr>
autocmd FileType go compiler golang

if executable('goimports') 
    let g:gofmt_command = "goimports"
    autocmd BufWritePre *.go :Fmt
endif

let g:godef_same_file_in_same_window = 1
