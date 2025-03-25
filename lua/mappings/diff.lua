local function populate_diff_list()
  -- Clear existing quickfix list
  vim.fn.setqflist({}, " ")

  -- Get the current buffer and its lines
  -- Initialize a table to store differences
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local diffs = {}

  -- Helper function to check if a line is the start of a diff block
  local function is_diff_start(lnum)
    local prev_line_hl = vim.fn.diff_hlID(lnum - 2, 1) -- Check previous line's first column
    local curr_line_hl = vim.fn.diff_hlID(lnum - 1, 1) -- Check current line's first column
    return curr_line_hl ~= 0 and (prev_line_hl == 0 or lnum == 1)
  end

  -- Iterate over all lines in the current buffer
  for lnum = 1, #lines do
    local line = lines[lnum - 1]
    if line == nil then
      goto continue
    end

    -- Check if the current line is the start of a diff block
    if is_diff_start(lnum) then
      table.insert(diffs, {
        bufnr = buf,
        lnum = lnum,
        col = 1, -- Typically, the column is irrelevant for diff starts
        text = line,
        filename = buf_name,
      })
    end
    ::continue::
  end

  -- Populate the quickfix list with differences
  if #diffs > 0 then
    vim.fn.setqflist({}, " ", { title = "Diff Results", items = diffs })
    vim.notify("Differences collected into quickfix list.", vim.log.levels.INFO)
  else
    vim.notify("No differences found.", vim.log.levels.WARN)
  end
  vim.cmd "copen"
end
vim.api.nvim_create_user_command("ShowDiffs", populate_diff_list, {})
vim.keymap.set("n", "<leader>dq", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.wo.diff then
    populate_diff_list()
  else
    require('gitsigns').setqflist()
  end
end, { desc = "Populate diff quickfix list" })
