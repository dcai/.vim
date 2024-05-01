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
  local testrunner = string.format(
    'cd %s; hurl --color --insecure %s',
    project_root,
    filepath
  )
  vim.cmd(string.format('VimuxRunCommand("%s")', testrunner))
end, {})
