local U = {}
local fn = vim.fn
local api = vim.api

U.getPaneWidth = function()
  local total_width = api.nvim_win_get_width(0)
  return total_width
end

return U
