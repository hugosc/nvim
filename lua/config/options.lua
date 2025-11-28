-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.diagnostic.config({ virtual_text = true })
vim.diagnostic.enable(false)

-- Use ripgrep with hidden files enabled for grep operations
vim.o.grepprg = "rg --vimgrep --hidden --no-heading --smart-case"
