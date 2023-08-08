local set = vim.opt
local api = vim.api

local colors = {
  light = "#fbf1c7",
  dark = "#1d2021",
  
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
}

local chars = {
  blank = " ",

  left = "░▒▓",
  right = "▓▒░",

  happy = "",
}

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

  if modes[mode] then
    return modes[mode]
  else
    return "🇴🇹🇭🇪🇷"
  end
end

local function getLine()
  return api.nvim_call_function('line', {"."})
end

local function getCol()
  return api.nvim_call_function('col', {"."})
end

local function setGitBranch()
  local branch = io.popen([[git rev-parse --abbrev-ref HEAD 2> /dev/null]])
  local name = branch:read("*a")
  branch:close()

  if name then
    return name
  else
    return "N/B"
  end
end

-- BUILD THE LINE --
StatusLine = {}

StatusLine.setup = function()
  set.laststatus = 2

  -- set bar colors
  api.nvim_command("hi Reset gui=bold")
  
  api.nvim_command("hi LeftSeparatorPurple guifg=" .. colors["purple_d"])
  api.nvim_command("hi RightReparatorPurple guifg=" .. colors["purple_d"])
  api.nvim_command("hi LeftSeparatorYellow guifg=" .. colors["yellow_d"])
  api.nvim_command("hi RightReparatorYellow guifg=" .. colors["yellow_d"])
  
  api.nvim_command("hi Mode guibg=" .. colors["purple_d"] .. " guifg=" .. colors["light"] .. " gui=bold")
  api.nvim_command("hi LineColumn guibg=" .. colors["yellow_d"] .. " guifg=" .. colors["light"] .. " gui=bold")

  -- build the line
  local statusline = {
    "%#Reset#",

    -- left side
    chars["blank"],

    -- mode styling
    "%#LeftSeparatorPurple#",
    chars["left"],
    "%#Mode#",
    chars["blank"],
    getMode(),
    chars["blank"],
    "%#Reset#",
    "%#RightReparatorPurple#",
    chars["right"],
    "%#Reset#",

    -- right side
    "%=",

    -- line and column
    "%#LeftSeparatorYellow#",
    chars["left"],
    "%#LineColumn#",
    chars["blank"],
    "L:",
    chars["blank"],
    getLine(),
    chars["blank"],
    "C:",
    chars["blank"],
    getCol(),
    chars["blank"],
    "%#Reset#",
    "%#RightReparatorYellow#",
    chars["right"],
    
    -- last space
    chars["blank"],
  }

  return table.concat(statusline)
end

vim.api.nvim_exec([[
  augroup Statusline
    autocmd!
    autocmd VimEnter,BufEnter * setlocal statusline=%!v:lua.StatusLine.setup()
  augroup END
]], false)
