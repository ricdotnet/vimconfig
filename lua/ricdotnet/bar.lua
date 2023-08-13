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
  round = { left = "◖", right = "◗" },
  upstream = "",
  directory = "",
}

local function getIcon(filename, filetype)
  local icon = ""

  if filetype == "/" then
    return chars["directory"] .. " "
  end

  local ok, devicons = pcall(require, "nvim-web-devicons")

  if not ok then
    return icon
  end

  local ft_icon = devicons.get_icon(filename, filetype)
  icon = (ft_icon ~= nil and " " .. ft_icon) or ""

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

  return table.concat({
    "%#Mode#",
    chars["blank"],
    modes[mode] or "other",
    chars["blank"],
    "%#RightArrowSepPurple#",
    chars["arrow"]["right"],
  })
end

local function getFile()
  local filename = fn.expand "%:t"
  local icon = ""

  if filename ~= nil then
    icon = getIcon(filename)
  end

  return table.concat({
    "%#File#",
    icon .. " " .. filename,
    chars["blank"],
    "%#RightArrowSepPurpleLight#",
    chars["arrow"]["right"],
  })
end

local function getProjectDir()
  local fullPath = os.getenv("PWD") or io.popen("CD"):read("*a")

  if fullPath == "" then
    return "N/A"
  end

  local dirParts = {}
  for part in string.gmatch(fullPath, "[^/]+") do
    table.insert(dirParts, part)
  end

  local projectDir = dirParts[#dirParts]

  --return #dirParts
  return getIcon("nvim", "/") .. "/" .. projectDir
end

local function getLine()
  return api.nvim_call_function('line', { "." })
end

local function getCol()
  return api.nvim_call_function('col', { "." })
end

local function getGitBranch()
  local branch = ".git not found"

  if fn.isdirectory ".git" ~= 0 then
    branch = vim.fn.system "git branch --show-current"
  end

  --return "no .git found"
  return table.concat({
    chars["blank"],
    chars["upstream"],
    chars["blank"],
    branch,
    chars["blank"],
    "%#RightArrowSepThin#",
    chars["thin"]["right"],
    "%#Reset#",
  })
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
    getMode(),
    getFile(),
    getGitBranch(),

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
