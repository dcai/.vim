vim.api.nvim_create_user_command('HurlRun', function()
  local dir = vim.g.git_root()
  -- run current file
  local ft = vim.bo.filetype
  if not vim.tbl_contains({ 'hurl' }, ft) then
    vim.g.logger.warn('Not a hurl file')
    return
  end
  local filepath = vim.fn.expand('%:p')
  -- local popup = vim.g.new_popup({ title = 'hurl', number = false })
  -- popup.open()
  local PJob = require('plenary.job')

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(bufnr)
  -- local channel = vim.api.nvim_open_term(popup.buffer, {})
  -- local channel = vim.api.nvim_open_term(bufnr, {})
  -- local hr = vim.g.nl .. '============' .. vim.g.nl
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    'loading...',
  })

  local args = {
    '--color',
    '--insecure',
    filepath,
  }

  if dir and vim.g.file_exists(dir .. '/vars.txt') then
    table.insert(args, '--variables-file')
    table.insert(args, dir .. '/vars.txt')
  end

  PJob:new({
    command = 'hurl',
    args = args,
    cwd = dir,
    skip_validation = true,
    on_exit = vim.schedule_wrap(function(job, status)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
      vim.api.nvim_set_option_value('filetype', 'json', { buf = bufnr })
      if status ~= 0 then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, job:stderr_result())
      else
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, job:result())
      end
    end),
  }):start()
end, {})
