local cmd = vim.cmd

require("onedarkpro").setup()

require("onedark").setup {
  style = "deep"
}
require("onedark").load()

cmd.colorscheme "onedark_dark"
