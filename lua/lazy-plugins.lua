--[[ ------------------------------------- ]] --[[ This is our lazy wrapper. First we    ]] --[[ combine our plugin names into 1 list  ]] --[[ or table, then we override any that   ]] --[[ have a different name when loaded via ]] --[[ nix. Then we also get the lazy path   ]] --[[ ------------------------------------- ]] local 
    pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
    local allPlugins = require("nixCats").pawsible.allPlugins
    -- it is called pluginList because we only need to pass in the names
    pluginList = require('nixCatsUtils.lazyCat').mergePluginTables(
                     allPlugins.start, allPlugins.opt)
    -- it wasnt detecting these because the names are slightly different.
    -- when that happens, add them to the list, then also specify name in the lazySpec
    pluginList[ [[Comment.nvim]] ] = ""
    pluginList[ [[LuaSnip]] ] = ""
    nixLazyPath = allPlugins.start[ [[lazy.nvim]] ]
end

--[[ ------------------------------------------- ]]
--[[ this is just the options set that is passed ]]
--[[ in as the second argument to the normal     ]]
--[[ require('lazy').setup({},{}) function.      ]]
--[[ ------------------------------------------- ]]
local lazyOptions = {lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"}

--[[ ------------------------------------------- ]]
--[[ and now we call our wrapper, passing it our ]]
--[[ plugin name list(or table),                 ]]
--[[ and our lazypath when loaded via nix.       ]]
--[[ after that we just pass in the normal 2     ]]
--[[ remaining arguments to the lazy setup()     ]]
--[[ ------------------------------------------- ]]
require('nixCatsUtils.lazyCat').setup(pluginList, nixLazyPath, 'plugins', -- {
--     {
--         "nvim-neotest/nvim-nio",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('debug')
--     }, {
--         "mfussenegger/nvim-dap",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('debug')
--     }, {
--         "rcarriga/nvim-dap-ui",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('debug'),
--         dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
--     }, {
--         "theHamsta/nvim-dap-virtual-text",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('debug')
--     }, {
--         'mfussenegger/nvim-lint',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('lint')
--     }, -- configure
--     {
--         'stevearc/conform.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('format'),
--         opts = {}
--     }, {
--         'm-demare/hlargs.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins'),
--         name = 'hlargs'
--     }, {
--         "kdheepak/lazygit.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins'),
--         dependencies = {"nvim-lua/plenary.nvim"}
--     }, {
--         'ms-jpq/coq_nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
--         branch = 'coq',
--         init = function() vim.g.coq_settings = {auto_start = 'shut-up'} end
--     }, {
--         'ms-jpq/coq.artifacts',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
--         branch = 'artifacts'
--     }, {
--         'ms-jpq/coq.thirdparty',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('cmp'),
--         branch = '3p'
--     }, {
--         -- LSP Configuration & Plugins
--         'neovim/nvim-lspconfig',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         dependencies = {
--             -- Automatically install LSPs to stdpath for neovim
--             --[[ ----------------------------------------- ]]
--             --[[ Uh-oh! We don't want to use mason on nix! ]]
--             --[[ luckily we have our lazyAdd utility!      ]]
--             --[[ We can use it to add true only if not     ]]
--             --[[ loaded via nix.                           ]]
--             --[[ When NOT loaded in nix                    ]]
--             --[[ It returns the 1st value, otherwise,      ]]
--             --[[ it returns the 2nd value.                 ]]
--             --[[    (or nil if there wasnt one)            ]]
--             --[[ ----------------------------------------- ]]
--             {
--                 'williamboman/mason.nvim',
--                 enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false)
--             }, {
--                 'williamboman/mason-lspconfig.nvim',
--                 enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false)
--             }, -- Useful status updates for LSP
--             -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--             {'j-hui/fidget.nvim', opts = {}},
--             -- Additional lua configuration, makes nvim stuff amazing!
--             {'folke/neodev.nvim'}, {'folke/neoconf.nvim'}
--         }
--     }, {'Bekaboo/dropbar.nvim'}, {
--         'nvim-telescope/telescope.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('telescope'),
--         branch = '0.1.x',
--         cmd = 'Telescope',
--         dependencies = {{'nvim-lua/plenary.nvim'}}
--     }, {
--         "nvim-telescope/telescope-frecency.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('telescope') -- config
--     }, {
--         -- Highlight, edit, and navigate code
--         'nvim-treesitter/nvim-treesitter',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('treesitter'),
--         dependencies = {{'nvim-treesitter/nvim-treesitter-textobjects'}},
--         build = require('nixCatsUtils.lazyCat').lazyAdd(':TSUpdate')
--     }, {
--         'vimwiki/vimwiki',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('org')
--     }, {
--         "nvim-neorg/neorg",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('org'),
--         dependencies = {
--             "nvim-lua/plenary.nvim", "nvim-neorg/lua-utils.nvim",
--             'MunifTanjim/nui.nvim', "nvim-neotest/nvim-nio",
--             "pysan3/pathlib.nvim"
--         },
--         config = function() require('plugins.configs.neorg') end
--     }, {
--         'wakatime/vim-wakatime',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('org')
--     }, {
--         'tpope/vim-rails',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('ruby')
--     }, {
--         -- Set lualine as statusline
--         'nvim-lualine/lualine.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         -- Adds git related signs to the gutter, as well as utilities for managing changes
--         'lewis6991/gitsigns.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'folke/which-key.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         opts = {}
--     }, -- "gc" to comment visual regions/lines
--     {
--         'numToStr/Comment.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         opts = {},
--         name = 'comment.nvim'
--     }, {
--         'tpope/vim-sleuth',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-fugitive',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-rhubarb',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-repeat',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-dadbod',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'kristijanhusak/vim-dadbod-ui',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-eunuch',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-projectionist',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'tpope/vim-speeddating',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         -- Add indentation guides even on blank lines
--         'lukas-reineke/indent-blankline.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         -- Enable `lukas-reineke/indent-blankline.nvim`
--         -- See `:help ibl`
--         main = 'ibl',
--         opts = {}
--     }, {
--         'gcmt/wildfire.vim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'gpanders/editorconfig.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'rktjmp/lush.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, -- }, {
--     --     'smoka7/hop.nvim',
--     --     enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     -- }, -- config
--     {
--         "folke/trouble.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         dependencies = {"nvim-tree/nvim-web-devicons"}
--     }, {
--         'ms-jpq/chadtree',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         branch = "chad",
--         build = "python3 -m chadtree deps"
--     }, {
--         "christoomey/vim-tmux-navigator",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general') -- config
--     }, {
--         'goolord/alpha-nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         dependencies = {'kyazdani42/nvim-web-devicons'}
--     }, {
--         "folke/todo-comments.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         dependencies = {"nvim-lua/plenary.nvim"}
--     }, {
--         "folke/twilight.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'direnv/direnv.vim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'lervag/vimtex',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'junegunn/vim-peekaboo',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'b3nj5m1n/kommentary',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'mrjones2014/legendary.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         dependencies = 'kkharji/sqlite.lua',
--         priority = 500
--     }, {
--         'akinsho/bufferline.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         version = "v4.6.0",
--         dependencies = 'kyazdani42/nvim-web-devicons'
--     }, {
--         "okuuva/auto-save.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         event = {"InsertLeave", "TextChanged"}
--     }, {
--         'stevearc/dressing.nvim',
--         opts = {},
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         "m4xshen/hardtime.nvim",
--         dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim"},
--         opts = {},
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {
--         'zirrostig/vim-schlepp',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general')
--     }, {"folke/tokyonight.nvim", priority = 1000}, {
--         'kdheepak/lazygit.nvim',
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('gitPlugins')
--     }, {
--         "ellisonleao/glow.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('markdown'),
--         config = true,
--         cmd = "Glow"
--     }, {
--         "folke/zen-mode.nvim",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         lazy = true,
--         cmd = "ZenMode"
--     }, {"nvim-tree/nvim-web-devicons", lazy = true}, {
--         "folke/flash.nvim",
--         event = "VeryLazy",
--         enabled = require('nixCatsUtils.lazyCat').enableForCategory('general'),
--         opts = {},
--         keys = {
--             {
--                 "s",
--                 mode = {"n", "x", "o"},
--                 function() require("flash").jump() end,
--                 desc = "Flash"
--             }, {
--                 "S",
--                 mode = {"n", "x", "o"},
--                 function() require("flash").treesitter() end,
--                 desc = "Flash Treesitter"
--             }, {
--                 "r",
--                 mode = "o",
--                 function() require("flash").remote() end,
--                 desc = "Remote Flash"
--             }, {
--                 "R",
--                 mode = {"o", "x"},
--                 function() require("flash").treesitter_search() end,
--                 desc = "Treesitter Search"
--             }, {
--                 "<c-s>",
--                 mode = {"c"},
--                 function() require("flash").toggle() end,
--                 desc = "Toggle Flash Search"
--             }
--         }
--     }
-- }, 
lazyOptions)
