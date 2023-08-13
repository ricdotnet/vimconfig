local set = vim.opt
local api = vim.api
local fn = vim.fn

local colors = {
  light_0 = "#fbf1c7",
  dark = "#1d2021",

  light_2 = "#d5c4a1",

  blue_d = "#458588",
  blue_l = "#83a598",

  yellow_d = "#d79921",
  yellow_l = "#fabd2f",

  purple_d = "#b16286",
  purple_l = "#d3869b",

  red_d = "#cc241d",
  red_l = "#fb4934",

  green_d = "#98971a",
  green_l = "#b8bb26",

  orange_d = "#d65d0e",
  orange_l = "#fe8019",

  gray_d = "#3c3836",
  gray_l = "#504945",
}

local chars = {
  blank = " ",
  arrow = { left = "", right = "" },
  thin = { left = "", right = "" },
  upstream = "  ",
  directory = "  ",
  git = {
    added = "  ",
    changed = "  ",
    removed = "  ",
  },
}

local function getIcon(filename, filetype)
  local icon = ""

  local ok, devicons = pcall(require, "nvim-web-devicons")

  if not ok then
    return icon
  end

  local ft_icon = devicons.get_icon(filename, filetype)
  icon = ft_icon or ""

  return icon
end

local function getMode()
  local mode = api.nvim_get_mode().mode

  local modes = {
    v = "VISUAL",
    n = "NORMAL",
    i = "INSERT",
    c = "COMMAND",
    t = "TERMINAL",
    R = "REPLACE MULTI",
  }

  return modes[mode] or "other"
end

local function getFile()
  local filename = fn.expand "%:t"
  local icon = getIcon("default_icon")

  if filename == nil or filename == "" then
    return icon .. " "
  end

  return getIcon(filename) .. " " .. filename
end

local function getProjectDir()
  local fullPath = os.getenv("PWD") or io.popen("CD"):read("*a")
  local delimiter = "/"

  if fullPath == "" then
    return "N/A"
  end

  if os.getenv("OS") == "Windows_NT" then
    delimiter = "\\"
  end

  local dirParts = {}
  for part in string.gmatch(fullPath, "[^" .. delimiter .. "]+") do
    table.insert(dirParts, part)
  end

  local projectDir = dirParts[#dirParts]

  return getIcon("default_icon") .. " /" .. projectDir
end

local function getGitBranch()
  local branch = ".git not found"

  if fn.isdirectory ".git" ~= 0 then
    branch = vim.fn.system "git branch --show-current"
  end

  return getIcon("github") .. chars["blank"] .. chars["upstream"] .. branch
end

local function getCurrentLsp()
  local lsps = vim.lsp.get_active_clients()
  local lsp = "NO LSP LOADED"

  if not lsps or lsps == nil then
    return lsp
  end

  for _, client in pairs(lsps) do
    if client.attached_buffers[api.nvim_get_current_buf()] and client.name ~= "null-ls" then
      lsp = "   LSP " .. client.name
    end
  end

  return lsp
end

local function getLine()
  return api.nvim_call_function('line', { "." })
end

local function getCol()
  return api.nvim_call_function('col', { "." })
end

local function getLineAndCol()
  return getLine() .. ":" .. getCol()
end

-- BUILD THE LINE --
StatusLine = {}

StatusLine.setup = function()
  set.laststatus = 2

  -- set bar colors
  api.nvim_command("hi Reset guibg=" .. colors["gray_d"] .. " gui=bold")

  -- separators
  api.nvim_command("hi ArrowThin guifg=" .. colors["dark"] .. " guibg=" .. colors["gray_d"])
  api.nvim_command("hi ArrowPurpleD guifg=" .. colors["purple_d"] .. " guibg=" .. colors["purple_l"])
  api.nvim_command("hi ArrowPurpleL guifg=" .. colors["purple_l"] .. " guibg=" .. colors["gray_d"])
  api.nvim_command("hi ArrowBlueD guifg=" .. colors["blue_d"] .. " guibg=" .. colors["blue_l"])
  api.nvim_command("hi ArrowBlueL guifg=" .. colors["blue_l"] .. " guibg=" .. colors["gray_d"])

  -- parts
  api.nvim_command("hi Part1 guibg=" .. colors["purple_d"] .. " guifg=" .. colors["light_0"])
  api.nvim_command("hi Part2 guibg=" .. colors["purple_l"] .. " guifg=" .. colors["dark"])
  api.nvim_command("hi Part3 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["purple_l"])
  api.nvim_command("hi Part4 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_2"])
  api.nvim_command("hi Part5 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_2"])
  api.nvim_command("hi Part6 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["blue_l"])
  api.nvim_command("hi Part7 guibg=" .. colors["blue_l"] .. " guifg=" .. colors["dark"])
  api.nvim_command("hi Part8 guibg=" .. colors["blue_d"] .. " guifg=" .. colors["light_2"])

  -- build the line
  local statusline = {
    "%#Part1#" .. chars["blank"] .. getMode() .. chars["blank"],
    "%#ArrowPurpleD#" .. chars["arrow"]["right"],
    "%#Part2#" .. chars["blank"] .. getFile() .. chars["blank"],
    "%#ArrowPurpleL#" .. chars["arrow"]["right"],
    "%#Part3#" .. chars["blank"] .. getGitBranch() .. chars["blank"],
    "%#ArrowThin#" .. chars["thin"]["right"],
    "%#Part4#" .. chars["blank"] .. "xx xx xx" .. chars["blank"],
    "%#ArrowThin#" .. chars["thin"]["right"],

    -- right side
    "%=",

    "%#ArrowThin#" .. chars["thin"]["left"],
    "%#Part5#" .. chars["blank"] .. "xx xx xx" .. chars["blank"],
    "%#ArrowThin#" .. chars["thin"]["left"],
    "%#Part6#" .. chars["blank"] .. getCurrentLsp() .. chars["blank"],
    "%#ArrowBlueL#" .. chars["arrow"]["left"],
    "%#Part7#" .. chars["blank"] .. getProjectDir() .. chars["blank"],
    "%#ArrowBlueD#" .. chars["arrow"]["left"],
    "%#Part8#" .. chars["blank"] .. getLineAndCol() .. chars["blank"],
  }

  return table.concat(statusline)
end

vim.api.nvim_exec([[
  augroup Statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufEnter * setlocal statusline=%!v:lua.StatusLine.setup()
  augroup END
]], false)
