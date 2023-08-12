return function(_, on_attach)
  require("lspconfig")["lua_ls"].setup {
    on_attach = on_attach,
    settings = {
      Lua = {
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  }
end
