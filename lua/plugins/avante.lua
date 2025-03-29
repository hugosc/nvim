return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },

    opts = {
      -- MCP Hub Setup
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,

      history = {
        max_tokens = 4090,
      },
      behaviour = {
        enable_token_counting = false,
        enable_claude_text_tool_mode = false,
        use_cwd_as_project_root = true,
        auto_suggestions = false,
      },

      -- Set your primary provider here (pick only one)
      provider = "copilot", -- Choose between: "ollama", "claude", "openrouter", "copilot"

      ollama = {
        endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
        model = "deepseek-r1:1.5b",
      },

      rag_service = {
        enabled = true, -- Enables the RAG service
        host_mount = os.getenv("HOME"), -- Host mount path for the rag service
        provider = "ollama", -- The provider to use for RAG service
        llm_model = "llama3.2:1b", -- The LLM model to use for RAG service
        endpoint = "http://127.0.0.1:11434", -- Must match your Ollama endpoint since provider is "ollama"
      },

      claude = {
        temperature = 0.1,
        model = "claude-3-7-sonnet-20250219",
        max_tokens = 4096,
      },

      copilot = {
        temperature = 0.1,
        model = "claude-3.7-sonnet",
        max_tokens = 4096,
      },

      gemini = {
        temperature = 0.1,
        model = "gemini-2.0-flash",
      },

      vendors = {
        openrouter_deepseek = {
          __inherited_from = "openai",
          disable_tools = true,
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "deepseek/deepseek-r1:free",
        },

        openrouter_gemini = {
          __inherited_from = "openai",
          disable_tools = true,
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "google/gemini-2.0-flash-thinking-exp-1219:free",
          temperature = 0,
        },
      },

      autosuggest_enabled = false,
      autosuggest_provider = "copilot",
    },
  },
}
