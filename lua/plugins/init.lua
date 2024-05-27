if nixCats('cmp') then require('plugins.configs.coq') end

if nixCats('telescope') then require('plugins.configs.telescope') end

if nixCats('treesitter') then require('plugins.configs.treesitter') end

if nixCats('org') then require('plugins.configs.neorg') end

if nixCats('general') then
    require('plugins.configs.legendary')
    require('plugins.configs.nvim_lsp')
    require('plugins.configs.chadtree')
    require('plugins.configs.gitsigns')
    require('plugins.configs.lualine')
    require('plugins.configs.indent_blankline')
    require('plugins.configs.bufferline')
    require('plugins.configs.hopword')
    require('plugins.configs.trouble')
    require('plugins.configs.which_key')
    require('plugins.configs.tokyonight')
    require('plugins.configs.zen_mode')
    require('plugins.configs.todo_comments')
    require('plugins.configs.schlepp')
    require('plugins.configs.dbui')
    require('plugins.configs.alpha')
end

