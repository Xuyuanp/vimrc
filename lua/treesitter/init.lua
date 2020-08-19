require'nvim-treesitter.configs'.setup {
    ensure_installed = {"go", "python"},      -- one of "all", "language", or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
    },
    incremental_selection = {
        enable = true
    },
    refactor = {
        highlight_current_scope = {
            enable = true
        },
        smart_rename = {
            enable = true
        }
    }
}
