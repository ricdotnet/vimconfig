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

function setup()
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

function getMode()
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
    return mode
  end
end

function getLine()
  return api.nvim_call_function('line', {"."})
end

function getCol()
  return api.nvim_call_function('col', {"."})
end

function setGitBranch()
  local branch = io.popen([[git rev-parse --abbrev-ref HEAD 2> /dev/null]])
  local name = branch:read("*a")
  branch:close()

  if name then
    return name
  else
    return "N/B"
  end
end

api.nvim_create_augroup("StatusLine", { clear = true })
api.nvim_create_autocmd({
	"WinEnter",
	"BufEnter",
  "*"
}, {
	callback = function()
		set.statusline = setup()
	end
})
