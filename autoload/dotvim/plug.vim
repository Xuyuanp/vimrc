let s:is_win = has('win16') || has('win32') || has('win64')

function! dotvim#plug#Install(plug_file) abort
    if !executable('curl')
        call dotvim#log#err("'curl' command not found")
        return
    endif

    let l:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    let l:curl_bin = s:is_win ? 'curl.ps1' : 'curl'
    call system(join([l:curl_bin, '-fLo', a:plug_file, '--create-dirs', l:plug_url], ' '))
endfunction

" gx to open GitHub URLs on browser
function! dotvim#plug#OpenGithub() abort
    let l:currline = trim(getline('.'))
    let l:repo = matchstr(l:currline, '\mPlug\s\+[''"]\zs[^''"]\+\ze[''"]')
    if l:repo ==# ''
        return
    endif
    let l:name = split(l:repo, '/')[1]
    let l:uri  = get(get(g:plugs, l:name, {}), 'uri', '')
    if l:uri !~# 'github.com'
        return
    endif
    let l:url = 'https://github.com/' . l:repo
    call netrw#BrowseX(l:url, 0)
endfunction

" VimAwesome
function! dotvim#plug#VimAwesomeComplete() abort
    let l:prefix = matchstr(strpart(getline('.'), 0, col('.') - 1), '[.a-zA-Z0-9_/-]*$')
    call dotvim#log#info('Downloading plugin list from VimAwesome')
    let l:cands = {}
    " ---ruby start---
ruby << EOF
require 'json'
require 'open-uri'

query = VIM::evaluate('prefix').gsub('/', '%20')
items = 1.upto(max_pages = 3).map do |page|
    Thread.new do
        url  = "http://vimawesome.com/api/plugins?page=#{page}&query=#{query}"
        data = URI.open(url).read
        json = JSON.parse(data, symbolize_names: true)
        json[:plugins].map do |info|
            pair = info.values_at :github_owner, :github_repo_name
            next if pair.any? { |e| e.nil? || e.empty? }
            {word: pair.join('/'),
            menu: info[:category].to_s,
            info: info.values_at(:short_desc, :author, :github_stars).compact.join($/)}
        end.compact
    end
end.each(&:join).map(&:value).inject(:+)
VIM::command("let l:cands = #{JSON.dump items}")
EOF
    " ---ruby end---
    if !empty(l:cands)
        inoremap <buffer> <c-v> <c-n>
        augroup _VimAwesomeComplete
            autocmd!
            autocmd CursorMovedI,InsertLeave * iunmap <buffer> <c-v>
                        \| autocmd! _VimAwesomeComplete
        augroup END

        call complete(col('.') - strchars(l:prefix), l:cands)
    endif
    return ''
endfunction
