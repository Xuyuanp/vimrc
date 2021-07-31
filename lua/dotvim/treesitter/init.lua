local ts_configs = require('nvim-treesitter.configs')
local ts_install = require('nvim-treesitter.install')

ts_install.compilers = { 'clang' }

ts_configs.setup {
    ensure_installed = {'go', 'python'},      -- one of "all", "language", or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { 'lua' },
        custom_captures = {
            ["error"] = "Error",
            -- Constants
            ["constant"] = "Constant",
            -- ["constant.builtin"] = "TSConstBuiltin",
            -- ["constant.macro"] = "TSConstMacro",
            ["string"] = "String",
            -- ["string.regex"] = "TSStringRegex",
            -- ["string.escape"] = "TSStringEscape",
            ["character"] = "Character",
            ["number"] = "Number",
            ["boolean"] = "Boolean",
            ["float"] = "Float",
            -- ["annotation"] = "TSAnnotation",

            -- Functions
            ["function"] = "Function",
            ["function.builtin"] = "Function",
            ["function.macro"] = "Macro",
            -- ["parameter"] = "TSParameter",
            -- ["parameter.reference"] = "TSParameterReference",
            ["method"] = "Function",
            -- ["field"] = "TSField",
            -- ["property"] = "TSProperty",
            -- ["constructor"] = "TSConstructor",

            -- Keywords
            ["conditional"] = "Conditional",
            ["repeat"] = "Repeat",
            ["label"] = "Label",
            ["operator"] = "Operator",
            ["keyword"] = "Keyword",
            ["keyword.function"] = "Keyword",
            ["exception"] = "Exception",

            ["type"] = "Type",
            ["type.builtin"] = "Type",
            ["structure"] = "Structure",
            ["include"] = "Include",

            -- for rainbow
            ["punctuation.delimiter"] = "Delimiter",
            -- ["punctuation.bracket"] = "",

            -- variable
            -- ["variable"] = "TSVariable",
            -- ["variable.builtin"] = "TSVariableBuiltin",

            -- Text
            -- ["text"] = "TSText",
            -- ["text.strong"] = "TSStrong",
            -- ["text.emphasis"] = "TSEmphasis",
            -- ["text.underline"] = "TSUnderline",
            -- ["text.title"] = "TSTitle",
            -- ["text.literal"] = "TSLiteral",
            -- ["text.uri"] = "TSURI",
            --
            -- ["none"] = "TSNone",
        }
    },
    incremental_selection = {
        enable = true
    },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = {
            enable = true
        },
        navigation = { enable = false },
        smart_rename = { enable = false }
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
        max_file_lines = 2000
    }
}
