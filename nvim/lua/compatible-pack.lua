local state = "redo"

-- TODO: This needs to reset when new changes are made
function ChangeDirection(ev)
    if state == "undo" then
        state = "redo"
    else
        state = "undo"
    end
    NextStep()
end


function NextStep()
    if state == "undo" then
        vim.cmd [[ undo ]]
    else
        vim.cmd [[ redo ]]
    end
end


function ResetState(ev)
    -- print(vim.inspect(ev))
    state = "redo"
end


vim.keymap.set({"n"}, "u", ChangeDirection)
vim.keymap.set({"n"}, "<C-r>", NextStep)

vim.api.nvim_create_autocmd(
    { "InsertChange" },
    {
        pattern = "*",
        callback = ResetState,
        once = false,
    }
)
