-- Define key mappings for normal and visual mode in Vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- Normal mode mappings
local all_maps = {}
all_maps.n = {
  { "<leader>cn", "<cmd>GpChatNew vsplit<CR>", "Open New Chat" },
  { "<leader>cv", "<cmd>GpChatPaste vsplit<CR>", "Paste in Vertical Split" },
  { "<leader>ce", "<cmd>GpRewrite<CR>", "Gp Rewrite" },
  { "<leader>ct", "<cmd>GpChatToggle<CR>", "Toggle Chat Window" },
  { "<leader>cf", "<cmd>GpChatFinder<CR>", "Open Chat Finder" },
  { "<leader>cr", "<cmd>GpChatRespond<CR>", "Respond to Chat Message" },
  { "<leader>cq", "<cmd>GpChatDelete<CR>", "Delete Current Chat" },
  { "<leader>cs", "<cmd>GpStop<CR>", "Stop Running Process" },
  { "<leader>ca", "<cmd>GpAppend<CR>", "Append to File" },
  { "<leader>cb", "<cmd>GpPrepend<CR>", "Prepend to File" },
  { "<leader>cE", "<cmd>GpEnew<CR>", "Create New Buffer" },
  { "<leader>gi", "<cmd>GpImplement<CR>", "Implement Interface" },
}

-- Visual mode mappings
all_maps.v = {
  { "<leader>cn", ":<C-u>'<,'>GpChatNew vsplit<CR>", "Open New Chat" },
  { "<leader>gi", ":<C-u>'<,'>GpImplement<CR>", "Implement Interface" },
  { "<leader>cv", ":<C-u>'<,'>GpChatPaste vsplit<CR>", "Paste in Vertical Split" },
  { "<leader>ch", ":<C-u>'<,'>GpChatPaste split<CR>", "Paste in Horizontal Split" },
  { "<leader>cT", ":<C-u>'<,'>GpChatPaste tabnew<CR>", "Paste in New Tab" },
  { "<leader>cp", ":<C-u>'<,'>GpChatPaste<CR>", "Paste in Popup Window" },
  { "<leader>cl", ":<C-u>'<,'>GpChatPaste<CR>", "Paste Chat Content" },
  { "<leader>ct", ":<C-u>'<,'>GpChatToggle<CR>", "Toggle Chat Visibility" },
  { "<leader>cf", ":<C-u>'<,'>GpChatFinder<CR>", "Find in Chat" },
  { "<leader>cr", ":<C-u>'<,'>GpChatRespond<CR>", "Respond Directly in Chat" },
  { "<leader>cq", ":<C-u>'<,'>GpChatDelete<CR>", "Delete Selected Chat" },
  { "<leader>cs", ":<C-u>'<,'>GpStop<CR>", "Stop Selected Process" },
  { "<leader>ce", ":<C-u>'<,'>GpRewrite<CR>", "Gp Rewrite" },
  { "<leader>ca", ":<C-u>'<,'>GpAppend<CR>", "Append to Selection" },
  { "<leader>cb", ":<C-u>'<,'>GpPrepend<CR>", "Prepend to Selection" },
}

-- Store all mappings
vim.g.all_maps = all_maps

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
