local lspconfig = require('lspconfig')
local mylsputils = require('dcai.lspconfig.utils')
local root_pattern = lspconfig.util.root_pattern

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return table.concat({ vim.env.VIRTUAL_ENV, 'bin', 'python' }, '/')
  end

  if workspace and vim.g.file_exists(workspace .. '/.venv') then
    return table.concat({ workspace, '.venv', 'bin', 'python' }, '/')
  end

  local py_path =
    table.concat({ vim.g.smart_root() or '', '.venv', 'bin', 'python' }, '/')

  if vim.g.file_exists(py_path) then
    return py_path
  else
    -- Fallback to system Python.
    return vim.g.python3_host_prog
  end
end

-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
lspconfig.pyright.setup({
  on_attach = mylsputils.common_on_attach,
  before_init = function(_, config)
    local py_path = get_python_path(config.root_dir)
    -- vim.g.logger.info('python binary: ' .. vim.inspect(py_path))
    config.settings.python.pythonPath = py_path
  end,
  settings = {
    pyright = {
      disableOrganizeImports = true, -- if use Ruff
    },
    python = {
      analysis = {
        ignore = { '*' }, -- if use Ruff
        --       typeCheckingMode = 'off', -- if use mypy
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
})
