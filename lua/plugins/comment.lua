if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {
    'numToStr/Comment.nvim',
    enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
    opts = {},
    name = 'comment.nvim'
}
