NeoBundle 'eagletmt/neco-ghc'
NeoBundle 'eagletmt/ghcmod-vim'

let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:necoghc_enable_detailed_browse = 1

NeoBundle 'dag/vim2hs'

NeoBundle 'itchyny/vim-haskell-indent'

autocmd FileType haskell set formatprg=pointfree
