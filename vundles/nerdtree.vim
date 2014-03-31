" A tree explorer plugin for vim.
Bundle 'Xuyuanp/nerdtree'

" NERDTree and tabs together in Vim, painlessly
Bundle 'jistr/vim-nerdtree-tabs'

map <C-E> :NERDTreeTabsToggle<CR>
let NERDTreeShowBookmarks               = 1
let NERDTreeIgnore                      =
            \ ['\.pyc', '\~$', '\.swo$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeShowHidden                  = 1
let NERDTreeChDirMode                   = 0
let NERDTreeMouseMode                   = 2
let g:nerdtree_tabs_open_on_gui_startup = '1'

let g:nerdtree_show_git_status          = 1
