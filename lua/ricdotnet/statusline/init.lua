local set = vim.opt
local api = vim.api
local fn = vim.fn
local cmd = api.nvim_command

local job = require("plenary.job")
local utils = require("ricdotnet.utils")

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
  if utils.getPaneWidth() < 120 then
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
  local lsp = ""

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

local function getLineAndCol()
  local current_line = fn.line "."
  local current_col = fn.col "."
  local total_lines = fn.line "$"

  local perc = math.modf((current_line * 100) / total_lines)
  local text = "%%" .. perc

  text = (current_line == 1 and "Top") or text
  text = (current_line == total_lines and "Bot") or text

  return current_line .. ":" .. current_col .. " - " .. text
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
  if utils.getPaneWidth() < 120 then
    return ""
  end

  -- every 5 minutes
  if os.time() - startTime >= (60 * 5) then
    runWTJob()
    startTime = os.time()
  end

  return chars["watch"] .. chars["blank"] .. wakatime .. chars["blank"]
end

-- LINE BUILDER --
local colors = require("ricdotnet.statusline.colors").colors

if vim.g.colors_name == "gruvbox" then
  cmd("hi Reset guibg=" .. colors["gray_d"] .. " gui=bold")
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
  cmd("hi Inactive guibg=" .. colors["gray_d"] .. " guifg=" .. colors["light_4"])
end

StatusLine = {}

StatusLine.active = function()
  set.laststatus = 2

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

function StatusLine.inactive()
  set.laststatus = 2

  local statusline = {
    "%#Inactive#",
    chars["blank"] .. getFile() .. chars["blank"],
    chars["thin"]["right"] .. chars["blank"],
    getGitStats() .. chars["blank"],
    chars["thin"]["right"],
    "%=",
    chars["blank"] .. chars["thin"]["left"] .. chars["blank"],
    getProjectDir() .. chars["blank"],
  }

  return table.concat(statusline)
end

vim.api.nvim_exec([[
  augroup Statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufEnter * setlocal statusline=%!v:lua.StatusLine.active()
    autocmd WinLeave,BufLeave * setlocal statusline=%{%v:lua.StatusLine.inactive()%}
  augroup END
]], false)