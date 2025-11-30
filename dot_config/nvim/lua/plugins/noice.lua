-- { src = "https://github.com/folke/noice.nvim" },

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    presets = {
      lsp_doc_border = true,
      bottom_search = false,
    },
    cmdline = {
      view = "cmdline_popup",
      opts = {},
    },
    views = {
      hover = { scrollbar = false },
      cmdline_popup = {
        position = { row = "40%" },
        size = { width = "auto", height = "auto" },
      },
    },
  },
}
