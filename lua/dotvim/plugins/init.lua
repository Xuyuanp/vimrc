local vfn = vim.fn
local execute = vim.api.nvim_command
local packer = require('packer')

local std_data_path = vfn.stdpath('data')

local install_path = std_data_path .. '/site/pack/packer/start/packer.nvim'
local compile_path = std_data_path .. '/site/plugin/packer_compiled.vim'

if vfn.empty(vfn.glob(install_path)) > 0 then
    print("Installing packer...")
    vfn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'quitall'
end

execute 'packadd packer.nvim'

execute [[ autocmd User PackerComplete :PackerCompile<CR> ]]

return packer.startup(function(use)
    packer.init({
        compile_path = compile_path,
    })

    use 'wbthomason/packer.nvim'

    local groups = { 'langs', 'tools', 'ui', 'lsp' }

    for _, group in ipairs(groups) do
        for _, plug in ipairs(require('dotvim/plugins/' .. group)) do
            use(plug)
        end
    end

    if vfn.empty(vfn.glob(compile_path)) > 0 then packer.compile() end
end)
