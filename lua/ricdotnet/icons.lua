local custom_icons = {
  default_icon = {
    icon = "",
    name = "default",
    color = "#f5bf0c",
  },
  njk = {
    icon = "",
    name = "nunjucks",
    color = "#1e4114",
  },
  md = {
    icon = "",
    name = "markdown",
    color = "#519aba",
  },
  github = {
    icon = "",
    name = "github",
  },
}

require 'nvim-web-devicons'.setup {
  override = custom_icons,
}
