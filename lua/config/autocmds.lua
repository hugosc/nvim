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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set(
      "n",
      "<leader>a+",
      "<cmd>AiderTreeAddFile<cr>",
      { desc = "Add File from Tree to Aider", buffer = bufnr, noremap = true, silent = true }
    )
    vim.keymap.set(
      "n",
      "<leader>a-",
      "<cmd>AiderTreeDropFile<cr>",
      { desc = "Drop File from Tree from Aider", buffer = bufnr, noremap = true, silent = true }
    )
  end,
  desc = "Aider NvimTree Keymaps",
})

-- sync system clipboard to vim clipboard
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local loaded_content = vim.fn.getreg("+")
    if loaded_content ~= "" then
      vim.fn.setreg('"', loaded_content)
    end
  end,
})

-- Create a variable to track the prompt state
local prompt_active = false

vim.api.nvim_create_autocmd("User", {
  pattern = "ToggleMyPrompt",
  callback = function()
    prompt_active = not prompt_active
    local message = prompt_active and "Custom system prompt activated" or "Custom system prompt deactivated"
    vim.notify(message, vim.log.levels.INFO)
    require("avante.config").override({
      system_prompt = [[Follow these steps for each interaction:
- You are an intelligent assistant. You are a helpful and knowledgeable assistant.
- When given a task, first infer what tools may be used to get it done. 
- Infer based on the request whether to use tools immediately. For example, if the user asks "explore my project", you should immediately and automatically list files and begin exploring them.
- This is important to reduce the amount of instructions needed from the user.
- If the user asks a question that may require the use of tools, prioritise inferring the rough idea of what they would want, then use the tools without asking.
     ]],
    })
  end,
})

vim.keymap.set("n", "<leader>am", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" })
end, { desc = "avante: toggle my prompt" })
