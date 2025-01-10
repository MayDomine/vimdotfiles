return {
  "lervag/vimtex",
  event = "VeryLazy", -- we don't want to lazy load VimTeX
  ft = { "tex", "latex", "bib" },
  cmd = {"VimtexInverseSearch"},
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_quickfix_mode = 1
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_compiler_silent = 1
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 0
    vim.g.vimtex_view_general_viewer = "/Applications/Skim.app/Contents/SharedSupport/displayline"
    vim.g.vimtex_view_general_options = "-r @line @pdf @tex"
    -- VimtexEventCompileStarted
    -- This adds a callback hook that updates Skim after compilation
    local g = vim.api.nvim_create_augroup("vimtex", {})
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = "VimtexEventView",
      command = [[ call g:UpdateSkim() ]],
    })
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = { "VimtexEventCompiling", "VimtexEventCompileStarted" },
      callback = function()
        vim.g.vim_tex_finish = false
        vim.g.VimTexNotify()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = { "VimtexEventTocActivated", "VimtexEventTocCreated" },
      command = [[
        noremap("n", "<Space>", "<Space>")
        noremap("n", "<c-j>", "<c-j>")
        "nnoremap <silent><buffer><nowait> <c-j>       :call b:toc.activate_current(0)<cr>
      ]],
    })
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = { "VimtexEventCompileSuccess" },
      callback = function()
        vim.g.vim_tex_finish = true
        vim.g._vimtex_msg = {
          msg = "Compilation Success",
          level = vim.log.levels.INFO,
          hl = {
            title = "DiagnosticOk",
            msg = "DiagnosticOk",
            border = "DiagnosticOk",
          },
        }
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = { "VimtexEventCompileStopped" },
      callback = function()
        vim.g.vim_tex_finish = true
        vim.g._vimtex_msg = {
          msg = "Compilation Stopped",
          level = vim.log.levels.WARN,
          hl = {
            title = "DiagnosticWarn",
            msg = "DiagnosticWarn",
            border = "DiagnosticWarn",
          },
        }
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = g,
      pattern = "VimtexEventCompileFailed",
      callback = function()
        vim.g.vim_tex_finish = true
        vim.g._vimtex_msg = {
          msg = "Compilation Failed",
          level = vim.log.levels.ERROR,
          hl = {
            title = "DiagnosticError",
            msg = "DiagnosticError",
            border = "DiagnosticError",
          },
        }
      end,
    })
    local function VimTexNotify()
      local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      local frame_index = 1
      local timer = vim.loop.new_timer()

      local function update_icon()
        vim.notify("Compiling...", vim.log.levels.INFO, {
          title = "Vimtex ",
          id = "vim-tex",
          icon = frames[frame_index],
          hl = {
            msg = "DiagnosticInfo",
            title = "DiagnosticInfo",
            border = "DiagnosticInfo",
          },
        })
        frame_index = frame_index % #frames + 1
      end

      if timer ~= nil then
        timer:start(
          0,
          300,
          vim.schedule_wrap(function()
            if vim.g.vim_tex_finish then
              timer:stop()
              vim.notify(vim.g._vimtex_msg.msg, vim.g._vimtex_msg.level, {
                title = "Vimtex",
                id = "vim-tex",
                hl = vim.g._vimtex_msg.hl,
              })
            else
              update_icon()
            end
          end)
        )
      end
    end
    local function UpdateSkim(status)
      if not status then
        return
      end

      local out = vim.b.vimtex.out()
      local tex = vim.fn.expand "%:p"
      local cmd = { vim.g.vimtex_view_general_viewer, "-r" }

      if vim.fn.system "pgrep Skim" ~= "" then
        table.insert(cmd, "-g")
      end

      if vim.fn.has "nvim" == 1 then
        vim.fn.jobstart(cmd, {
          args = { vim.fn.line ".", out, tex },
          on_exit = function(_, exit_code)
            if exit_code ~= 0 then
              print("Skim update failed with exit code " .. exit_code)
            end
          end,
        })
      elseif vim.fn.has "job" == 1 then
        vim.fn.job_start(cmd, {
          args = { vim.fn.line ".", out, tex },
          on_exit = function(_, exit_code)
            if exit_code ~= 0 then
              print("Skim update failed with exit code " .. exit_code)
            end
          end,
        })
      else
        vim.fn.system(
          table.concat(cmd, " ")
            .. " "
            .. vim.fn.line "."
            .. " "
            .. vim.fn.shellescape(out)
            .. " "
            .. vim.fn.shellescape(tex)
        )
      end
    end
    vim.api.nvim_create_augroup("vimtex_mac", { clear = true })
    vim.api.nvim_set_var("VimTexNotify", function(status)
      VimTexNotify()
    end)
    vim.api.nvim_set_var("UpdateSkim", function(status)
      UpdateSkim(status)
    end)
    vim.api.nvim_create_augroup("vimtex_mac", { clear = true })
    vim.keymap.set("n", "<localleader>E", "<cmd>VimtexTocToggle<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<localleader>lz", "<cmd>:call vimtex#fzf#run()<CR>", { desc = "vimtex fzf", silent = true })
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      spacing = 0,
      greek = 1,
      math_bounds = 0,
      math_delimiters = 0,
      math_fracs = 0,
      math_super_sub = 0,
      math_symbols = 0,
      sections = 0,
      styles = 1,
    }
  end,
}
