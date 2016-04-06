NeoBundle 'fatih/vim-go'

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods   = 1
let g:go_fmt_command         = "goimports"
let g:go_snippet_engine      = "neosnippet"
let g:go_fmt_fail_silently   = 1
let g:go_autodetect_gopath   = 1

au FileType go nmap <Leader>s <Plug>(go-def-split)
au FileType go nmap <Leader>v <Plug>(go-def-vertical)
au FileType go nmap <Leader>ii <Plug>(go-implements)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go set completeopt+=preview
