" Reverse visual mode color
hi Visual term=reverse cterm=reverse guibg=Grey
set background=dark

" coloscheme
if has('gui_running')
    set guifont=Monaco\ for\ Powerline:h13
end

silent! colorscheme solarized
