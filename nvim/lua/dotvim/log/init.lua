local vim = vim

local logger = {}

local date_format = '%FT%H:%M:%S%z'

local levels = {
    DEBUG = 0,
    INFO = 1,
    WARN = 2,
    ERROR = 3,
}

do
    for levelname, levelnr in pairs(levels) do
        logger[levelname:lower()] = function(...)
            if levelnr < (vim.g.dotvim_log_level or levels.WARN) then
                return false
            end
            local argc = select('#', ...)
            if argc == 0 then
                return true
            end

            local info = debug.getinfo(2, 'Sl')
            local fileInfo = string.format('%s:%s', info.short_src, info.currentline)
            local prefix = string.format('[%-5s %s %s]:', levelname:lower(), os.date(date_format), fileInfo)
            local parts = { prefix }
            for i = 1, argc do
                local arg = select(i, ...)
                if arg == nil then
                    table.insert(parts, 'nil')
                else
                    table.insert(parts, vim.inspect(arg))
                end
            end
            print(table.concat(parts, ' '))
        end
    end
end

return logger
