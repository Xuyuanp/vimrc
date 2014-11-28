" A tree explorer plugin for vim.
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" NERDTree and tabs together in Vim, painlessly
 Plugin 'jistr/vim-nerdtree-tabs'

map <C-E> :NERDTreeTabsToggle<CR>
let NERDTreeShowBookmarks               = 1
let NERDTreeIgnore                      =
            \ ['\.pyc', '\~$', '\.swo$', '\.git', '\.hg', '\.svn', '\.bzr', '\.DS_Store']
let NERDTreeShowHidden                  = 1
let NERDTreeChDirMode                   = 2
let NERDTreeMouseMode                   = 2
let g:nerdtree_tabs_open_on_gui_startup = '1'
