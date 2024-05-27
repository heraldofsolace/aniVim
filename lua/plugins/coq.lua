if not require('nixCatsUtils.lazyCat').enableForCategory('cmp') then return {} end

return {
    {
        'ms-jpq/coq_nvim',
        enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
        branch = 'coq',
        init = function() vim.g.coq_settings = {auto_start = 'shut-up'} end
    }, {
        'ms-jpq/coq.artifacts',
        enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
        branch = 'artifacts'
    }, {
        'ms-jpq/coq.thirdparty',
        enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
        branch = '3p',
        config = function()
            require("coq_3p") {
                {src = 'repl', sh = 'fish'},
                {src = "nvimlua", short_name = "nLUA", conf_only = true},
                {src = "bc", short_name = "MATH", precision = 6},
                {src = "figlet", short_name = "BIG"},
                {src = "vimtex", short_name = "vTEX"}
            }
        end
    }
}

