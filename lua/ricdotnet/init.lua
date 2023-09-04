require("ricdotnet.lazy")
require("ricdotnet.lsp")
require("ricdotnet.git")
require("ricdotnet.icons")
require("ricdotnet.set")
require("ricdotnet.keys")

require("ricdotnet.theme").setup("material")
require("ricdotline").setup {
  wakatime = true,
  theme = "material",
}

require("Comment").setup()

-- dev
require("ricdotmarker").setup()
