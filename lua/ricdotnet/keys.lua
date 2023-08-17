local map = vim.keymap.set

vim.g.mapleader = "."

--map("", "<D-c>", "\"+y")
--map("", "<D-v>", "\"+p")

--map("", "<Leader>b", ":b")
map("", "<C-q>", ":bd<Enter>") -- close current filekeys

-- telescope
map("", "<Leader>ff", ":Telescope find_files<Enter>")           -- show list of files
map("", "<Leader>b", ":Telescope buffers<Enter>")               -- show current buffers
map("", "<C-f>", ":Telescope current_buffer_fuzzy_find<Enter>") -- find in file
map("", "<Leader>gb", ":Telescope git_status<Enter>")           -- list of modified files

-- terminal
map("t", "<Esc>", "<C-\\><C-n>") -- terminal to normal mode

-- editor
map("", "<C-l>", ":lua vim.lsp.buf.format()<Enter>") -- format the current file
map("", "<C-k>", ":lua vim.lsp.buf.hover()<Enter>")  -- show function definition
map("", "<Leader>nt", ":tabnew")
map("", "<Leader>tn", ":tabnext<Enter>")
map("", "<Leader>tp", ":tabprev<Enter>")
map("", "<Leader>ntt", ":tabnew term://zsh<Enter>a")         -- new terminal in a new tab

map("n", "gd", ":lua vim.lsp.buf.definition()<Enter>")       -- get a function definition
map("n", "gtd", ":lua vim.lsp.buf.type_definition()<Enter>") -- get a type definition

map("n", "<A-Up>", ":m .-2<Enter>")                          -- move down 1 line
map("n", "<A-Down>", ":m .+1<Enter>")                        -- move up 1 line
