local vfn = vim.fn
local command = vim.api.nvim_command

local std_data_path = vfn.stdpath('data')

local install_path = std_data_path .. '/site/pack/packer/start/packer.nvim'
local compile_path = std_data_path .. '/site/plugin/packer_compiled.vim'

local ok, packer = pcall(require, 'packer')

if not ok then
    print("Installing packer...")
    vfn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    command 'quitall'
end

command 'packadd packer.nvim'
command [[ autocmd User PackerComplete :PackerCompile<CR> ]]

return packer.startup {
    function(use)
        use 'wbthomason/packer.nvim'

        local groups = { 'base', 'color', 'tools', 'ui', 'lsp', 'langs' }

        for _, group in ipairs(groups) do
            for _, plug in ipairs(require('dotvim.plugins.' .. group)) do
                use(plug)
            end
        end

        if vfn.empty(vfn.glob(compile_path)) > 0 then packer.compile() end
    end,

    config = {
        compile_path = compile_path,
        auto_clean = true,
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'rounded' })
            end
        }
    }
}
