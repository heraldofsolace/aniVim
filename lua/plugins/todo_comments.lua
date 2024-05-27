if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end
return {
    "folke/todo-comments.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    opts = {}
}
