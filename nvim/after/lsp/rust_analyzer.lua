return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
        enable = true,
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
      rustfmt = { enableRangeFormatting = true },
    },
  },
}
