if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {'folke/which-key.nvim', opts = {}}
