return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = false,
      open_in_current_tab = true,
      },
  },
  keys = {
    { "<leader>n", nil, desc = "AI/Claude Code" },
    { "<C-p>", "<cmd>ClaudeCodeFocus<cr>", desc = "Toggle Claude" , mode ={"n", "t"}},
    { "<leader>nf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>nr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>nC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>nm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>nb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<C-p>", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>fx", function ()
       
      end, mode = "v", desc = "Send to Claude to fix" },
    {
      "<leader>ns",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>na", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>nd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
