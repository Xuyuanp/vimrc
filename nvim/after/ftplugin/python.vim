let b:lsp_disable_auto_format = v:false

nnoremap <silent><buffer><leader>R <cmd>echo system(['python', expand('%')])<CR>
