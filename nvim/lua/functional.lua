function reduce(func, l)
    local a = table.remove(l, 1)

    for k,v in ipairs(l) do
        a = func(a, v)
    end
    return a
end
