local A = {}

A.config = function ()
  local _alpha = require("alpha")
  local _dashboard = require("alpha.themes.dashboard")

  -- Set header
  _dashboard.section.header.val = {
    "                                                            ",
    "  ███████╗ ██╗ ██████╗ ██████╗ ███████╗ ███████╗  ██████╗   ",
    "  ██╔═══██╗██║██╔════╝██╔═══██╗██╔═══██╗██╔═══██╗██╔═══██╗  ",
    "  ██║   ██║██║██║     ██║   ██║██║   ██║██║   ██║██║   ██║  ",
    "  ███████═╝██║██║     ████████║███████═╝██║   ██║██║   ██║  ",
    "  ██╔══██╗ ██║██║     ██╔═══██║██╔══██╗ ██║   ██║██║   ██║  ",
    "  ██║  ╚██╗██║ ██████╗██║   ██║██║  ╚██╗███████╔╝╚██████╔╝  ",
    "  ╚═╝   ╚═╝╚═╝ ╚═════╝╚═╝   ╚═╝╚═╝   ╚═╝╚══════╝  ╚═════╝   ",
    "                                                            ",
  }

  -- Set menu
  _dashboard.section.buttons.val = {
    _dashboard.button("f", " 🎄  Find file", ":Telescope find_files<CR>"),
    -- _dashboard.button("p", " 🌳  Projects", ":Telescope projects<CR>"),
    _dashboard.button("r", " 🚀  Recent", ":Telescope oldfiles<CR>"),
    -- _dashboard.button("s", " 🔬  Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    _dashboard.button("q", " 🏓  Quit NVIM", ":qa<CR>"),
  }

    -- Send config to alpha
  _alpha.setup(_dashboard.opts)

  -- Disable folding on alpha buffer
  vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
    Alpha
  ]])
end

return A
