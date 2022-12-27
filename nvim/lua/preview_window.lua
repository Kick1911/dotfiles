local moving_window = 0
local r, c = unpack(vim.api.nvim_win_get_position(0))
local width = vim.api.nvim_win_get_width(0)

function open_window(window_id, x, y, height_per, width_per, anchor, zindex)
    -- https://neovim.io/doc/user/api.html#nvim_open_win()
    local height = vim.api.nvim_win_get_height(window_id)
    local width = vim.api.nvim_win_get_width(window_id)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {})

    new_width = math.floor(width * width_per)
    new_height = math.floor(height * height_per)
    local opts = {
        relative = 'win',
        width = new_width,
        height = new_height,
        col = y,
        row = x,
        anchor = anchor,
        style = 'minimal',
        border = 'rounded',
        zindex = zindex
    }
    local win = vim.api.nvim_open_win(
        buf,
        false, -- Do not focus window
        opts
    )
    -- optional: change highlight, otherwise Pmenu is used
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
    return win
end

function updatePreviewWindow(window_id, moving_window)
    local height_per = 0.3
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local main_win_row_count = vim.api.nvim_buf_line_count(0)
    local preview_win_height = vim.api.nvim_win_get_height(window_id)
    local _, c = unpack(vim.api.nvim_win_get_position(window_id))
    local new_height = math.floor(preview_win_height * height_per)

    if moving_window ~= 0 then
        vim.api.nvim_win_close(moving_window, false)
    end

    -- FIXME: this is a hack to force correct behaviour
    if r == main_win_row_count then
        r = r - 1
    end

    return open_window(
        window_id,
        ( ((r-1)/main_win_row_count) * (preview_win_height - new_height)) + 1,
        c + 1,
        height_per,
        0.8,
        'NW',
        101
    )
end

local preview_win = open_window(0, r + 1, c + width - 5, 0.35, 0.05, 'NE', 100)
vim.api.nvim_create_autocmd(
    {"WinEnter", "WinLeave", "CursorMoved"},
    {
        pattern = "*",
        callback = function()
            moving_window = updatePreviewWindow(preview_win, moving_window)
        end,
        once = false,
        group = vim.api.nvim_create_augroup("PreviewWindow", { clear = true })
    }
)
