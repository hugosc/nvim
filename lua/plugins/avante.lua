return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false,
    build = "make",
    dir = "~/avantegeminitools/",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },

    opts = {

      --      rag_service = {
      --       enabled = true, -- Enables the RAG service
      --      host_mount = os.getenv("HOME"), -- Host mount path for the rag service
      --        provider = "gemini", -- The provider to use for RAG service
      --       llm_model = "models/gemini-2.0-flash", -- The LLM model to use for RAG service
      --      embed_model = "models/text_embed-004",
      --     endpoint = "https://generativelanguage.googleapis.com/v1beta/openai/", -- Must match your Ollama endpoint since provider is "ollama"
      --  },

      -- General settings
      behaviour = {
        enable_token_counting = false,
        enable_claude_text_tool_mode = false,
        --        enable_cursor_planning_mode = true,
        use_cwd_as_project_root = true,
        auto_suggestions = false,
      },

      history = {
        max_tokens = 4090,
      },

      -- Provider settings
      provider = "gemini", -- Choose between: "ollama", "claude", "openrouter", "copilot"
      --     cursor_applying_provider = "planning", -- Use the new vendor for cursor application

      -- Gemini provider settings
      gemini = {
        temperature = 0.1,
        -- model = "gemini-2.5-pro-exp-03-25", -- Main provider uses 2.5-pro
        model = "gemini-2.0-flash",
        GEMINI_API_KEY = "AIzaSyCvlfFu_TpA8Je_mqH3SeFHzTr3eo1u2Oo",
      },

      -- Claude provider settings
      claude = {
        temperature = 0.1,
        model = "claude-3-7-sonnet-20250219",
        max_tokens = 4096,
      },

      -- Copilot provider settings
      copilot = {
        temperature = 0.1,
        model = "claude-3.5-sonnet",
      },

      -- Ollama provider settings
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
        model = "deepseek-r1:1.5b",
      },

      -- OpenRouter vendor settings
      vendors = {

        planning = {
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "llama-3.3-70b-versatile",
        },

        high_speed = {
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          -- Correct the endpoint to include /openai/v1
          endpoint = "https://api.groq.com/openai/v1",
          -- Correct the model name format
          model = "llama-3.1-8b-instant",
          temperature = 0,
        },

        tool_expert = {
          __inherited_from = "openai",
          disable_tools = true,
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "cohere/command-r7b-12-2024",
        },

        groq = { -- define groq provider
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "deepseek-r1-distill-llama-70b",
          max_tokens = 8192, -- remember to increase this value, otherwise it will stop generating halfway
        },

        -- Add a new vendor specifically for the cursor applying provider
        experimental_models = {
          __inherited_from = "gemini", -- Inherit base settings from the main gemini provider
          model = "gemini-2.5-pro-exp-03-25", -- Override the model to use flash
          temperature = 0, -- Set temperature to 0 for deterministic cursor application
        },

        openrouter_deepseek = {
          __inherited_from = "openai",
          disable_tools = true,
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "deepseek/deepseek-r1-distill-llama-70b",
        },

        openrouter_qwenq = {
          __inherited_from = "openai",
          disable_tools = true,
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "qwen/qwen-2.5-72b-instruct",
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

      -- Autosuggest settings
      autosuggest_enabled = false,
      autosuggest_provider = "copilot",

      -- RAG service settings
      --      rag_service = {
      --       enabled = true, -- Enables the RAG service
      --      host_mount = os.getenv("HOME"), -- Host mount path for the rag service
      --        provider = "ollama", -- The provider to use for RAG service
      --       llm_model = "Crocod1le/rag-skeleton-build:latest", -- The LLM model to use for RAG service
      --      embed_model = "Crocod1le/snowflake-custom:latest",
      --     endpoint = "http://127.0.0.1:11434", -- Must match your Ollama endpoint since provider is "ollama"
      --  },
      --

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
    },
  },
}
