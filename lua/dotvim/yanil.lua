local vim = vim
local api = vim.api

local dotutil = require('dotvim.util')

local yanil = require('yanil')
local git = require('yanil/git')
local decorators = require('yanil/decorators')
local devicons = require('yanil/devicons')
local canvas = require('yanil/canvas')
local utils = require('yanil/utils')

local a = dotutil.async()
local uv = a.uv()

local M = {}

local function git_diff(_tree, node)
    local diff = git.diff(node)
    if not diff then
        return
    end

    -- content
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(bufnr, 'filetype', 'diff')
    api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(bufnr, 'swapfile', false)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, diff)

    local winnr = dotutil.floating_window(bufnr)

    api.nvim_win_set_option(winnr, 'cursorline', true)
    api.nvim_win_set_option(winnr, 'winblend', 0)
    api.nvim_win_set_option(winnr, 'winhl', 'NormalFloat:')
    api.nvim_win_set_option(winnr, 'number', true)

    api.nvim_command(string.format([[command! -buffer Apply lua require("yanil/git").apply_buf(%d)]], bufnr))
end

local telescope_find_file = a.async(function(cwd, callback)
    local actions = require('telescope.actions')
    local actions_state = require('telescope.actions.state')
    require('telescope.builtin').find_files({
        cwd = cwd,
        attach_mappings = function(prompt_bufnr, _map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = actions_state.get_selected_entry()
                local path = selection[1]
                if vim.startswith(path, './') then
                    path = string.sub(path, 3)
                end
                callback(path)
            end)
            return true
        end,
    })
end)

local find_file = a.wrap(function(tree, node)
    local winnr_bak = vim.fn.winnr()
    local altwinnr_bak = vim.fn.winnr('#')

    local cwd = node:is_dir() and node.abs_path or node.parent.abs_path

    local path = telescope_find_file(cwd).await()
    if not path or path == '' then
        return
    end
    path = cwd .. path

    local target = tree.root:find_node_by_path(path)
    if not target then
        vim.notify('file "' .. path .. '" is not found or ignored', 'WARN')
        return
    end
    tree:go_to_node(target)

    vim.cmd(string.format([[execute "%dwincmd w"]], altwinnr_bak))
    vim.cmd(string.format([[execute "%dwincmd w"]], winnr_bak))
end)

local create_node = a.wrap(function(tree, node)
    node = node:is_dir() and node or node.parent
    local name = a.ui.input({
        prompt = node.abs_path,
    }).await()
    if not name or name == '' then
        return
    end

    local path = node.abs_path .. name
    if tree.root:find_node_by_path(path) then
        vim.notify('path "' .. path .. '" is already exists', 'WARN')
        return
    end

    local dir = vim.fn.fnamemodify(path, ':h')
    local res = uv.simple_job({ command = 'mkdir', args = { '-p', dir } }).await()

    if res.code ~= 0 then
        vim.notify('mkdir failed: ' .. (res.stderr or res.stdout or ''), 'ERROR')
        return
    end
    if not vim.endswith(path, '/') then
        res = uv.simple_job({ command = 'touch', args = { path } }).await()

        if res.code ~= 0 then
            vim.notify('touch file failed: ' .. (res.stderr or res.stdout or ''), 'ERROR')
            return
        end
    end

    a.schedule().await()

    tree:force_refresh_node(node)
    git.update(tree.cwd)

    local new_node = tree.root:find_node_by_path(path)
    if not new_node then
        vim.notify('create node failed', 'WARN')
        return
    end
    tree:go_to_node(new_node)
end)

local function clear_buffer(path)
    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if path == api.nvim_buf_get_name(bufnr) then
            api.nvim_buf_delete(bufnr, { force = true })
            return
        end
    end
end

local delete_node = a.wrap(function(tree, node)
    if node == tree.root then
        vim.notify('You can NOT delete the root', 'WARN')
        return
    end
    if node:is_dir() then
        node:load()
    end

    if node:is_dir() and #node.entries > 0 then
        local answer = a.ui.input({
            prompt = 'Directory is not empty. Are you sure? ',
            default = 'No',
        }).await()
        if not answer or answer:lower() ~= 'yes' then
            return
        end
    end

    local res = uv.simple_job({
        command = 'rm',
        args = { '-rf', node.abs_path },
    }).await()
    if res.code ~= 0 then
        a.api.nvim_err_writeln('delete node failed:', (res.stderr or res.stdout or ''))
        return
    end

    a.schedule().await()

    clear_buffer(node.abs_path)
    local parent = node.parent
    tree:force_refresh_node(parent)
    git.update(tree.cwd)
end)

function M.setup()
    yanil.setup()

    local tree = require('yanil/sections/tree'):new()

    tree:setup({
        draw_opts = {
            decorators = {
                decorators.pretty_indent_with_git,
                devicons.decorator(),
                decorators.space,
                decorators.default,
                decorators.executable,
                decorators.readonly,
                decorators.link_to,
            },
        },
        filters = {
            function(name)
                local patterns = { '^%.git$', '%.pyc', '^__pycache__$', '^%.idea$', '^%.iml$', '^%.DS_Store$', '%.o$', '%.d$' }
                for _, pat in ipairs(patterns) do
                    if string.find(name, pat) then
                        return true
                    end
                end
            end,
        },
        keymaps = {
            [']c'] = git.jump_next,
            ['[c'] = git.jump_prev,
            gd = git_diff,
            ['<A-/>'] = find_file,
            ['<A-a>'] = create_node,
            ['<A-x>'] = delete_node,
            ['o'] = function(self, node)
                node = node:is_dir() and node or node.parent

                self:refresh(node, {}, function()
                    node:toggle()
                end)

                self:go_to_node(node)
            end,
        },
    })

    canvas.register_hooks({
        on_enter = function()
            git.update(tree.cwd)
            utils.buf_set_keymap(canvas.bufnr, 'n', 'q', function()
                vim.fn.execute('quit')
            end)
        end,
    })

    canvas.setup({
        sections = {
            tree,
        },
        autocmds = {
            {
                event = 'User',
                pattern = 'YanilGitStatusChanged',
                cmd = function()
                    git.refresh_tree(tree)
                end,
            },
        },
    })
end

return M
