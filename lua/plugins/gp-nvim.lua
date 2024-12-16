-- lazy.nvim
return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    local conf = {

      -- For customization, refer to Install > Configuration in the Documentation/Readme
      chat_confirm_delete = false,
      chat_finder_mappings = {
        delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-d>" },
      },
      hooks = {
        Explain = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by explaining the code above."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, agent, template)
        end,

        Polish = function(gp, params)
          local template = "I have the following paragraph from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please polish the part above."
          local agent = gp.get_chat_agent()
          gp.Prompt(
            params,
            gp.Target.rewrite,
            agent,
            template,
            nil, -- command will run directly without any prompting for user input
            nil -- no predefined instructions (e.g. speech-to-text from Whisper)
          )
        end,

        Fix = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please fix the code above.\n\nplease respond only with the code snippet that should replace the selection above."
          local agent = gp.get_command_agent()
          gp.Prompt(
            params,
            gp.Target.rewrite,
            agent,
            template,
            nil, -- command will run directly without any prompting for user input
            nil -- no predefined instructions (e.g. speech-to-text from Whisper)
          )
        end,
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew "markdown", agent, template)
        end,

        Translate = function(gp, params)
          local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
          gp.cmd.ChatNew(params, chat_system_prompt)
        end,
      },
      providers = {
        qwen = {
          disable = false,
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
          secret = os.getenv "QWEN_SECRET",
        },
        openai = {
          disable = true,
          endpoint = "https://api.openai.com/v1/chat/completions",
          -- secret = os.getenv("OPENAI_API_KEY"),
        },
        ct_any = {
          endpoint = "https://api.chatanywhere.tech/v1/chat/completions",
          secret = os.getenv "CT_SECRET",
          disable = false,
        },
        deepseek = {
          endpoint = "https://api.deepseek.com/v1/chat/completions",
          secret = os.getenv "DEEPSEEK_SECRET",
          disable = false,
        },
      },
      agents = {
        {
          name = "Qwen-Turbo",
          provider = "qwen",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen-turbo-1101" },
          system_prompt = "Your name is Qwen-turbo , you are my assistant. Now answer my questions",
        },
        {
          name = "Qwen-QwQ",
          provider = "qwen",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwq-32b-preview" },
          system_prompt = "You are a powerful assistant. Now answer my questions",
        },
        {
          name = "Qwen-Plus",
          provider = "qwen",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen-plus-latest" },
          system_prompt = "Your name is Qwen-Plus , you are my assistant. Now answer my questions",
        },
        {
          name = "Qwen-Max",
          provider = "qwen",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen-max-latest" },
          system_prompt = "Your name is Qwen-Max , you are my assistant. Now answer my questions",
        },
        {
          name = "DeekSeek BaldStrong",
          provider = "deepseek",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-coder" },
          system_prompt = "Your name is BaldStrong , you are my assistant. Now answer my questions",
        },
        {
          name = "GPT4o",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "gpt-4o-ca" },
          system_prompt = "",
        },
        {
          name = "GPT4o-mini",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "gpt-4o-mini" },
          system_prompt = "Answer my questions",
        },
        {
          name = "Claude sonnet",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "claude-3-5-sonnet-20240620" },
          system_prompt = "Answer my questions",
        },
        {
          name = "GPT4 Turbo ca",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "gpt-4-turbo-ca" },
          system_prompt = "Answer my questions",
        },
        {
          name = "GPT4 Turbo",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "gpt-4-turbo-2024-04-09" },
          system_prompt = "Answer my questions",
        },
      },
    }
    require("gp").setup(conf)
  end,
}
