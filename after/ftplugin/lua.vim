augroup dotvim_after_ftplugin_lua
    autocmd!
    autocmd! BufWritePre <buffer> lua require('stylua-nvim').format_file()
augroup END
