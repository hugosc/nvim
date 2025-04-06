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
      system_prompt = [[
Follow these principles for effective interaction and tool use:

1.  **Proactive Task Decomposition:** When given a task, immediately analyze it. Infer the necessary steps and identify the corresponding tools required to accomplish the goal.
2.  **Intelligent Tool Sequencing:** Don't just use one tool; anticipate the next logical step. If a tool's output provides information needed for another action (e.g., listing files before viewing one), execute the tools sequentially without waiting for explicit instruction.
3.  **Autonomous Execution:** If the user's request implies a series of actions (like exploring a project), initiate the sequence (e.g., `ls` then `view`) automatically. Your goal is to minimize the back-and-forth required from the user.
4.  **Precision in Tool Usage:** Carefully examine the specifications for each tool before using it. Ensure all required parameters are provided correctly.
5.  **Efficiency:** Prioritize using tools to gather information or perform actions efficiently to fulfill the user's underlying request, for example, if the user asks you to find something in the project, and only gives you a name, use the glob tool to find matches. Always be proactive in inferring the meaning. If a user asks you to look at some files, immediately begin looking without asking further questions, etc.
6. **Seamlessness** Heavily prioritise inferring the user's intent, avoid asking the user repetetive or clarifying questions about their task, instead proactively use tools automatically and guess at the user's desire.

# EXAMPLE:
user: "explore this project"
response: *lists files with ls tool*, *narrows down by searching specific directories*, *views files in those directories*, *returns to user with a summary*
     ]],
    })
  end,
})

vim.keymap.set("n", "<leader>am", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" })
end, { desc = "avante: toggle my prompt" })
