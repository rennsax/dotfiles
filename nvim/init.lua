require("rennsax.lazy")

vim.cmd("source ~/.config/nvim/_init.vim")

if vim.g.vscode then
    -- Workaround for gk/gj
    -- See https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
    vim.api.nvim_set_keymap("n", "<Up>", "gk", {})
    vim.api.nvim_set_keymap("n", "<Down>", "gj", {})
    -- show hover
    vim.api.nvim_set_keymap(
        "n", "<Leader>h", ":lua require('vscode-neovim').call('editor.action.showHover')<CR>", {})
    -- code refactor
    vim.api.nvim_set_keymap(
        "n", "<Leader>cr", ":lua require('vscode-neovim').call('editor.action.refactor')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>o", ":lua require('vscode-neovim').call('clangd.switchheadersource')<CR>", {})
    -- update tag
    vim.api.nvim_set_keymap(
        "n", "<Leader>ut", ":lua require('vscode-neovim').call('editor.emmet.action.updateTag')<CR>", {})
    -- show definition
    vim.api.nvim_set_keymap(
        "n", "<Leader>sd", ":lua require('vscode-neovim').call('editor.action.peekDefinition')<CR>", {})
    -- show reference
    vim.api.nvim_set_keymap(
        "n", "<Leader>sr", ":lua require('vscode-neovim').call('editor.action.referenceSearch.trigger')<CR>", {})
    -- toggle dash
    vim.api.nvim_set_keymap(
        "n", "<Leader><C-h>", ":lua require('vscode-neovim').call('extension.dash.specific')<CR>", {})
    -- toggle bookmark
    vim.api.nvim_set_keymap(
        "n", "<Leader>m", ":lua require('vscode-neovim').call('bookmarks.toggle')<CR>", {})
    -- open file manage
    vim.api.nvim_set_keymap(
        "n", "<Leader>f", ":lua require('vscode-neovim').call('workbench.explorer.fileView.focus')<CR>", {})
    -- restart neovim
    vim.api.nvim_set_keymap(
        "n", "<Leader>rn", ":lua require('vscode-neovim').call('vscode-neovim.restart')<CR>", {})
end
