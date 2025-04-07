return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    -- event = { "BufReadPre", "BufNewFile" },
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom",
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        accept = false,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
      },
    },
    copilot_node_command = "node",
    server_opts_overrides = {},
  },
}
