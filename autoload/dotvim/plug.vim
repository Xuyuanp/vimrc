let s:is_win = has('win16') || has('win32') || has('win64')

function! dotvim#plug#Install(plug_file) abort
    if !executable('curl')
        call dotvim#log#err("'curl' command not found")
        return
    endif

    let plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    let curl_bin = s:is_win ? 'curl.ps1' : 'curl'
    call system(join([curl_bin, '-fLo', a:plug_file, '--create-dirs', plug_url], ' '))
endfunction

" gx to open GitHub URLs on browser
function! dotvim#plug#OpenGithub() abort
    let currline = trim(getline('.'))
    let repo = matchstr(currline, '\mPlug\s\+[''"]\zs[^''"]\+\ze[''"]')
    if repo ==# ''
        return
    endif
    let name = split(repo, '/')[1]
    let uri  = get(get(g:plugs, name, {}), 'uri', '')
    if uri !~# 'github.com'
        return
    endif
    let url = 'https://github.com/' . repo
    call netrw#BrowseX(url, 0)
endfunction

" VimAwesome
function! dotvim#plug#VimAwesomeComplete() abort
    let prefix = matchstr(strpart(getline('.'), 0, col('.') - 1), '[.a-zA-Z0-9_/-]*$')
    call dotvim#log#info('Downloading plugin list from VimAwesome')
    let cands = {}
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
VIM::command("let cands = #{JSON.dump items}")
EOF
    " ---ruby end---
    if !empty(cands)
        inoremap <buffer> <c-v> <c-n>
        augroup _VimAwesomeComplete
            autocmd!
            autocmd CursorMovedI,InsertLeave * iunmap <buffer> <c-v>
                        \| autocmd! _VimAwesomeComplete
        augroup END

        call complete(col('.') - strchars(prefix), cands)
    endif
    return ''
endfunction

