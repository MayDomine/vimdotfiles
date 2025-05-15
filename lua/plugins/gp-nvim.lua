-- lazy.nvim
return {
  "robitx/gp.nvim",
  lazy = true,
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
        PaperReview = function(gp, params)
          local template = "I am writing an academic paper in {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please review the paragraph above.\n"
            .. "You need to follow the review guidelines as follows:\n"
            .. "1. Check.\n"
            .. "1.1. Check for grammar and spelling errors.\n"
            .. "1.2. Check for coherence and clarity.\n"
            .. "1.3. Check if there is redundant sentence or word \n"
            .. "2. Question \n"
            .. "2.1. Ask me if you have any concerns.\n"
            .. "2.2. Ask me if you have something can not understand.\n"
            .. "3. Suggestions and examples \n"
            .. "3.1. Give me some suggestions to help me fix the problems.\n"
            .. "3.2. Tell me if something is well done and whether I should continue doing it that way.\n"
            .. "4. Format Guardlines \n"
            .. "4.1. Make sure that your response have a good format, highlight the important part.\n"
            .. "4.2. In check part, if something is not satisfactory, mark it with [W] to indicate Wrong.\n"
            .. "4.3. In check part, highlight well-executed items with [G] to denote Good.\n"
            .. "4.4. In Question part, make your questions as shorter as possible\n"
            .. "4.4. In Suggestions and examples part, make you only output the original sentence and modified version. please do not tell me why if I didn't ask. \n"
            .. "4.5. You can use some icons to highlight things up and make the review as shorter as possible since reading them needs time. \n"
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew "markdown", agent, template)
          -- gp.cmd.ChatNew(params, template)
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
        minmax = {
          disable = false,
          endpoint = "https://api.minimax.chat/v1/text/chatcompletion_v2",
          secret = os.getenv "MINMAX_SECRET",
        },
        aliyun = {
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
        together = {
          endpoint = "https://api.together.xyz/v1/chat/completions",
          secret = os.getenv "TOGETHER_SECRET",
          disable = false,
        },
        volcengine = {
          endpoint = "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
          secret = os.getenv "VOLC_SECRET",
          disable = false,
        }
      },
      agents = {
        {
          name = "minmax-1",
          provider = "minmax",
          disable = false,
          chat = true,
          command = true,
          model = { model = "MiniMax-Text-01" },
          system_prompt = "You are a powerful assistant. Now answer my questions",
        },
        {
          name = "Qwen-Turbo",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen-turbo-latest" },
          system_prompt = "Your name is Qwen-turbo , you are my assistant. Now answer my questions",
        },
        {
          name = "Qwen-QwQ",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen3-235b-a22b" },
          system_prompt = "You are a powerful assistant. Now answer my questions",
        },
        {
          name = "Qwen-Plus",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen-plus-latest" },
          system_prompt = "Your name is Qwen-Plus , you are my assistant. Now answer my questions",
        },
        {
          name = "Qwen-Max",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "qwen3-30b-a3b" },
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
          name = "DeekSeek R1",
          provider = "deepseek",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-reasoner" },
          system_prompt = "Your name is BaldStrong R1, you are my assistant. Now answer my questions",
        },
        {
          name = "Aliyun DeekSeek",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-v3" },
          system_prompt = "Your name is BaldStrong, you are my assistant. Now answer my questions",
        },
        {
          name = "Aliyun DeekSeek R1",
          provider = "aliyun",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-r1" },
          system_prompt = "Your name is BaldStrong R1, you are my assistant. Now answer my questions",
        },
        {
          name = "Volc DeekSeek",
          provider = "volcengine",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-v3-241226" },
          system_prompt = "Your name is BaldStrong, you are my assistant. Now answer my questions",
        },
        {
          name = "Volc DeekSeek R1",
          provider = "volcengine",
          disable = false,
          chat = true,
          command = true,
          model = { model = "deepseek-r1-250120" },
          system_prompt = "Your name is BaldStrong R1, you are my assistant. Now answer my questions",
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
          name = "Claude sonnet 3.7",
          provider = "ct_any",
          disable = false,
          chat = true,
          command = true,
          model = { model = "claude-3-7-sonnet-20250219" },
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
