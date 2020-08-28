if exists('g:completion_chain_complete_list')
    let g:completion_chain_complete_list.text = {
                \ 'default': [
                \   {'complete_items': ['path']},
                \   {'complete_items': ['buffer', 'buffers']},
                \ ],
                \ }
endif
