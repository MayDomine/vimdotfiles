-- Define key mappings for normal and visual mode in Vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- Normal mode mappings
local all_maps = {}
all_maps.n = {
  { "<leader>cN", "<cmd>GpChatNew vsplit<CR>", "Open New Chat" },
  { "<leader>cv", "<cmd>GpChatPaste vsplit<CR>", "Paste in Vertical Split" },
  { "<leader>ce", "<cmd>GpRewrite<CR>", "Gp Rewrite" },
  { "<leader>cn", "<cmd>GpChatToggle<CR>", "Toggle Chat Window" },
  { "<leader>cf", "<cmd>GpChatFinder<CR>", "Open Chat Finder" },
  { "<leader>cx", "<cmd>GpChatDelete<CR>", "Delete Current Chat" },
  { "<leader>cr", "<cmd>GpCodeReview<CR>", "Gp code review" },
  { "<leader>ci", "<cmd>GpFix<CR>", "Gp code Fix" },
  { "<leader>cp", "<cmd>GpPolish<CR>", "Gp paragraph Polish" },
  { "<leader>cE", "<cmd>GpExplain<CR>", "Gp Explain" },
  { "<leader>cA", "<cmd>GpAppend<CR>", "Append to File" },
  { "<leader>cb", "<cmd>GpPrepend<CR>", "Prepend to File" },
  { "<leader>cE", "<cmd>GpVnew<CR>", "Create New Buffer" },
  { "<leader>gi", "<cmd>GpImplement<CR>", "Implement Interface" },
  { "<leader>cP", "<cmd>GpPopup<CR>", "GpRewrite in a new pop up" },
  { "<C-g>n", "<cmd>GpNextAgent<CR>", "Gp Switch Agent" },
}

-- Visual mode mappings
all_maps.v = {
  { "<leader>cN", ":<C-u>'<,'>GpChatNew vsplit<CR>", "Open New Chat" },
  { "<leader>cn", ":<C-u>'<,'>GpChatPaste vsplit<CR>", "Open New Chat" },
  { "<leader>ci", ":<C-u>'<,'>GpFix<CR>", "Gp code Fix" },
  { "<leader>cp", ":<C-u>'<,'>GpPolish<CR>", "Gp paragraph Polish" },
  { "<leader>cE", ":<C-u>'<,'>GpVnew<CR>", "Create New Buffer" },
  { "<leader>cP", ":<C-u>'<,'>GpPopup<CR>", "GpRewrite in a new pop up" },
  { "<leader>gi", ":<C-u>'<,'>GpImplement<CR>", "Implement Interface" },
  { "<leader>cf", ":<C-u>'<,'>GpChatFinder<CR>", "Find in Chat" },
  { "<leader>cr", ":<C-u>'<,'>GpCodeReview<CR>", "Gp code review" },
  { "<leader>cE", ":<C-u>'<,'>GpExplain<CR>", "Gp Explain" },
  { "<leader>ce", ":<C-u>'<,'>GpRewrite<CR>", "Gp Rewrite" },
  { "<leader>cA", ":<C-u>'<,'>GpAppend<CR>", "Append to Selection" },
  { "<leader>cb", ":<C-u>'<,'>GpPrepend<CR>", "Prepend to Selection" },
}

-- Store all mappings
vim.g.all_maps = vall_maps

-- Apply normal mode mappings
for mode, v in pairs(all_maps) do
  for _, key_map in pairs(v) do
    map(mode, key_map[1], key_map[2], vim.tbl_extend("force", opts, { desc = key_map[3] }))
  end
end

-- Define and map a command to perform a diff operation in a new vertical split
map({ "x" }, "<space>cd", ":GpDiff ", { remap = true, desc = "[C]opilot rewrite to [D]iff" })

local function setup_copy_close_map()
  vim.keymap.set("n", "<leader>co", function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd "windo diffoff"
    vim.cmd("bdelete " .. current_buf)
    vim.keymap.del("n", "<leader>co")
  end, {
    noremap = true,
    silent = true,
    desc = "Close diff and keep changes",
  })
  vim.keymap.set("n", "<leader>cc", function()
    local original_buf = vim.fn.bufnr "#"
    local current_buf = vim.api.nvim_get_current_buf()

    if original_buf == -1 or original_buf == current_buf then
      print "No alternate buffer to copy to"
      return
    end

    -- Copy lines from right to left buffer
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
    vim.api.nvim_buf_set_lines(original_buf, 0, -1, false, lines)

    -- Exit diff mode and close the splits

    -- Remove the mapping
    vim.keymap.del("n", "<leader>cc")
  end, {
    noremap = true,
    silent = true,
    desc = "Copy changes from right to left buffer and close diff",
  })
end

function _G.gp_diff(args, line1, line2)
  -- Capture the current buffer and its file type
  setup_copy_close_map()
  local original_buf = vim.api.nvim_get_current_buf()
  local original_ft = vim.bo[original_buf].filetype

  -- Retrieve all lines from the current buffer
  local contents = vim.api.nvim_buf_get_lines(original_buf, 0, -1, false)

  -- Open a new vertical split and set its properties
  vim.cmd "vnew"
  local scratch_buf = vim.api.nvim_get_current_buf()
  vim.bo[scratch_buf].buftype = "nofile"
  vim.bo[scratch_buf].bufhidden = "wipe"
  vim.bo[scratch_buf].filetype = original_ft

  -- Set the lines of the new buffer to match the original
  vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, contents)

  -- Perform a GpRewrite operation based on provided args and selected lines
  vim.cmd(line1 .. "," .. line2 .. "GpRewrite " .. args)

  -- Delay the synchronization of diff views to allow for command completion
  vim.defer_fn(function()
    vim.cmd "diffthis"
    vim.cmd "wincmd p"
    vim.cmd "diffthis"
  end, 1000)
end

-- Register a new command to use with ranges and arguments
vim.cmd "command! -range -nargs=+ GpDiff lua gp_diff(<q-args>, <line1>, <line2>)"
