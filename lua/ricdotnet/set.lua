local set = vim.opt
local cmd = vim.cmd

-- some options
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true

set.wrap = true
set.breakindent = true

set.number = true
set.relativenumber = true

set.hlsearch = false

set.ignorecase = true
set.smartcase = true

set.tw = 120

set.showtabline = 2
set.colorcolumn = "120"

-- set commands
cmd [[set splitright]]
cmd [[set noshowmode]]
