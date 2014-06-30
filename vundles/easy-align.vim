" A simple, easy-to-use Vim alignment plugin.
" Plugin 'junegunn/vim-easy-align'
NeoBundle 'junegunn/vim-easy-align'

vnoremap <CR><Space>   :EasyAlign\<CR>
vnoremap <CR>2<Space>  :EasyAlign2\<CR>
vnoremap <CR>-<Space>  :EasyAlign-\<CR>
vnoremap <CR>-2<Space> :EasyAlign-2\<CR>
vnoremap <CR>:         :EasyAlign:<CR>
vnoremap <CR>=         :EasyAlign=<CR>

vnoremap <CR><CR>=     :EasyAlign!=<CR>
