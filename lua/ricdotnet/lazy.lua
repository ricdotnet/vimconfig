local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  -- lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  { "nvim-telescope/telescope.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "dasupradyumna/midnight.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
  { "ray-x/lsp_signature.nvim" },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "nvim-tree/nvim-web-devicons" },
  --{ "Glench/Vim-Jinja2-Syntax" },
  { "lepture/vim-jinja" },
  { "lewis6991/gitsigns.nvim" },
  { "wakatime/vim-wakatime" },
  { "dense-analysis/ale" },
})
