local C = {}

C.gruvbox = {
  a = { fg = "#fbf1c7", bg = "#b16286" },
  b = { fg = "#1d2021", bg = "#d3869b" },
  c = { fg = "#d3869b", bg = "#3c3836" },
  d = { fg = "#d5c4a1", bg = "#3c3836" },
  e = { fg = "#a89984", bg = "#3c3836" },
  f = { fg = "#d5c4a1", bg = "#3c3836" },
  g = { fg = "#83a598", bg = "#3c3836" },
  h = { fg = "#1d2021", bg = "#83a598" },
  i = { fg = "#d5c4a1", bg = "#458588" },
  -- extras
  reset = { bg = "#3c3836" },
  sep = {
    a = { bg = "#d3869b", fg = "#b16286" }, -- left dark
    b = { bg = "#3c3836", fg = "#d3869b" }, -- left light
    c = { bg = "#3c3836", fg = "#1d2021" }, -- thin
    d = { bg = "#3c3836", fg = "#83a598" }, -- right light
    e = { bg = "#83a598", fg = "#458588" }, -- right dark
  },
  diagnostic = {
    bg = "#3c3836",
    error = "#fb4934",
    warn = "#fabd2f",
    hint = "#8ec07c",
    info = "#83a598",
  },
  inactive = { bg = "#3c3836", fg = "#a89984" },
}

-- TODO: add onedark colors
C.onedark = {
  a = { fg = "", bg = "" },
  b = { fg = "", bg = "" },
  c = { fg = "", bg = "" },
  d = { fg = "", bg = "" },
  e = { fg = "", bg = "" },
  f = { fg = "", bg = "" },
  g = { fg = "", bg = "" },
  h = { fg = "", bg = "" },
  i = { fg = "", bg = "" },
  -- extras
  reset = { bg = "" },
  sep = {
    a = { bg = "", fg = "" }, -- left dark
    b = { bg = "", fg = "" }, -- left light
    c = { bg = "", fg = "" }, -- thin
    d = { bg = "", fg = "" }, -- right light
    e = { bg = "", fg = "" }, -- right dark
  },
  inactive = { bg = "", fg = "" }
}

C.material = {
  a = { fg = "#0f111a", bg = "#c3e88d" },
  b = { fg = "#090b10", bg = "#717cb4" },
  c = { fg = "#82aaff", bg = "#4b526d" },
  d = { fg = "#babdc5", bg = "#4b526d" },
  e = { fg = "#babdc5", bg = "#4b526d" },
  f = { fg = "#babdc5", bg = "#4b526d" },
  g = { fg = "#babdc5", bg = "#4b526d" },
  h = { fg = "#090b10", bg = "#717cb4" },
  i = { fg = "#0f111a", bg = "#82aaff" },
  -- extras
  reset = { bg = "#4b526d" },
  sep = {
    a = { bg = "#717cb4", fg = "#c3e88d" }, -- left dark
    b = { bg = "#4b526d", fg = "#717cb4" }, -- left light
    c = { bg = "#4b526d", fg = "#181A1f" }, -- thin
    d = { bg = "#4b526d", fg = "#717cb4" }, -- right light
    e = { bg = "#717cb4", fg = "#82aaff" }, -- right dark
  },
  diagnostic = {
    bg = "#4b526d",
    error = "#ff5370",
    warn = "#ffcb6b",
    hint = "#c792ea",
    info = "#89ddff",
  },
  inactive = { bg = "#171a1f", fg = "#464b5b" }
}

return C
