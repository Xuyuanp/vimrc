local function setup()
    local set_keymap = vim.api.nvim_set_keymap

    ---[[ Navigation between split windows
    set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
    set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
    set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
    set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

    set_keymap('n', '<Up>', '<C-w>+', { noremap = true, silent = true })
    set_keymap('n', '<Down>', '<C-w>-', { noremap = true, silent = true })
    set_keymap('n', '<Left>', '<C-w><', { noremap = true, silent = true })
    set_keymap('n', '<Right>', '<C-w>>', { noremap = true, silent = true })
    ---]]

    ---[[ Mapping for tab management
    set_keymap('n', '<leader>tc', ':tabc<CR>', { noremap = true, silent = true })
    set_keymap('n', '<leader>tn', ':tabn<CR>', { noremap = true, silent = true })
    set_keymap('n', '<leader>tp', ':tabp<CR>', { noremap = true, silent = true })
    set_keymap('n', '<leader>te', ':tabe<CR>', { noremap = true, silent = true })
    ---]]

    ---[[ Reselect visual block after indent/outdent
    set_keymap('v', '<', '<gv', { noremap = true, silent = true })
    set_keymap('v', '>', '>gv', { noremap = true, silent = true })
    ---]]

    ---[[ Clear search highlight
    set_keymap('n', '<leader>/', '<cmd>nohls<CR>', { noremap = true, silent = true })
    ---]]

    ---[[ Keep search pattern at the center of the screen
    set_keymap('n', 'n', 'nzz', { noremap = true, silent = true })
    set_keymap('n', 'N', 'Nzz', { noremap = true, silent = true })
    set_keymap('n', '*', '*zz', { noremap = true, silent = true })
    set_keymap('n', '#', '#zz', { noremap = true, silent = true })
    set_keymap('n', 'g*', 'g*zz', { noremap = true, silent = true })
    ---]]

    ---[[ Mimic emacs line editing in insert mode only
    set_keymap('i', '<C-a>', '<Home>', { noremap = true, silent = true })
    set_keymap('i', '<C-b>', '<Left>', { noremap = true, silent = true })
    set_keymap('i', '<C-e>', '<End>', { noremap = true, silent = true })
    set_keymap('i', '<C-f>', '<Right>', { noremap = true, silent = true })
    ---]]

    ---[[ Yank to system clipboard
    set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
    set_keymap('n', '<leader>yy', '"+yy', { noremap = true, silent = true })

    set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
    ---]]
end

return {
    setup = setup,
}
