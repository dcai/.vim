local marker = '# ===== #'

local function save(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.write()
  end)
end

local function clear_previous_output(bufnr)
  local first
  for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    if line == marker then
      if first then
        vim.api.nvim_buf_set_lines(bufnr, first - 1, i, false, {})
        break
      end
      first = i
    end
  end
end

local function append(bufnr, lines)
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
  -- Async completion must save this buffer, not the current user's buffer.
  save(bufnr)
end

vim.api.nvim_create_user_command('HurlRun', function()
  if vim.bo.filetype ~= 'hurl' then
    vim.notify('Error: this is not hurl file', vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.g.git_root()
  local cwd = dir or vim.fn.getcwd()
  local args = { '--no-color', '--insecure', filepath }
  if dir then
    local variables = vim.fs.joinpath(dir, 'vars.txt')
    if vim.fn.filereadable(variables) == 1 then
      vim.list_extend(args, { '--variables-file', variables })
    end
  end

  clear_previous_output(bufnr)
  append(bufnr, { marker, '# loading ' .. os.date('%Y-%m-%d %H:%M:%S') })
  require('dcai.job').run({
    command = 'hurl',
    args = args,
    cwd = cwd,
    on_exit = function(result)
      if
        not vim.api.nvim_buf_is_valid(bufnr)
        or not vim.api.nvim_buf_is_loaded(bufnr)
      then
        return
      end
      local lines =
        { '# Done, see response below ' .. os.date('%Y-%m-%d %H:%M:%S') }
      local output = result.ok and result.stdout or result.stderr
      if output ~= '' then
        vim.list_extend(
          lines,
          vim.split((output:gsub('\n$', '')), '\n', { plain = true })
        )
      end
      lines[#lines + 1] = marker
      append(bufnr, lines)
      if not result.ok then
        vim.notify('Hurl job failed', vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = 'Run the current Hurl file and save its response' })
