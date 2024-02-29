require("rennsax.lazy")

vim.cmd("source ~/.config/nvim/_init.vim")

if vim.g.vscode then
    -- Workaround for gk/gj
    -- See https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
    vim.api.nvim_set_keymap("n", "<Up>", "gk", {})
    vim.api.nvim_set_keymap("n", "<Down>", "gj", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>t", ":lua require('vscode-neovim').call('workbench.action.terminal.focus')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>h", ":lua require('vscode-neovim').action('editor.action.showHover')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>r", ":lua require('vscode-neovim').action('editor.action.refactor')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>o", ":lua require('vscode-neovim').call('clangd.switchheadersource')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader><leader>t", ":lua require('vscode-neovim').call('editor.emmet.action.updateTag')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader><leader>d", ":lua require('vscode-neovim').call('editor.action.peekDefinition')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader><leader>r", ":lua require('vscode-neovim').call('editor.action.referenceSearch.trigger')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader><C-h>", ":lua require('vscode-neovim').call('extension.dash.specific')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>m", ":lua require('vscode-neovim').call('bookmarks.toggle')<CR>", {})
    vim.api.nvim_set_keymap(
        "n", "<Leader>f", ":lua require('vscode-neovim').call('workbench.explorer.fileView.focus')<CR>", {})
end
