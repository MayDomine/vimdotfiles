return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    -- add any opts here
    -- for example
    provider = "ct_claude",
    auto_suggestions_provider = "deepseek",

    cursor_applying_provider = "qwen", -- In this example, use Groq for applying, but you can also use any provider you want.

    vendors = {
      qwen = {
        __inherited_from = "openai",
        api_key_name = "QWEN_SECRET",
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1/",
        model = "qwen-max-latest",
      },
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "DEEPSEEK_SECRET",
        endpoint = "https://api.deepseek.com/v1/",
        model = "deepseek-coder",
      },
      ct_claude = {
        __inherited_from = "openai",
        api_key_name = "CT_SECRET",
        endpoint = "https://api.chatanywhere.tech/v1/",
        model = "claude-3-7-sonnet-20250219",
      },
    },
    mappings = {
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<c-f>",
        reverse_switch_windows = "<c-f>",
        remove_file = "d",
        add_file = "@",
        close = { "<Esc>", "q" },
        ---@alias AvanteCloseFromInput { normal: string | nil, insert: string | nil }
        ---@type AvanteCloseFromInput | nil
        close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
      },

      diff = {
        ours = "do",
        theirs = "dt",
        all_theirs = "da",
        both = "db",
        cursor = "dc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<Tab>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      enable_cursor_planning_mode = false, -- enable cursor planning mode!
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    -- {
    --   -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      enabled = vim.g.is_mac,
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
