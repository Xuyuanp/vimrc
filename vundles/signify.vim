Plugin 'mhinz/vim-signify'
nmap ]c <Plug>(signify-next-hunk)
nmap [c <Plug>(signify-prev-hunk)

let g:signify_vcs_list = ['git', 'svn', 'hg']
