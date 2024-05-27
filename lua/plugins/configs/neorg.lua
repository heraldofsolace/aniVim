require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.concealer"] = {}, -- Allows for use of icons
        ["core.dirman"] = { -- Manage your directories with Neorg
            config = {workspaces = {my_workspace = "~/neorg"}}
        }
    }
}
