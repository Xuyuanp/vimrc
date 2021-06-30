local vfn = vim.fn
local execute = vim.api.nvim_command

local install_path = vfn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vfn.empty(vfn.glob(install_path)) > 0 then
    print("Installing packer...")
    vfn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'quitall'
end

execute 'packadd packer.nvim'

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    for _, plug in ipairs(require('dotvim/plugins/langs')) do
        use(plug)
    end

    for _, plug in ipairs(require('dotvim/plugins/tools')) do
        use(plug)
    end

    for _, plug in ipairs(require('dotvim/plugins/ui')) do
        use(plug)
    end
end)
