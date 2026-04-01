return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      win = {
        keys = {
          prompt = { "<c-q>", "prompt", mode = "t", desc = "insert prompt or context" },
          hide_ctrl_dot = { "<c-p>", "hide", mode = "nt", desc = "hide the terminal window" },
          buffers = { "<c-e>", "buffers", mode = "nt", desc = "open buffer picker" },
          hide_ctrl_q   = { "<c-z>", "hide"      , mode = "n" , desc = "hide the terminal window" },
        },
        split = {
          width = 60, -- set to 0 for default split width
          height = 20, -- set to 0 for default split height
        },
      },
    },
  },
  keys = {
    {
      "<C-p>",
      function()
        require("sidekick.cli").toggle { name = "cursor" }
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t" },
    },
    {
      "<C-p>",
      function()
        require("sidekick.cli").send { msg = "{this}", name = "cursor" }
      end,
      mode = { "x" },
      desc = "Send This",
    },
    -- {
    --   "<leader>aa",
    --   function() require("sidekick.cli").toggle() end,
    --   desc = "Sidekick Toggle CLI",
    -- },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>sf",
      function()
        require("sidekick.cli").send { msg = "{file}" }
      end,
      desc = "Send File",
    },
    {
      "<leader>sp",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Example of a keybinding to open Claude directly
  },
}
