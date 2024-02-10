local T = {}

local themes = {
  gruvbox = "ricdotnet.themes.gruvbox",
  onedark = "ricdotnet.themes.onedark",
  material = "ricdotnet.themes.material",
}

function T.setup(theme)
  local is_valid_theme = true

  if (type(theme) ~= "string") then
    return print("the theme needs to be a string")
  end

  local ok, _ = pcall(require, themes[theme])
  if (not ok) then
    is_valid_theme = false
  end

  if (not is_valid_theme) then
    return print(theme .. " is not a valid theme")
  end
end

return T
