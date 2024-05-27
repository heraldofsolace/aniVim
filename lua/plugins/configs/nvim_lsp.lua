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

-- Setup neovim lua configuration
require('neodev').setup()

require("neoconf").setup({
    plugins = {lua_ls = {enabled = true, enabled_for_neovim_config = true}}
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