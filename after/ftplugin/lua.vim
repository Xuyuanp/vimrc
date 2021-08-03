augroup dotvim_after_ftplugin_lua
    autocmd!
    autocmd! BufWritePre <buffer> silent! lua require('stylua-nvim').format_file()
augroup END
