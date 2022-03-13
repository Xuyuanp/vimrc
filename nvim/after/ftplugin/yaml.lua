local vim = vim

local a = require('dotvim.util.async')
local api = a.api

local fnamemodify = vim.fn.fnamemodify

local function upper_dir(path)
    return fnamemodify(path, ':h')
end

local detect_helm_ft = a.wrap(function(bufnr, path)
    if not bufnr or not path then
        return
    end

    while path ~= '/' do
        path = upper_dir(path)
        if vim.endswith(path, 'templates') then
            path = upper_dir(path)
            local err, stat = a.uv().fs_stat(path .. '/' .. 'Chart.yaml').await()
            if not err and stat then
                api.nvim_buf_set_option(bufnr, 'filetype', 'helm')
            end
            return
        end
    end
end)

detect_helm_ft(api.nvim_get_current_buf(), vim.fn.expand('%:p'))
