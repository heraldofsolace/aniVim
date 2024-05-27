if not require('nixCatsUtils.lazyCat').enableForCategory('dev.ruby') then
    return {}
end

return {'tpope/vim-rails'}
