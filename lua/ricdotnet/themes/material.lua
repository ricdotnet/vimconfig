require("material").setup({
  contrast = {
    terminal = true,                -- Enable contrast for the built-in terminal
    sidebars = true,                -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true,        -- Enable contrast for floating windows
    cursor_line = true,             -- Enable darker background for the cursor line
    non_current_windows = true,     -- Enable contrasted background for non-current windows
    filetypes = {},                  -- Specify which filetypes get the contrasted (darker) background
  },
})

vim.g.material_style = "deep ocean"
vim.cmd "colorscheme material"
