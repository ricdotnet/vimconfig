local set = vim.opt
local api = vim.api

function setup()
  set.laststatus = 2

  -- a table to then join I guess
  local lineParts = {
    setMode(),
    --setGitBranch(),
  }

  -- set.statusline = setGitBranch() .. " - MODE: " .. setMode()
  set.statusline = "MODE: " .. setMode()
end

function setMode()
  local mode = api.nvim_get_mode().mode

  local modes = {
    v = "VISUAL",
    n = "NORMAL",
    i = "INSERT",
    c = "COMMAND",
    t = "TERMINAL",
    R = "REPLACE MULTI",
  }

  return modes[mode]
end

function setGitBranch()
  local branch = io.popen([[git rev-parse --abbrev-ref HEAD]])
  local hello = branch:read("*a")
  branch:close()

  return hello
end

api.nvim_create_autocmd({
    --"BufNewFile",
    --"BufRead",
    "VimEnter",
    --"TextChanged",
    --"TextChangedP",
    "ModeChanged"
  },
  {
    --pattern = "*.yaml,*.yml",
    callback = function()
      setup()
      --if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
        --local buf = vim.api.nvim_get_current_buf()
        --vim.api.nvim_buf_set_option(buf, "filetype", "gotmpl")
      --end
    end
  })
