local set = vim.opt
local api = vim.api
local fn = vim.fn
local cmd = api.nvim_command

local job = require("plenary.job")

local colors = {
  dark = "#1d2021",

  light_0 = "#fbf1c7",
  light_2 = "#d5c4a1",
  light_4 = "#a89984",

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
  watch = " 󰥔 ",
  config = "  ",
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

  return modes[mode] or mode
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
  local projectDir = fn.fnamemodify(fn.getcwd(), ":t")

  return getIcon("default_icon") .. " /" .. projectDir
end

local function getGitBranch()
  if not vim.g.gitsigns_head then
    return ""
  end

  --return getIcon("github") .. chars["blank"] .. chars["upstream"] .. vim.b.gitsigns_head
  return chars["upstream"] .. vim.g.gitsigns_head
end

local function getGitStats()
  if vim.o.columns < 120 then
    return ""
  end

  if not vim.b.gitsigns_head or not vim.g.gitsigns_head then
    return ""
  end

  local git = vim.b.gitsigns_status_dict

  local added = (git.added and git.added ~= 0) and (chars["git"]["added"] .. git.added) or ""
  local changed = (git.changed and git.changed ~= 0) and (chars["git"]["changed"] .. git.changed) or ""
  local removed = (git.removed and git.removed ~= 0) and (chars["git"]["removed"] .. git.removed) or ""

  if added == "" and changed == "" and removed == "" then
    return ""
  end

  return added .. chars["blank"] .. changed .. chars["blank"] .. removed
end

local function getCurrentLsp()
  local lsps = vim.lsp.get_active_clients()
  local lsp = chars["config"]

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

-- TODO: refactor using timers from luv
local startTime = os.time()
local wakatime = ""

local function runWTJob()
  job:new({
    command = "wakatime-cli",
    args = { "--today" },
    on_exit = function(j, _)
      wakatime = j:result()[1] or ""
    end,
  }):start()
  startTime = os.time()
end
runWTJob() -- run once on start

local function getWakaTimeStats()
  if vim.o.columns < 120 then
    return ""
  end

  -- every 5 minutes
  if os.time() - startTime >= (60 * 5) then
    runWTJob()
    startTime = os.time()
  end

  return chars["watch"] .. chars["blank"] .. wakatime .. chars["blank"]
end

-- BUILD THE LINE --
StatusLine = {}

StatusLine.setup = function()
  set.laststatus = 2

  -- set bar colors
  cmd("hi Reset guibg=" .. colors["gray_d"] .. " gui=bold")

  -- separators
  cmd("hi ArrowThin guifg=" .. colors["dark"] .. " guibg=" .. colors["gray_d"])
  cmd("hi ArrowPurpleD guifg=" .. colors["purple_d"] .. " guibg=" .. colors["purple_l"])
  cmd("hi ArrowPurpleL guifg=" .. colors["purple_l"] .. " guibg=" .. colors["gray_d"])
  cmd("hi ArrowBlueD guifg=" .. colors["blue_d"] .. " guibg=" .. colors["blue_l"])
  cmd("hi ArrowBlueL guifg=" .. colors["blue_l"] .. " guibg=" .. colors["gray_d"])

  -- parts
  cmd("hi Part1 guibg=" .. colors["purple_d"] .. " guifg=" .. colors["light_0"])
  cmd("hi Part2 guibg=" .. colors["purple_l"] .. " guifg=" .. colors["dark"])
  cmd("hi Part3 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["purple_l"])
  cmd("hi Part4 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_2"])
  cmd("hi Part5 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_2"])
  cmd("hi Part6 guibg=" .. colors["gray_d"] .. " guifg=" .. colors["blue_l"])
  cmd("hi Part7 guibg=" .. colors["blue_l"] .. " guifg=" .. colors["dark"])
  cmd("hi Part8 guibg=" .. colors["blue_d"] .. " guifg=" .. colors["light_2"])
  cmd("hi Middle guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_4"])

  -- build the line
  local statusline = {
    "%#Part1#" .. chars["blank"] .. getMode() .. chars["blank"],
    "%#ArrowPurpleD#" .. chars["arrow"]["right"],
    "%#Part2#" .. chars["blank"] .. getFile() .. chars["blank"],
    "%#ArrowPurpleL#" .. chars["arrow"]["right"],
    "%#Part3#" .. chars["blank"] .. getGitBranch() .. chars["blank"],
    "%#ArrowThin#" .. chars["thin"]["right"],
    "%#Part4#" .. chars["blank"] .. getGitStats() .. chars["blank"],
    "%#ArrowThin#" .. chars["thin"]["right"],

    "%#Middle#",
    -- right side
    "%=",

    getWakaTimeStats(),
    "%#ArrowThin#" .. chars["thin"]["left"],
    "%#Part5#" .. chars["blank"] .. "" .. chars["blank"],
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
