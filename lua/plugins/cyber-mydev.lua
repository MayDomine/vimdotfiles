return {
  {
    name = "cyber-mydev",
    dir = vim.fn.stdpath "config" .. "/custom/plugins/cyber-mydev",
    dependencies = {
      "folke/snacks.nvim",
      "arsync.nvim",
    },
    cmd = { "CyberMydev" },
    keys = {
      { "<leader>am", "<cmd>CyberMydev<CR>", desc = "Pick remote execute devspace" },
    },
    config = function()
      require("cyber_mydev").setup()
    end,
  },
}
