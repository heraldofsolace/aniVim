if not require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins') then
    return {}
end

return {
    {
        'm-demare/hlargs.nvim',
        enabled = require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins'),
        name = 'hlargs'
    }, {
        "kdheepak/lazygit.nvim",
        enabled = require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins'),
        dependencies = {"nvim-lua/plenary.nvim"}
    }
}
