return {
  "https://github.com/lewis6991/gitsigns.nvim.git",
  config = function()
    require("gitsigns").setup {
      numhl = true,
      current_line_blame = true,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function opts(desc)
          return { buffer = bufnr, desc = desc }
        end

        local map = vim.keymap.set

        map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
        map("n", "<leader>rH", gs.reset_buffer, opts "Reset Hunk")
        vim.api.nvim_set_keymap('v', '<leader>rh',
          [[:<C-u>lua require('gitsigns').reset_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>]],
          { noremap = true, silent = true })

        map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
        map("n", "<leader>gl", gs.blame_line, opts "Blame Line")
      end,
    }
  end,
}
