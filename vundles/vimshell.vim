" Powerful shell implemented by vim.
NeoBundle 'Shougo/vimshell.vim'

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
if exists("*strftime")
    let g:vimshell_right_prompt = 'strftime("%F %T")'
end
