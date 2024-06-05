if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = {"nvim-tree/nvim-web-devicons"}
}
