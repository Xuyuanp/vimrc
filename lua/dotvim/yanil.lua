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

local fzf_files = vim.fn['fzf#vim#files']
local fzf_with_preview = vim.fn['fzf#vim#with_preview']

local function fzf_find(tree)
    local winnr_bak = vim.fn.winnr()
    local altwinnr_bak = vim.fn.winnr('#')

    fzf_files(tree.cwd, {
        ['sink*'] = function(lines)
            if #lines == 1 then
                return
            end
            local path = lines[2]
            local node = tree.root:find_node_by_path(tree.cwd .. path)
            if not node then
                print('file', path, 'is not found or ignored')
                return
            end

            tree:go_to_node(node)
        end,
        options = fzf_with_preview().options,
    })
    api.nvim_command(string.format([[autocmd WinClosed <buffer> execute "%dwincmd w" | execute "%dwincmd w"]], altwinnr_bak, winnr_bak))
end

local async_create_node = a.wrap(function(tree, node, name)
    if not name or name == '' then
        return
    end
    local path = node.abs_path .. name
    if tree.root:find_node_by_path(path) then
        print('path', path, 'is already exists')
        return
    end

    if vim.endswith(path, '/') then
        local res = uv.simple_job({ command = 'mkdir', args = { '-p', path } }).await()

        if res.code ~= 0 then
            a.api.nvim_err_writeln('mkdir failed: ' .. (res.stderr or res.stdout or ''))
            return
        end
    else
        local dir = vim.fn.fnamemodify(path, ':h')

        local res = uv.simple_job({ command = 'mkdir', args = { '-p', dir } }).await()

        if res.code ~= 0 then
            a.api.nvim_err_writeln('mkdir failed: ' .. (res.stderr or res.stdout or ''))
            return
        end

        local res = uv.simple_job({ command = 'touch', args = { path } }).await()

        if res.code ~= 0 then
            a.api.nvim_err_writeln('touch file failed: ' .. (res.stderr or res.stdout or ''))
            return
        end
    end

    a.schedule().await()

    tree:force_refresh_node(node)
    git.update(tree.cwd)
end)

local function create_node(tree, node)
    node = node:is_dir() and node or node.parent
    local name = vim.fn.input(string.format(
        [[Add a childnode
==========================================================
Enter the dir/file name to be created. Dirs end with a '/'
%s]],
        node.abs_path
    ))

    async_create_node(tree, node, name)
end

local function clear_buffer(path)
    for _, bufnr in ipairs(api.nvim_list_bufs()) do
        if path == api.nvim_buf_get_name(bufnr) then
            api.nvim_buf_delete(bufnr, { force = true })
            return
        end
    end
end

local function delete_node(tree, node)
    if node == tree.root then
        print('You can NOT delete the root')
        return
    end
    if node:is_dir() then
        node:load()
    end
    if node:is_dir() and #node.entries > 0 then
        local answer = vim.fn.input(string.format(
            [[Delete the current node
==========================================================
STOP! Directory is not empty! To delete, type 'yes'

%s: ]],
            node.abs_path
        ))
        if answer:lower() ~= 'yes' then
            return
        end
    end

    a.run(function()
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
end

function M.setup()
    yanil.setup()

    local header = require('yanil/sections/header'):new()
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
            ['<A-/>'] = fzf_find,
            ['<A-a>'] = create_node,
            ['<A-x>'] = delete_node,
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
            header,
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
