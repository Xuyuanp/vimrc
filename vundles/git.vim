NeoBundle 'tpope/vim-git'

" show a git diff in the gutter(sign column) and stages/reverts hunks'
NeoBundle 'airblade/vim-gitgutter'

let g:gitgutter_highlight_lines = 0
let g:gitgutter_realtime        = 1
let g:gitgutter_eager           = 1

" gitk for vim
NeoBundle 'gregsexton/gitv'

" a Git wrapper
NeoBundle 'tpope/vim-fugitive'

autocmd Filetype gitcommit setlocal spell textwidth=72
