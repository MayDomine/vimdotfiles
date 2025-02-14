
local map = vim.keymap.set
local function opts(desc)
  return {desc = desc }
end
local status_ok, live_grep_args_shortcuts = pcall(require, "telescope-live-grep-args.shortcuts")
if not status_ok then
  return
end
local function search_switch(func1)
    local live_grep_args = require("telescope").extensions.live_grep_args
    if func1 == nil then
        func1 = live_grep_args.live_grep_args
    end
    local function current_buffer_live_grep_args(_opts, is_current_buffer, flag)
      _opts = _opts or {}
      _opts.attach_mappings = function(_, _map)
          _map({ "n", "i" }, "<C-a>", function(prompt_bufnr) -- <C-h> to toggle modes
            local prompt = require("telescope.actions.state").get_current_line()
            require("telescope.actions").close(prompt_bufnr)
            is_current_buffer = not is_current_buffer
            current_buffer_live_grep_args({ default_text = prompt}, is_current_buffer, 1)
          end)
          return true
      end
      if is_current_buffer then
          _opts.prompt_title = "Live Grep Args (Current Buffer)"
          local curr_path = vim.fn.expand("%")
          _opts["search_dirs"] = { curr_path }
          live_grep_args.live_grep_args(_opts)
      else
          _opts.prompt_title = "Live Grep (Args)"
          if flag == 1 then
            live_grep_args.live_grep_args(_opts)
          else
            func1(_opts)
          end
      end
    end
  return current_buffer_live_grep_args
end
local normal_grep  = live_grep_args_shortcuts.grep_word_under_cursor
local v_normal_grep = live_grep_args_shortcuts.grep_visual_selection
local normal_switch = search_switch(normal_grep)
local visual_switch = search_switch(v_normal_grep)
local simple_siwtch = search_switch()
-- map("n", "<leader>fc", normal_switch, opts "Live grep word")
-- map("v", "<leader>fc", visual_switch, opts "Live grep visual selection")
-- map("n", "<leader>fw", simple_siwtch, opts "Live grep args")
-- map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor, opts "Live grep word")
-- map("v", "<leader>fc", live_grep_args_shortcuts.grep_visual_selection, opts "Live grep visual selection")
