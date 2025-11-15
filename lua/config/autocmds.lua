-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- sync system clipboard while yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local v = vim.v.event
    local regcontents = v.regcontents
    vim.defer_fn(function()
      vim.fn.setreg("+", regcontents)
    end, 100)
  end,
})
vim.api.nvim_create_autocmd("FileChangedRO", {
  callback = function()
    vim.cmd('echohl WarningMsg | echo "File changed RO." | echohl None')
  end,
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  callback = function()
    vim.opt.autoread = true
    vim.cmd("checktime")
    vim.cmd('echohl WarningMsg | echo "File changed shell. Auto-reloading..." | echohl None')
  end,
})

-- More aggressive file change detection
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly then
      vim.cmd("silent! checktime")
    end
  end,
})

-- Set global options for better file change handling
vim.opt.autoread = true
vim.opt.autowrite = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
})

-- sync system clipboard to vim clipboard
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local loaded_content = vim.fn.getreg("+")
    if loaded_content ~= "" then
      vim.fn.setreg('"', loaded_content)
    end
    -- Check for external file changes when focus is gained
    vim.cmd("checktime")
  end,
})
