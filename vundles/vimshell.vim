" Powerful shell implemented by vim.
" Plugin 'Shougo/vimshell.vim'
NeoBundle 'Shougo/vimshell.vim'

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" let g:vimshell_right_prompt = 'strftime("%Y-%m-%d %a %I:%M %p")'
if exists("*strftime")
    let g:vimshell_right_prompt = 'strftime("%F %T")'
end
