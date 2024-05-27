if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {"folke/twilight.nvim", opts = {}}
