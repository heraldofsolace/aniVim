require("zen-mode").setup {}
require('legendary').keymaps({
    {
        '<leader>ze',
        ':ZenMode<cr>',
        description = "Toggle Zen mode",
        opts = {silent = true, noremap = true}
    }
})
