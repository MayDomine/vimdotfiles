-- 文件: lua/conf.lua
local M = {}

M.global_conf_file = vim.fn.stdpath "data" .. "/vim-arsync/global_conf.json"
M.replace_key = { "remote_host", "remote_port", "remote_path", "local_path" }

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

local function get_global_conf()
  local conf_dict = read_conf_file(M.global_conf_file)
  return conf_dict
end
-- 生成哈希值
local function generate_hash(conf)
  local str = table.concat({
    conf.remote_host or "",
    conf.remote_port or "",
    conf.remote_path or "",
    conf.local_path or "",
  }, ":")
  return vim.fn.sha256(str)
end

function M.get_url(entry)
  local remote_host = vim.fn.trim(entry["remote_host"]) or ""
  local remote_port = entry["remote_port"] or ""
  return remote_host .. ":" .. remote_port
end

local function find_tbl(table, list)
  local idx = -1
  for i, v in ipairs(list) do
    if v.hash == table.hash then
      idx = i
      break
    end
  end
  return idx
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
  if has_conf_file then
    local conf_options = vim.fn.readfile ".vim-arsync"
    for _, line in ipairs(conf_options) do
      local var_name, var_value = line:match "^%s*(%S+)%s*(.*)%s*$"
      if vim.list_contains(M.replace_key, var_name) then
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
  local has_all_key = true
  for _, k in pairs(M.replace_key) do
    if not new_conf[k] then
      has_all_key = false
      break
    end
  end
  if not has_all_key then
    return
  end

  new_conf["local_path"] = new_conf["local_path"] or vim.fn.getcwd()
  new_conf["remote_port"] = new_conf["remote_port"] or 0
  new_conf["remote_host"] = vim.fn.trim(new_conf["remote_host"]) or ""
  new_conf["hash"] = generate_hash(new_conf)

  local conf_dict = get_global_conf()
  local local_path = new_conf["local_path"]
  local idx = find_tbl(new_conf, conf_dict)
  if idx == -1 then
    table.insert(conf_dict, new_conf)
  end
  write_conf_file(M.global_conf_file, conf_dict)
end

local function write_conf_in_local_file(file_path, conf)
  local file = io.open(file_path, "w")
  if not file then
    return false
  end
  local keys = vim.tbl_keys(conf)
  table.sort(keys)
  for _, k in pairs(keys) do
    local v = conf[k]
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
  local local_path = conf_dict["local_path"] or vim.loop.cwd()
  local project_conf_path = local_path .. "/.vim-arsync"
  local original_conf = vim.fn.LoadConf()
  for _, k in pairs(M.replace_key) do
    if conf_dict[k] then
      original_conf[k] = conf_dict[k]
    end
  end
  write_conf_in_local_file(project_conf_path, original_conf)
  return original_conf
end

function M.delete_project_conf(conf_dict)
  local hash = generate_hash(conf_dict)
  if find_tbl(conf_dict, get_global_conf()) == -1 then
    return
  else -- 删除全局配置
    local global_conf = get_global_conf()
    local idx = find_tbl(conf_dict, global_conf)
    table.remove(global_conf, idx)
    write_conf_file(M.global_conf_file, global_conf)
  end
end

return M
