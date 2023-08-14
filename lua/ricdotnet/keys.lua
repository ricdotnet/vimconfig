local map = vim.keymap.set

vim.g.mapleader = "."

--map("", "<Leader>b", ":b")
map("", "<C-w>", ":bd<Enter>") -- close current file

-- telescope
map("", "<Leader>ff", ":Telescope find_files<Enter>")           -- show list of files
map("", "<Leader>b", ":Telescope buffers<Enter>")               -- show current buffers
map("", "<C-f>", ":Telescope current_buffer_fuzzy_find<Enter>") -- find in file

-- terminal
map("t", "<Esc>", "<C-\\><C-n>")           -- terminal to normal mode
map("", "<Leader>tt", ":terminal<Enter>i") -- new terminal

-- editor
map("", "<C-l>", ":lua vim.lsp.buf.format()<Enter>") -- format the current file
map("", "<C-k>", ":lua vim.lsp.buf.hover()<Enter>")  -- show function definition
