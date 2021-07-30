local M = {}

local function setup_go()
    local dap = require('dap')
    local pjob = require('plenary.job')
    dap.adapters.go = function(callback, _config)
        local port = 38697
        pjob:new({
            command = 'dlv',
            args = {
                'dap', '-l', '127.0.0.1:'..port, '--check-go-version=false'
            },
            on_stdout = function(err, chunk)
                assert(not err, err)
                if chunk then
                    vim.schedule(function()
                        require('dap.repl').append(chunk)
                    end)
                end
            end,
        }):start()
        vim.defer_fn(function()
            callback({
                type = 'server',
                host = '127.0.0.1',
                port = port
            })
        end, 100)
    end

    dap.configurations.go = {
        {
            type = 'go',
            name = 'Debug',
            request = 'launch',
            program = '${file}',
        },
        {
            type = 'go',
            name = 'Debug test',
            request = 'test',
            mode = 'test',
            program = '${file}',
        },
        {
            type = 'go',
            name = 'Debug test (go.mod)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
        },
    }
end

function M.setup()
    setup_go()

    local set_keymap = vim.api.nvim_set_keymap
    local command = vim.api.nvim_command
    local sign_define = vim.fn.sign_define

    _G.dotvim_dap_close = function()
        local dap = require('dap')
        dap.disconnect()
        dap.close()
        local ok, ui = pcall(require, 'dapui')
        if ok then ui.close() end
        local ok1, vt = pcall(require, 'nvim-dap-virtual-text.virtual_text')
        if ok1 then vt.clear_virtual_text() end
    end

    set_keymap('n', '<F5>', "<cmd>lua require('dap').continue()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<F6>', "<cmd>lua require('dap').run_to_cursor()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<F9>', "<cmd>lua dotvim_dap_close()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<F10>', "<cmd>lua require('dap').step_over()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<F11>', "<cmd>lua require('dap').step_into()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<F12>', "<cmd>lua require('dap').step_out()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<leader>b', "<cmd>lua require('dap').toggle_breakpoint()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<leader>B', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = false, silent = true})
    set_keymap('n', '<leader>lp', "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { noremap = false, silent = true})
    set_keymap('n', '<leader>dr', "<cmd>lua require('dap').repl_open()<CR>", { noremap = false, silent = true})
    set_keymap('n', '<leader>dl', "<cmd>lua require('dap').run_last()<CR>", { noremap = false, silent = true})

    command [[autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()]]

    command [[highlight! DapCustomPC ctermbg=245 guibg=#928374]]
    command [[autocmd ColorScheme * highlight! DapCustomPC ctermbg=245 guibg=#928374]]
    sign_define('DapStopped', {
        text = '',
        texthl = 'Green',
        linehl = 'DapCustomPC'
    })
    sign_define('DapBreakpoint', { text = '', texthl = 'Red' })
    sign_define('DapLogPoint', { text = 'ﰉ', texthl = 'Yellow' })
    sign_define('DapBreakpointRejected', { text = '' })
end

local ui = {}

function ui.setup()
    require('dapui').setup{
        icons = {
            expanded = "▾",
            collapsed = "▸"
        },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = {"<CR>"},
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        sidebar = {
            open_on_start = true,
            elements = {
                -- You can change the order of elements in the sidebar
                "scopes",
                "breakpoints",
                "stacks",
                "watches"
            },
            width = 40,
            position = "left" -- Can be "left" or "right"
        },
        tray = {
            open_on_start = true,
            elements = {
                "repl"
            },
            height = 10,
            position = "top" -- Can be "bottom" or "top"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil   -- Floats will be treated as percentage of your screen.
        }
    }

    vim.api.nvim_command[[autocmd ColorScheme * silent! lua require('dapui.config.highlights').setup()]]
end

M.ui = ui

local virtual_text = {}

function virtual_text.setup()
    -- show virtual text for current frame (recommended)
    vim.g.dap_virtual_text = true
    -- request variable values for all frames (experimental)
    vim.g.dap_virtual_text = 'all frames'
end

M.virtual_text = virtual_text

return M
