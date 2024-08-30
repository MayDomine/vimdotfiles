" Vim plugin to handle async rsync synchronisation between hosts
" Title: vim-arsync
" Author: Ken Hasselmann
" Date: 08/2019
" License: MIT

function! LoadConf()
    let l:conf_dict = {}
    let l:file_exists = filereadable('.vim-arsync')

    if l:file_exists > 0
        let l:conf_options = readfile('.vim-arsync')
        for i in l:conf_options
            let l:var_name = substitute(i[0:stridx(i, ' ')], '^\s*\(.\{-}\)\s*$', '\1', '')
            if l:var_name == 'ignore_path'
                let l:var_value = eval(substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', ''))
                " echo substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', '')
            elseif l:var_name == 'remote_passwd'
                " Do not escape characters in passwords.
                let l:var_value = substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', '')
            else
                let l:var_value = escape(substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', ''), '%#!')
            endif
            let l:conf_dict[l:var_name] = l:var_value
        endfor
    endif
    if !has_key(l:conf_dict, "local_path")
        let l:conf_dict['local_path'] = getcwd()
    endif
    if !has_key(l:conf_dict, "remote_port")
        let l:conf_dict['remote_port'] = 0
    endif
    if !has_key(l:conf_dict, "remote_or_local")
        let l:conf_dict['remote_or_local'] = "remote"
    endif
    if !has_key(l:conf_dict, "local_options")
        let l:conf_dict['local_options'] = "-var"
    endif
    if !has_key(l:conf_dict, "remote_options")
        let l:conf_dict['remote_options'] = "-vazre"
    endif
    if has_key(l:conf_dict, "rsync_flags")
        let g:flags = l:conf_dict['rsync_flags']
        let l:conf_dict['rsync_flags'] = eval(substitute(g:flags, '^\s*\(.\{-}\)\s*$', '\1', ''))
    else 
        let l:conf_dict['rsync_flags'] = []
    endif
    let g:rsync_table = l:conf_dict

    return l:conf_dict
endfunction

function! StartNotification(id, msg) abort
  " 初始化变量
  let g:frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
  let g:frame_index = 0
  let g:notify_running = v:true
  let g:_msg = a:msg

  " 更新图标的函数
    function! s:update_icon(timer_id) abort
      if !g:notify_running
        call timer_stop(g:timer_id)
        return
      endif

      let g:frame_index = (g:frame_index + 1) % len(g:frames)
      let g:current_frame = g:frames[g:frame_index]

      let g:log_id = luaeval('vim.notify([[' . g:_msg . ']], "warn", {title = "vim-arsync", replace = ' .. g:log_id .. ', animate = false ,icon = "' .. g:current_frame .. '"})').id
    endfunction

  " 设置定时器，每300毫秒更新一次图标
  let g:timer_id = timer_start(150, function('s:update_icon'), {'repeat': -1})

  " 任务完成时的函数
  function! FinishNotification(timer_id) abort
    if !g:notify_running
      call timer_stop(g:timer_id)
      let g:notify_running = v:false
      return
    endif
  endfunction

  " 模拟5秒后任务完成，调用 FinishNotification 函数
  call timer_start(5000, function('FinishNotification'))
endfunction

function! JobHandler(job_id, data, event_type)
    " redraw | echom a:job_id . ' ' . a:event_type
    if a:event_type == 'stdout' || a:event_type == 'stderr'
        " redraw | echom string(a:data)
        if has_key(getqflist({'id' : g:qfid}), 'id')
            call setqflist([], 'a', {'id' : g:qfid, 'lines' : a:data})
        endif
    elseif a:event_type == 'exit'
        if a:data != 0
            let g:notify_running = v:false
            copen
        endif

        if a:data == 0
          let l:success = 'rsync success.' .. "\n" 
          let l:success = l:success .. g:rsync_info
          call luaeval('vim.notify([[' . l:success. ']], "info", {title = "vim-arsync", replace = ' .. g:log_id .. ', icon = "", timeout = 1000})')
          let g:notify_running = v:false
        endif
        " echom string(a:data)
    endif
endfunction

function! ShowConf()
    let l:conf_dict = LoadConf()
    echo l:conf_dict
    echom string(getqflist())
endfunction

function! ARsync(direction)
    let l:conf_dict = LoadConf()
    if has_key(l:conf_dict, 'remote_host')
        let l:user_passwd = ''
        if has_key(l:conf_dict, 'remote_user')
            let l:user_passwd = l:conf_dict['remote_user'] . '@'
            if has_key(l:conf_dict, 'remote_passwd')
                if !executable('sshpass')
                    echoerr 'You need to install sshpass to use plain text password, otherwise please use ssh-key auth.'
                    return
                endif
                let sshpass_passwd = l:conf_dict['remote_passwd']
            endif
        endif
        if l:conf_dict['remote_or_local'] == 'remote'
            if l:conf_dict['remote_port'] == 0
              if a:direction == 'down'
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh ', l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/', l:conf_dict['local_path'] . '/']
              elseif  a:direction == 'up'
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh ', l:conf_dict['local_path'] . '/', l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/']
              else " updelete
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh ', l:conf_dict['local_path'] . '/', l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/', '--delete']
              endif
            else
              if a:direction == 'down'
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh -p '.l:conf_dict['remote_port'], l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/', l:conf_dict['local_path'] . '/']
              elseif  a:direction == 'up'
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh -p '.l:conf_dict['remote_port'], l:conf_dict['local_path'] . '/', l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/']
              else " updelete
                  let l:cmd = [ 'rsync', l:conf_dict['remote_options'], 'ssh -p '.l:conf_dict['remote_port'], l:conf_dict['local_path'] . '/', l:user_passwd . l:conf_dict['remote_host'] . ':' . l:conf_dict['remote_path'] . '/', '--delete']
              endif
            endif
        elseif l:conf_dict['remote_or_local'] == 'local'
            if a:direction == 'down'
                let l:cmd = [ 'rsync', l:conf_dict['local_options'],  l:conf_dict['remote_path'] , l:conf_dict['local_path']]

            elseif  a:direction == 'up'
                let l:cmd = [ 'rsync', l:conf_dict['local_options'],  l:conf_dict['local_path'] , l:conf_dict['remote_path']]
            else " updelete
                let l:cmd = [ 'rsync', l:conf_dict['local_options'],  l:conf_dict['local_path'] , l:conf_dict['remote_path'] . '/', '--delete']
            endif
        endif
        if has_key(l:conf_dict, 'ignore_path')
            for file in l:conf_dict['ignore_path']
                let l:cmd = l:cmd + ['--exclude', file]
            endfor
        endif
        if has_key(l:conf_dict, 'ignore_dotfiles')
            if l:conf_dict['ignore_dotfiles'] == 1
                let l:cmd = l:cmd + ['--exclude', '.*']
            endif
        endif
        if has_key(l:conf_dict, 'remote_passwd')
            let l:cmd = ['sshpass', '-p', sshpass_passwd] + l:cmd
        endif
        if has_key(l:conf_dict, 'rsync_flags')
            let l:cmd = l:cmd + conf_dict['rsync_flags']
        endif

        " create qf for job
        let g:rsync_cmd = l:cmd
        call setqflist([], ' ', {'title' : 'vim-arsync'})
        let g:qfid = getqflist({'id' : 0}).id
        " redraw | echom join(cmd)
        "
        " 初始化变量
        let l:rsync_heading= 'Starting rsync...' . "\n"
        let l:rsync_log = "\tLocal path: " . l:conf_dict['local_path'] . "\n"
        let l:rsync_log = l:rsync_log .. "\tRemote path: " . l:conf_dict['remote_path'] . "\n"
        let l:rsync_log = l:rsync_log .. "\tRemote host: " . l:conf_dict['remote_host']

        " Escape double quotes inside the Lua string and wrap it in single quotes
        "if g:log_id is not nil
        let l:rsync_log_lua = 'vim.notify([[' .. l:rsync_heading .. l:rsync_log .. ']], "warn", {title = "vim-arsync", animate = false})'

        " Execute the Lua command
        let l:log_obj = luaeval(l:rsync_log_lua)

        let l:job_id = async#job#start(cmd, {
                    \ 'on_stdout': function('JobHandler'),
                    \ 'on_stderr': function('JobHandler'),
                    \ 'on_exit': function('JobHandler'),
                    \ })

        let g:log_id = l:log_obj.id
        let g:rsync_info = l:rsync_log
        call StartNotification(g:log_id, l:rsync_heading .. l:rsync_log)
        " TODO: handle errors
    else
        echoerr 'Could not locate a .vim-arsync configuration file. Aborting...'
    endif
endfunction

function! AutoSync()
    let l:conf_dict = LoadConf()
    if has_key(l:conf_dict, 'auto_sync_up')
        if l:conf_dict['auto_sync_up'] == 1
            if has_key(l:conf_dict, 'sleep_before_sync')
                let g:sleep_time = l:conf_dict['sleep_before_sync']*1000
                autocmd BufWritePost,FileWritePost * call timer_start(g:sleep_time, { -> execute("call ARsync('up')", "")})
            else
                autocmd BufWritePost,FileWritePost * ARsyncUp
            endif
            " echo 'Setting up auto sync to remote'
        endif
    endif
endfunction

if !executable('rsync')
    echoerr 'You need to install rsync to be able to use the vim-arsync plugin'
    finish
endif

command! ARsyncUp call ARsync('up')
command! ARsyncUpDelete call ARsync('upDelete')
command! ARsyncDown call ARsync('down')
command! ARshowConf call ShowConf()

augroup vimarsync
    autocmd!
    autocmd VimEnter * call AutoSync()
    autocmd DirChanged * call AutoSync()
augroup END
