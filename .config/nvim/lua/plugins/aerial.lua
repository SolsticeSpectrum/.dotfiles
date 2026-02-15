return {
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        default_direction = "right",
        placement = "edge",
      },
      attach_mode = "global",
      close_automatic_events = {},
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },
}
