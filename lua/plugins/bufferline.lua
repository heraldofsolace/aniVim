if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end
return {
    'akinsho/bufferline.nvim',
    version = "v4.6.0",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {}
}
