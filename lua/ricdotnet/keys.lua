local map = vim.keymap.set

vim.g.mapleader = "."

-- telescope
map("", "<Leader>ff", ":Telescope find_files<Enter>")

-- editor keys
map("", "<C-l>", ":lua vim.lsp.buf.format()<Enter>")
map("t", "<Esc>", "<C-\\><C-n>")
