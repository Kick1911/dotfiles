require "functional"

function numberBgColour()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local total = vim.api.nvim_buf_line_count(0)

    ratio = r / total
    cleaned_ratio = reduce(
        function(a, b)
            if math.floor(ratio / b) == 1 then
                return b
            elseif math.floor(ratio / a) == 1 then
                return a
            else
                return 0
            end
        end,
        {0.2, 0.4, 0.6, 0.8}
    )

    if cleaned_ratio == 0 then
        vim.cmd [[ hi CursorLineNr ctermfg=cyan ]]
        return
    end

    local funcs = {
        [0.2] = function() vim.cmd [[ hi CursorLineNr ctermfg=green ]] end,
        [0.4] = function() vim.cmd [[ hi CursorLineNr ctermfg=yellow ]] end,
        [0.6] = function() vim.cmd [[ hi CursorLineNr ctermfg=magenta ]] end,
        [0.8] = function() vim.cmd [[ hi CursorLineNr ctermfg=red ]] end
    }
    print("cleaned_ratio", cleaned_ratio)
    local func = funcs[cleaned_ratio]
    if func then func() end
end

local _group = vim.api.nvim_create_augroup("LineNumber", { clear = true })

vim.cmd [[
set cursorline
set cursorlineopt=number
hi CursorLineNr cterm=bold
]]
vim.api.nvim_create_autocmd(
    "CursorMoved",
    {
        pattern = "*",
        callback = numberBgColour,
        once = false,
        group = _group
    }
)
