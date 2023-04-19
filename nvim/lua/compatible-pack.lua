local state = "redo"

function ChangeDirection()
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

vim.keymap.set({"n"}, "u", ChangeDirection)
vim.keymap.set({"n"}, "<C-r>", NextStep)
