NeoBundle 'fatih/vim-go'

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods   = 1
let g:go_highlight_structs   = 1

let g:go_fmt_command = "goimports"

let g:go_auto_type_info = 1

let g:go_snippet_engine = "neosnippet"

autocmd FileType go set completeopt+=preview
