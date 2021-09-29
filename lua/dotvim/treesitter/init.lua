local ts_configs = require('nvim-treesitter.configs')

ts_configs.setup({
    ensure_installed = { 'go', 'python' }, -- one of "all", "language", or a list of languages
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { 'lua' },
    },
    incremental_selection = {
        enable = true,
    },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = {
            enable = true,
        },
        navigation = { enable = false },
        smart_rename = { enable = false },
    },
    textobjects = { enable = true },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
    },
    rainbow = {
        enable = true,
        extend_mode = true,
        max_file_lines = 2000,
    },
})
