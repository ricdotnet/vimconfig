return function(capabilities, on_attach)
  require("lspconfig")["emmet_language_server"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "njk", "jinja" },
  }
end
