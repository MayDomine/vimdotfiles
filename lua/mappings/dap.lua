function create_launch_json()
  local ar_conf = require("arsync.conf").load_conf()
  if not ar_conf then
    vim.notify("ar_conf not found", vim.log.levels.WARN)
    return
  end

  -- 获取当前项目根目录
  local cwd = vim.fn.getcwd()
  local vscode_dir = cwd .. "/.vscode"
  local launch_json_path = vscode_dir .. "/launch.json"

  -- 创建 .vscode 目录（如果不存在）
  if vim.fn.isdirectory(vscode_dir) == 0 then
    vim.fn.mkdir(vscode_dir, "p")
  end

  -- 确定本地根目录
  local local_root = "${workspaceFolder}"
  

  -- 构建 launch.json 配置
  local launch_config = {
    version = "0.2.0",
    configurations = {
      {
        name = "Python: Remote Attach",
        type = "debugpy",
        request = "attach",
        connect = {
          host = localhost,
          port = 5678,
        },
        pathMappings = {
          {
            localRoot = local_root,
            remoteRoot = ar_conf.remote_path,
          },
        },
        justMyCode = false,
      },
    },
  }

  -- 将配置转换为 JSON 字符串
  local json_content = vim.json.encode(launch_config)

  -- 写入临时文件
  local tmp_path = launch_json_path .. ".tmp"
  local file = io.open(tmp_path, "w")
  if not file then
    vim.notify("Failed to create launch.json", vim.log.levels.ERROR)
    return
  end
  file:write(json_content)
  file:close()
  
  -- 尝试使用 Python 的 json.tool 格式化 JSON
  local python_cmd = string.format('python3 -m json.tool "%s" > "%s"', tmp_path, launch_json_path)
  vim.fn.system(python_cmd)
  
  if vim.v.shell_error == 0 then
    vim.fn.delete(tmp_path)
    vim.notify("launch.json created and formatted at " .. launch_json_path, vim.log.levels.INFO)
  else
    -- 如果 Python 不可用，尝试使用 jq
    local jq_cmd = string.format('jq . "%s" > "%s"', tmp_path, launch_json_path)
    vim.fn.system(jq_cmd)
    if vim.v.shell_error == 0 then
      vim.fn.delete(tmp_path)
      vim.notify("launch.json created and formatted at " .. launch_json_path, vim.log.levels.INFO)
    else
      -- 如果都不可用，直接使用未格式化的 JSON
      vim.fn.delete(tmp_path)
      file = io.open(launch_json_path, "w")
      if file then
        file:write(json_content)
        file:close()
        vim.notify("launch.json created at " .. launch_json_path .. " (formatting skipped - install python3 or jq)", vim.log.levels.WARN)
      end
    end
  end
end
map("n", "<leader>cl", create_launch_json, { desc = "Create launch.json" })
