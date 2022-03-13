local vfn = vim.fn
local command = vim.api.nvim_command

if vfn.has('osx') then
    vfn.setenv('MACOSX_DEPLOYMENT_TARGET', '10.8')
end

local std_data_path = vfn.stdpath('data')

local install_path = std_data_path .. '/site/pack/packer/start/packer.nvim'
local compile_path = std_data_path .. '/site/plugin/packer_compiled.vim'

local ok, packer = pcall(require, 'packer')

if not ok then
    print('Installing packer...')
    local output = vfn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    if vim.v.shell_error ~= 0 then
        vim.notify(output, 'Error')
        command('quitall')
    end

    packer = require('packer')
end

local M = {}

local function startup_fn(use)
    use({
        'lewis6991/impatient.nvim',
        rocks = 'mpack',
        config = function()
            require('impatient')
        end,
    })

    use('wbthomason/packer.nvim')

    local groups = {
        'dotvim.plugins.base',
        'dotvim.plugins.color',
        'dotvim.plugins.tools',
        'dotvim.plugins.ui',
        'dotvim.plugins.lsp',
        'dotvim.plugins.langs',
    }

    for _, group in ipairs(groups) do
        for _, plug in ipairs(require(group)) do
            use(plug)
        end
    end

    if vfn.empty(vfn.glob(compile_path)) > 0 then
        packer.compile()
    end
end

function M.setup()
    packer.startup({
        startup_fn,

        config = {
            compile_path = compile_path,
            auto_clean = true,
            max_jobs = 8,
            display = {
                open_fn = function()
                    return require('packer.util').float({ border = 'rounded' })
                end,
            },
        },
    })
end

return M
