require('legendary').keymap({
    '<leader>db',
    ':DBUI<cr>',
    opts = {silent = true, noremap = true}
})