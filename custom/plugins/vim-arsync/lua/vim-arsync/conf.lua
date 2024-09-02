-- 文件: lua/conf_manager.lua
local M = {}

-- 读取 JSON 配置文件
local function read_conf_file(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return {}
  end
  local content = file:read "*a"
  file:close()
  return vim.json.decode(content) or {}
end

local function get_url(entry)
  return vim.fn.trim(entry["remote_host"]) .. ":" .. entry["remote_path"]
end

local function tbl_in_list(table, list)
  for _, v in ipairs(list) do
    if get_url(v) == get_url(table) then
      return true
   end
  end
  return false
end

-- 写入 JSON 配置文件
local function dirname(str)
  if str:match ".-/.-" then
    local name = string.gsub(str, "(.*/)(.*)", "%1")
    return name
  else
    return ""
  end
end

local function write_conf_file(file_path, conf)
  local file = io.open(file_path, "w")
  vim.g.file_conf = conf
  if not file then
    os.execute("mkdir " .. dirname(file_path))
    file = io.open(file_path, "w")
  end
  if not file then
    return false
  end
  file:write(vim.json.encode(conf))
  file:close()
  return true
end

-- 检查并更新全局配置
function M.check_and_update_conf()
  local new_conf = {}
  local has_conf_file = vim.fn.filereadable ".vim-arsync" == 1
  if not has_conf_file then
    return
  end
  local keys = { "remote_host", "remote_port", "remote_path", "local_path" }
  if has_conf_file then
    local conf_options = vim.fn.readfile ".vim-arsync"
    for _, line in ipairs(conf_options) do
      local var_name, var_value = line:match "^%s*(%S+)%s*(.*)%s*$"
      if vim.list_contains(keys, var_name) then
        if var_name == "ignore_path" then
          new_conf[var_name] = vim.fn.eval(var_value)
        elseif var_name == "remote_passwd" then
          new_conf[var_name] = var_value
        else
          new_conf[var_name] = vim.fn.escape(var_value, "%#!")
        end
      end
    end
  end

  new_conf["local_path"] = new_conf["local_path"] or vim.fn.getcwd()
  new_conf["remote_port"] = new_conf["remote_port"] or 0
  new_conf["remote_host"] = vim.fn.trim(new_conf["remote_host"]) or ""

  local global_conf_file = vim.fn.stdpath "data" .. "/vim-arsync/global_conf.json"
  local conf_dict = read_conf_file(global_conf_file)
  local local_path = new_conf["local_path"]
  if not tbl_in_list(new_conf, conf_dict) then
    table.insert(conf_dict, new_conf)
  end
  write_conf_file(global_conf_file, conf_dict)
end

function write_conf_in_local_file(file_path, conf)
  local file = io.open(file_path, "w")
  if not file then
    return false
  end
  for k, v in pairs(conf) do
    if type(v) == "table" then
      v = vim.fn.json_encode(v)
    end
    file:write(k .. " " .. v .. "\n")
  end
  file:close()
  return true
end
-- 更新当前项目下的 .vim-arsync 文件
function M.update_project_conf(conf_dict)
  local local_path = conf_dict["local_path"]
  local remote_host = conf_dict["remote_host"]
  local remote_port = conf_dict["remote_port"]
  local remote_path = conf_dict["remote_path"]
  local project_conf_path = local_path .. "/.vim-arsync"
  local conf_content = {
    "remote_host " .. remote_host,
    "remote_port " .. remote_port,
    "remote_path " .. remote_path,
    "local_path " .. local_path,
  }
  local original_conf = vim.fn.LoadConf()
  original_conf["remote_host"] = remote_host
  original_conf["remote_port"] = remote_port
  original_conf["remote_path"] = remote_path
  original_conf["local_path"] = local_path
  write_conf_in_local_file(project_conf_path, original_conf)
end

return M
