if not require('nixCatsUtils.lazyCat').enableForCategory('debug') then return {} end
return {
    {"nvim-neotest/nvim-nio"}, {"mfussenegger/nvim-dap"}, {
        "rcarriga/nvim-dap-ui",

        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    }, {"theHamsta/nvim-dap-virtual-text"}
}
