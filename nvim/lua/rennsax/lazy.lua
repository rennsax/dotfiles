local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { 'wakatime/vim-wakatime', lazy = false },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                search = {
                    enabled = false
                },
                char = {
                    enabled = false,
                    keys = {}
                }
            },
            label = {
                before = true,
                after = false,
            }
        },
        -- See `:help map-table` for the meaning of each abbreviation option.
        -- stylua: ignore
        keys = {
            { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        "vim-scripts/ReplaceWithRegister",
        event = "VeryLazy"
    },
    {
        "haya14busa/vim-asterisk",
        event = "VeryLazy"
    }
})

-- "haya14busa/vim-asterisk"
vim.api.nvim_set_keymap("n", "*", "<Plug>(asterisk-*)", {})
vim.api.nvim_set_keymap("n", "#", "<Plug>(asterisk-#)", {})
vim.api.nvim_set_keymap("n", "g*", "<Plug>(asterisk-g*)", {})
vim.api.nvim_set_keymap("n", "g#", "<Plug>(asterisk-g#)", {})
vim.api.nvim_set_keymap("n", "z*", "<Plug>(asterisk-z*)", {})
vim.api.nvim_set_keymap("n", "gz*", "<Plug>(asterisk-gz*)", {})
vim.api.nvim_set_keymap("n", "z#", "<Plug>(asterisk-z#)", {})
vim.api.nvim_set_keymap("n", "gz#", "<Plug>(asterisk-gz#)", {})