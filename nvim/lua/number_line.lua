require "ratio"

function precision(f, digits)
    return math.floor(f * (10 * digits)) / (10 * digits)
end

function numberBgColour()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local total = vim.api.nvim_buf_line_count(0)

    ratio = r / total

    local cleaned_ratio = precision(clean_ratio(ratio), 1) -- C function
    if cleaned_ratio == 0 then
        vim.cmd [[ hi CursorLineNr ctermfg=cyan ]]
        return
    end

    -- Colour ref: https://vimdoc.sourceforge.net/htmldoc/syntax.html#:highlight
    local funcs = {
        [0.2] = function() vim.cmd [[ hi CursorLineNr ctermfg=green ]] end,
        [0.4] = function() vim.cmd [[ hi CursorLineNr ctermfg=yellow ]] end,
        [0.6] = function() vim.cmd [[ hi CursorLineNr ctermfg=magenta ]] end,
        [0.8] = function() vim.cmd [[ hi CursorLineNr ctermfg=red ]] end
    }
    -- print("cleaned_ratio", cleaned_ratio)
    local func = funcs[cleaned_ratio]
    if func then func() end
end

local _group = vim.api.nvim_create_augroup("LineNumber", { clear = true })

vim.cmd [[
set cursorline
set relativenumber
set cursorlineopt=both
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
