return {
  "mfussenegger/nvim-dap",
  recommended = true,
  desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      keys = {
        {"<leader><leader>", function ()
          vim.cmd "Telescope dap frames"
        end, "dap frames"},
        {"<leader>vb", function ()
          vim.cmd "Telescope dap list_breakpoints"
        end, "dap frames"},
      }
    },
    {
      "Weissle/persistent-breakpoints.nvim",
      config = function()
        require("persistent-breakpoints").setup {
          load_breakpoints_event = { "BufReadPost" },
          save_dir = vim.fn.stdpath "data" .. "/nvim_checkpoints",
        }
      end,
    },
    { "nvim-neotest/nvim-nio" },
    {
      "igorlfs/nvim-dap-view",
      cmd = { "DapViewOpen", "DapViewClose" },
      config = function(_, opts)
        local dap = require "dap"
        dap.listeners.after.event_initialized["dapui_config"] = function()
          vim.cmd "DapViewOpen"
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          vim.cmd "DapViewClose"
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          vim.cmd "DapViewClose"
        end
      end,
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>pP", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>pp", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>pc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>pa", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>pC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>pg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>pi", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>pj", function() require("dap").down() end, desc = "Down" },
    { "<leader>pk", function() require("dap").up() end, desc = "Up" },
    { "<leader>pl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>pL", function() vim.cmd("DapVirtualTextToggle") end, desc = "Toggle Virtual Text" },
    { "<leader>po", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>pO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<C-]>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>ps", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>pS", function() require("dap-view").jump_to_view("scopes") end, desc = "Pause" },
    { "<leader>pr", function() require("dap").run_to_cursor() end, desc = "Toggle REPL" },
    -- { "<leader>pr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    -- { "<leader>ps", function() require("dap").session() end, desc = "Session" },
    { "<leader>px", function() require("dap").terminate() end, desc = "Kill DAP" },
    { "<leader>pT", function() require("dap-view").jump_to_view("threads") end, desc = "Dap Threads" },
    { "<leader>pR", function() require("dap-view").jump_to_view("repl") end, desc = "Dap REPL" },
    { "<leader>pB", function() require("dap-view").jump_to_view("breakpoints") end, desc = "Dap Breakpoints" },
    { "<leader>pW", function() require("dap-view").jump_to_view("watches") end, desc = "Dap Watches" },
    { "<leader>pe", function() require("dap-view").add_expr() end, desc = "Dap Add expr" },
    { "<leader>pw", function() require("dap").focus_frame() end, desc = "Focus on current frame" },
    { "<c-b>", function() 
      vim.cmd("DapViewToggle")
      -- require("dapui").toggle()
    end, desc = "Widgets" },
  },

  config = function()
    -- load mason-nvim-dap here, after all adapters have been setup
    -- if LazyVim.has("mason-nvim-dap.nvim") then
    --   require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
    -- end
    local dap = require "dap"
    dap_icons = require("configs.icons").dap
    for name, sign in pairs(dap_icons) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

    local python_path = "/opt/homebrew/Caskroom/miniconda/base/bin/python"
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dap-repl",
      callback = function()
        vim.opt_local.wrap = true
      end,
    })
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb {
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = {
            source_filetype = "python",
          },
        }
      else
        cb {
          type = "executable",
          command = python_path,
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        }
      end
    end

    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}", -- This configuration will launch the current file if used.
        console = "integratedTerminal",
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          else
            return python_path
          end
        end,
      },
    }
    --

    -- setup dap config by VsCode launch.json file
    local vscode = require "dap.ext.vscode"
    local json = require "plenary.json"
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end
  end,
}
