return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    enable = true,
  },
  config = function(opts)
    opts = vim.tbl_deep_extend("force", opts, {
      modes = {
        char = {
          jump_labels = true,
        },
      },
      jump = {
        jump_list = false
      },
      label = {
        after = false,
        before = { 0, 0 },
        style = "overlay",
        rainbow = {
          enabled = true,
          shade = 4,
        },
      },
    })
    require("flash").setup(opts)
  end,
  keys = {
    {
      "m",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "M",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = { "o" },
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x"},
      function()
        require("flash").treesitter_search()
      end,
      desc = "Remote Treesitter Search",
    },
    {
      "<leader>uf",
      mode = { "n" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
    {
      "gm",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump {
          continue = true,
        }
      end,
    },
  },
}
