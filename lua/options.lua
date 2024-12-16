require "nvchad.options"

local enable_providers = {
  "python3_provider",
  "node_provider",
  -- and so on
}
--
for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end
--
vim.g.loaded_python3_provider = nil
vim.g.python_host_prog = '/opt/homebrew/Caskroom/miniconda/base/bin/python'
vim.g.python3_host_prog = '/opt/homebrew/Caskroom/miniconda/base/bin/python3'
-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
