--  Highlights the line your cursor is on when it is idle
--
--    local timer = vim.loop.new_timer()
--    timer:start(2000, 0, vim.schedule_wrap(function()
--        if vim.api.nvim_buf_is_loaded(buf) then
--            vim.api.nvim_buf_clear_namespace(buf, src, 0, -1)
--        end
--    end))
--
--

local src = 0

function highlight()
    local buf = vim.api.nvim_get_current_buf()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))
    -- local bufnum, lnum, col, off = unpack(vim.fn.getpos(".")) other method to get line
    src = vim.api.nvim_buf_add_highlight(buf, 0, "IncSearch", r-1, 0, -1)
end


function remove_highlight()
    local buf = vim.api.nvim_get_current_buf()
    local r, c = unpack(vim.api.nvim_win_get_cursor(0))

    if vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_clear_namespace(buf, src, 0, -1)
    end
end


vim.api.nvim_create_autocmd(
    "CursorHold",
    {
        pattern = "*",
        callback = highlight,
        once = false,
    }
)

vim.api.nvim_create_autocmd(
    "CursorMoved",
    {
        pattern = "*",
        callback = remove_highlight,
        once = false,
    }
)
