local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')
if not lspconfig_loaded then
  return
end
local root_pattern = nvim_lspconfig.util.root_pattern

vim.api.nvim_create_user_command('HurlRun', function()
  local current_dir = vim.fn.expand('%:p:h')
  local project_root = root_pattern('.git')(current_dir)
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
      project_root .. '/vars.txt',
    },
    cwd = project_root,
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
