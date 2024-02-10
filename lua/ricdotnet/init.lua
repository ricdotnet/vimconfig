-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require("ricdotnet.lazy")

require("ricdotnet.lsp")
require("ricdotnet.git")
require("ricdotnet.icons")
require("ricdotnet.set")
require("ricdotnet.keys")
require("Comment").setup()

require("ricdotnet.theme").setup("gruvbox")
require("ricdotline").setup({
  wakatime = true,
  theme = "gruvbox",
  separator = "tilt",
})

-- dev
require("ricdotmarker").setup()
