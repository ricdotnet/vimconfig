local set = vim.opt
local api = vim.api

local colors = {
  white_bg = "#FFFFFF",
  black_bg = "#000000",
  
  purple = "#bd93f9",
  blue = "#8be9fd",
  yellow = "#f1fa8c",
  green = "#50fa7b",
  red = "#ff5555",

  blank = " ",
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
    return "no mode"
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
  api.nvim_command("hi Mode guibg=" .. colors["purple"] .. " guifg=" .. colors["white_bg"] .. " gui=bold")

  -- build the line
  local statusline = ""
  statusline = statusline .. "%#Mode#" .. getMode() .. "%#Reset#"

  statusline = statusline .. "%= Ln: " .. getLine() .. " :: Col: " .. getCol()

  return statusline
end

vim.api.nvim_exec([[
  augroup Statusline
  autocmd!
  autocmd VimEnter,BufEnter * setlocal statusline=%!v:lua.StatusLine.setup()
  augroup END
]], false)
