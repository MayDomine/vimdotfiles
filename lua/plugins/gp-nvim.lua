-- lazy.nvim
return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    local conf = {

      -- For customization, refer to Install > Configuration in the Documentation/Readme
      chat_confirm_delete = false,
      chat_finder_mappings = {
        delete  = { modes = { "n", "i", "v", "x" }, shortcut = "<C-d>" },
      },
      hooks = {
        Translate = function (gp, params)
            local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.rewrite, agent, chat_system_prompt)

        end
      },
      providers = {
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
