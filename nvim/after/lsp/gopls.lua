return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      buildFlags = { "-tags=wireinject" },
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = false,
      gofumpt = true,
    },
  },
}
