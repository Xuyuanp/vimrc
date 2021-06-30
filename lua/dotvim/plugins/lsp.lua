return {
    {
        'kabouzeid/nvim-lspinstall',
        requires = { 'neovim/nvim-lspconfig' },
        config = function()
            require('dotvim/lsp')
        end
    },
}
