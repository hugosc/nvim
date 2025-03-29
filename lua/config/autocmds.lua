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

0. mcp protocol:
   - perform rag_search based on the query
   - always check mcp memory at the start of each interaction.
   - for complex problems, always use sequential thinking
   - update mcp memory after each interaction that reveals new information using mcp knowledge graph 

1. memory retrieval:
   - always begin your chat by saying only "remembering..." and retrieve all relevant information from your mcp knowledge graph
   - always refer to your knowledge graph as your "memory"

2. memory:
   - while conversing with the user, be attentive to any new information that falls into these categories:
     a) basic identity (age, gender, location, job title, education level, etc.)
     b) behaviors (interests, habits, etc.)
     c) communication and langauge style (communication style, common keywords, etc.)

3. memory update:
   - if any new information was gathered during the interaction, update your memory as follows:
     a) create entities for recurring organizations, people, and significant events
     b) connect them to the current entities using relations
     c) store facts about them as observations]],
    })
  end,
})

vim.keymap.set("n", "<leader>am", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" })
end, { desc = "avante: toggle my prompt" })
