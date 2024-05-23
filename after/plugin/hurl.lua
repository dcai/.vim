vim.api.nvim_create_user_command('HurlRun', function()
  local dir = G.project_root()
  -- run current file
  local ft = vim.bo.filetype
  if not vim.tbl_contains({ 'hurl' }, ft) then
    LOG.warn('Not a hurl file')
    return
  end
  local filepath = vim.fn.expand('%:p')
  local popup = G.new_popup({ title = 'hurl', number = false })
  local PJob = require('plenary.job')
  popup.open()
  local channel = vim.api.nvim_open_term(popup.buffer, {})
  PJob:new({
    command = 'hurl',
    args = {
      '--color',
      '--insecure',
      filepath,
      '--variables-file',
      dir .. '/vars.txt',
    },
    cwd = dir,
    skip_validation = true,
    on_exit = vim.schedule_wrap(function(job, status)
      if status ~= 0 then
        pcall(
          vim.api.nvim_chan_send,
          channel,
          table.concat(job:stderr_result(), G.nl)
        )
      else
        pcall(vim.api.nvim_chan_send, channel, table.concat(job:result(), G.nl))
      end
    end),
  }):start()
end, {})
