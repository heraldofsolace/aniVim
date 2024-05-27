if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {
    'ms-jpq/chadtree',
    branch = "chad",
    build = "python3 -m chadtree deps",
    config = function()

        require('legendary').keymap({'<leader>ch', '<cmd>CHADopen<CR>'})

    end
}

