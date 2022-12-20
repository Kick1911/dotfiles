function numberBgColour()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    local total = vim.api.nvim_buf_line_count(0)

    ratio = r / total
    if ratio < 0.2 then
        vim.cmd [[ hi CursorLineNr ctermfg=cyan ]]
    elseif ratio < 0.4 and ratio > 0.2 then
        vim.cmd [[ hi CursorLineNr ctermfg=green ]]
    elseif ratio < 0.6 and ratio > 0.4 then
        vim.cmd [[ hi CursorLineNr ctermfg=yellow ]]
    elseif ratio < 0.8 and ratio > 0.6 then
        vim.cmd [[ hi CursorLineNr ctermfg=magenta ]]
    elseif ratio <= 1 and ratio > 0.8 then
        vim.cmd [[ hi CursorLineNr ctermfg=red ]]
    end
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
