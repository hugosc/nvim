return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false,
    build = "make",
    --   dir = "~/avantegeminitools/",
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
      disabled_tools = { "python" },
      -- General settings
      behaviour = {
        enable_token_counting = false,
        enable_claude_text_tool_mode = false,
        enable_cursor_planning_mode = true,
        use_cwd_as_project_root = true,
        auto_suggestions = false,
        minimize_diff = true,
      },

      history = {
        max_tokens = 4096,
      },

      -- Provider settings
      provider = "copilot", -- Choose between: "ollama", "claude", "openrouter", "copilot"
      cursor_applying_provider = "planning", -- Use the new vendor for cursor application

      providers = {
        -- Gemini provider settings
        gemini = {
          model = "gemini-2.5-flash",
          extra_request_body = {
            temperature = 0.1,
          },
        },
        -- Copilot provider settings
        copilot = {
          model = "o4-mini",
        },

        -- Add a new vendor specifically for the cursor applying provider
        experimental_models = {
          __inherited_from = "gemini", -- Inherit base settings from the main gemini provider
          model = "gemini-2.5-pro", -- Override the model to use flash
          extra_request_body = {
            temperature = 0, -- Set temperature to 0 for deterministic cursor application
          },
        },

        planning = {
          __inherited_from = "openai",
          api_key_name = "GROQ_API_KEY",
          endpoint = "https://api.groq.com/openai/v1/",
          model = "llama-3.3-70b-versatile",
        },

        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          -- Check if hub exists and is ready before generating the prompt
          if hub and hub:is_ready() then
            return hub:get_active_servers_prompt()
          else
            return "" -- Or maybe "MCP Hub not ready. Available servers will be listed later."
          end
        end,

        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
      },
    },
  },
}
