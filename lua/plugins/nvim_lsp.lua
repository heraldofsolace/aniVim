if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {

    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        event = {"BufNewFile", "BufReadPost"},
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            --[[ ----------------------------------------- ]]
            --[[ Uh-oh! We don't want to use mason on nix! ]]
            --[[ luckily we have our lazyAdd utility!      ]]
            --[[ We can use it to add true only if not     ]]
            --[[ loaded via nix.                           ]]
            --[[ When NOT loaded in nix                    ]]
            --[[ It returns the 1st value, otherwise,      ]]
            --[[ it returns the 2nd value.                 ]]
            --[[    (or nil if there wasnt one)            ]]
            --[[ ----------------------------------------- ]]
            {
                'williamboman/mason.nvim',
                enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false)
            }, {
                'williamboman/mason-lspconfig.nvim',
                enabled = require('nixCatsUtils.lazyCat').lazyAdd(true, false)
            }, -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            {'j-hui/fidget.nvim', opts = {}},

            -- Additional lua configuration, makes nvim stuff amazing!
            {'folke/neodev.nvim'}, {'folke/neoconf.nvim'}, {
                'ray-x/navigator.lua',
                dependencies = {
                    {
                        'ray-x/guihua.lua',
                        build = require('nixCatsUtils.lazyCat').lazyAdd(
                            'cd lua/fzy && make')
                    }
                }
            }
        },
        config = function()
            local coq = require("coq")
            local lspconfig = require("lspconfig")

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --
            --  If you want to override the default filetypes that your language server will attach to you can
            --  define the property 'filetypes' to the map in question.
            local servers = {
                clangd = {},
                gopls = {},
                pyright = {},
                rust_analyzer = {},
                tsserver = {},
                html = {filetypes = {'html', 'twig', 'hbs'}},
                nixd = {},
                nil_ls = {},
                lua_ls = {
                    Lua = {
                        formatters = {ignoreComments = true},
                        signatureHelp = {enabled = true},
                        diagnostics = {globals = {"nixCats"}}
                    },
                    workspace = {checkThirdParty = true},
                    telemetry = {enabled = false},
                    filetypes = {'lua'}
                }
            }

            local function get_keys(t)
                local keys = {}
                for key, _ in pairs(t) do table.insert(keys, key) end
                return keys
            end

            local server_names = get_keys(servers)

            local on_attach = function(client, bufnr)
                require("navigator.lspclient.mapping").setup({
                    client = client,
                    bufnr = bufnr
                }) -- setup navigator keymaps here,
                require("navigator.dochighlight").documentHighlight(bufnr)
                require("navigator.codeAction").code_action_prompt(bufnr)
            end
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Setup neovim lua configuration
            require('neodev').setup()

            require("neoconf").setup({
                plugins = {
                    lua_ls = {enabled = true, enabled_for_neovim_config = true}
                }
            })

            require("navigator").setup({
                mason = true,
                lsp = {disable_lsp = server_names} -- disable pylsp setup from navigator
            })

            --[[ ------------------------------------- ]]
            --[[ Handling mason is covered in the help ]]
            --[[ See :help nixCats.luaUtils.mason      ]]
            --[[ ------------------------------------- ]]
            if require('nixCatsUtils').isNixCats then
                for server_name, _ in pairs(servers) do
                    require('lspconfig')[server_name].setup(
                        coq.lsp_ensure_capabilities({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = servers[server_name],
                            filetypes = (servers[server_name] or {}).filetypes,
                            cmd = (servers[server_name] or {}).cmd,
                            root_pattern = (servers[server_name] or {}).root_pattern
                        }))
                end
            else
                -- Ensure the servers above are installed
                local mason_lspconfig = require 'mason-lspconfig'

                mason_lspconfig.setup {ensure_installed = vim.tbl_keys(servers)}

                mason_lspconfig.setup_handlers {
                    function(server_name)
                        require('lspconfig')[server_name].setup(
                            coq.lsp_ensure_capabilities({
                                capabilities = capabilities,
                                on_attach = on_attach,
                                settings = servers[server_name],
                                filetypes = (servers[server_name] or {}).filetypes
                            }))
                    end
                }
            end

        end
    }, {'Bekaboo/dropbar.nvim', event = {"BufNewFile", "BufReadPost"}}
}

