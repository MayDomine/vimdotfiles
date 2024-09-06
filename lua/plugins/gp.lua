-- lazy.nvim
return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    local conf = {
      -- For customization, refer to Install > Configuration in the Documentation/Readme
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
          disable = true,
        },
      },
      agents = {
        {
          name = "DeekSeek V2.5",
          provider = "ct_any",
          disable = true,
          chat = true,
          command = true,
          model = { model = "deepseek-chat" },
          system_prompt = "Answer any query with just: Sure thing..",
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
          name = "GPT4 Turbo",
          provider = "ct_any",
          disable = false,
          chat = true,
          command = true,
          model = { model = "gpt-4-turbo-2024-04-09" },
          system_prompt = "Answer my questions",
        },
      },
    }
    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
