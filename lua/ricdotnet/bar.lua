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
  thin = { left = "", right= "" },
  round = { left = "◖", right = "◗" },
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
    return "other"
  end
end

local function getFile()
  return fn.expand "%:t"
end

local function getProjectDir()
  local fullPath = os.getenv("PWD")

  if fullPath == "" then
    return "N/A"
  end

  local dirParts = {}
  for part in string.gmatch(fullPath, "[^/]+") do
    table.insert(dirParts, part)
  end

  --return #dirParts
  return "/" .. dirParts[#dirParts]
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
  api.nvim_command("hi Reset guibg=" .. colors["gray_d"] .. " gui=bold")
 
  -- separators
  api.nvim_command("hi RightArrowSepPurple guifg=" .. colors["purple_d"] .. " guibg=" .. colors["purple_l"])
  api.nvim_command("hi RightArrowSepPurpleLight guifg=" .. colors["purple_l"] .. " guibg=" .. colors["gray_d"])

  api.nvim_command("hi LeftArrowSepYellow guifg=" .. colors["yellow_d"] .. " guibg=" .. colors["yellow_l"])
  api.nvim_command("hi LeftArrowSepYellowLight guifg=" .. colors["yellow_l"] .. " guibg=" .. colors["gray_d"])

  api.nvim_command("hi RightArrowSepThin guifg=" .. colors["dark"] .. " guibg=" .. colors["gray_d"])
  api.nvim_command("hi LeftArrowSepThin guifg=" .. colors["dark"] .. " guibg=" .. colors["gray_d"])

  -- contents
  api.nvim_command("hi Mode guibg=" .. colors["purple_d"] .. " guifg=" .. colors["light_0"])
  api.nvim_command("hi File guibg=" .. colors["purple_l"] .. " guifg=" .. colors["gray_d"])
  api.nvim_command("hi ProjectDir guibg=" .. colors["yellow_l"] .. " guifg=" .. colors["gray_d"])
  api.nvim_command("hi LineColumn guibg=" .. colors["yellow_d"] .. " guifg=" .. colors["light_0"])

  -- build the line
  local statusline = {
    "%#Mode#",
    chars["blank"],
    getMode(),
    chars["blank"],
    "%#RightArrowSepPurple#",
    chars["arrow"]["right"],

    "%#File#",
    chars["blank"],
    getFile(),
    chars["blank"],
    "%#RightArrowSepPurpleLight#",
    chars["arrow"]["right"],

    chars["blank"],
    -- git branch here
    chars["blank"],
    "%#RightArrowSepThin#",
    chars["thin"]["right"],
    "%#Reset#",

    -- right side
    "%=",

    "%#LeftArrowSepThin#",
    chars["thin"]["left"],
    chars["blank"],
    -- some more content here
    chars["blank"],
    "%#LeftArrowSepYellowLight#",
    chars["arrow"]["left"],
    "%#ProjectDir#",
    chars["blank"],
    getProjectDir(),
    chars["blank"],
    "%#LeftArrowSepYellow#",
    chars["arrow"]["left"],
    "%#LineColumn#",
    chars["blank"],
    "L:",
    getLine(),
    chars["blank"],
    "C:",
    getCol(),
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
