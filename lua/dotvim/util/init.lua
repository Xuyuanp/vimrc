local M = {}

function M.Augroup(group, fn)
    vim.api.nvim_command("augroup "..group)
    vim.api.nvim_command("autocmd!")
    fn()
    vim.api.nvim_command("augroup end")
end

return M
