local cmd = vim.cmd

require("onedark").setup {
    style = "deep"
}
require("onedark").load()

cmd.colorscheme "onedark"
