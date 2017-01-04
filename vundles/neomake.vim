NeoBundle 'neomake/neomake'

autocmd! BufWritePost * Neomake

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
