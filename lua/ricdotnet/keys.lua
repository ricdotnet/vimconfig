local map = vim.keymap.set

vim.g.mapleader = "."

--map("", "<D-c>", "\"+y")
--map("", "<D-v>", "\"+p")

--map("", "<Leader>b", ":b")
map("n", "<C-q>", ":bd<Enter>")      -- close current filekeys
map("n", "<Leader>ft", ":la<Enter>") -- open the file tree

-- telescope
map("n", "<Leader>ff", ":Telescope find_files<Enter>")           -- show list of files
map("n", "<Leader>b", ":Telescope buffers<Enter>")               -- show current buffers
map("n", "<C-f>", ":Telescope current_buffer_fuzzy_find<Enter>") -- find in file
map("n", "<Leader>gb", ":Telescope git_status<Enter>")           -- list of modified files

-- editor
map("n", "<C-l>", ":lua vim.lsp.buf.format()<Enter>") -- format the current file
map("n", "<C-k>", ":lua vim.lsp.buf.hover()<Enter>")  -- show function definition
map("n", "<Leader>nt", ":tabnew")
map("n", "<Leader>tn", ":tabnext<Enter>")
map("n", "<Leader>tp", ":tabprev<Enter>")
map("n", "<Leader>ntt", ":tabnew term://zsh<Enter>a")        -- new terminal in a new tab

map("n", "gd", ":lua vim.lsp.buf.definition()<Enter>")       -- get a function definition
map("n", "gtd", ":lua vim.lsp.buf.type_definition()<Enter>") -- get a type definition

map("n", "<A-Up>", ":m .-2<Enter>")                          -- move down 1 line
map("n", "<A-Down>", ":m .+1<Enter>")                        -- move up 1 line

-- terminal
map("t", "<Esc>", "<C-\\><C-n>") -- terminal to normal mode
