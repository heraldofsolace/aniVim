if not require('nixCatsUtils.lazyCat').enableForCategory('general') then
    return {}
end

return {
    'goolord/alpha-nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        local function button(sc, txt, keybind)
            local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

            local opts = {
                position = "center",
                text = txt,
                shortcut = sc,
                cursor = 5,
                width = 36,
                align_shortcut = "right",
                hl = "AlphaButtons"
            }

            if keybind then
                opts.keymap = {
                    "n", sc_, keybind, {noremap = true, silent = true}
                }
            end

            return {
                type = "button",
                val = txt,
                on_press = function()
                    local key = vim.api.nvim_replace_termcodes(sc_, true, false,
                                                               true)
                    vim.api.nvim_feedkeys(key, "normal", false)
                end,
                opts = opts
            }
        end

        local default = {}

        default.ascii = {
            "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
            "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
            "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
            "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
            "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
            "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
            "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
            " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
            " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
            "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
            "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     "
        }

        default.header = {
            type = "text",
            val = default.ascii,
            opts = {position = "center", hl = "AlphaHeader"}
        }

        default.buttons = {
            type = "group",
            val = {
                button("SPC f f", "  Find File  ",
                       ":Telescope find_files<CR>"),
                button("SPC f o", "  Recent File  ",
                       ":Telescope oldfiles<CR>"),
                button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
                button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
                button("SPC e s", "  Settings",
                       ":e $MYVIMRC | :cd %:p:h <CR>")
            },
            opts = {spacing = 1}
        }

        require('alpha').setup {
            layout = {
                {type = "padding", val = 9}, default.header,
                {type = "padding", val = 2}, default.buttons
            },
            opts = {}
        }
    end
}

