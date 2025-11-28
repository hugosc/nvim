-- This is initialised on startup, and config.lazy is called to load the rest of the plugins
require("config.lazy")
-- Setup watcher first to detect and set background, then load colorscheme
require("config.theme-toggle").setup_wal_watcher()
vim.cmd.colorscheme("wal")
require("plugins.zenmode")
vim.g.copilot_filetypes = { markdown = true }
-- This is the transparent scheme I previously used
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "none" })
