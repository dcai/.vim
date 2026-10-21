-- Native TypeScript 7+ LSP. Prefer a project-local compiler, then PATH.
-- Based on neovim/nvim-lspconfig's lsp/tsc.lua, without the tsgo fallback.
local mylsputils = require('dcai.lsp.utils')
local bin_cache = {}

local function supports_lsp(bin)
  if vim.fn.executable(bin) ~= 1 then
    return false
  end
  local result = vim.system({ bin, '--version' }, { text = true }):wait()
  local version = vim.version.parse(result.stdout or '')
  return result.code == 0 and version ~= nil and version.major >= 7
end

vim.lsp.config('tsc', {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({
      bin_cache[config.root_dir] or 'tsc',
      '--lsp',
      '--stdio',
    }, dispatchers)
  end,
  filetypes = mylsputils.ts_ls_supported_filetypes,
  on_attach = mylsputils.common_on_attach,
  -- Keep position encoding aligned with the Copilot client.
  capabilities = mylsputils.get_lsp_capabilities({
    general = { positionEncodings = { 'utf-16' } },
    workspace = { didChangeConfiguration = { dynamicRegistration = true } },
  }),
  settings = {
    ['js/ts'] = {
      inlayHints = {
        parameterNames = {
          enabled = 'literals',
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    local project_root = vim.fs.root(bufnr, mylsputils.ts_root_markers)
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, 'deno.lock')
    if
      deno_lock_root and (not project_root or #deno_lock_root > #project_root)
    then
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return
    end

    local root = project_root or vim.fn.getcwd()
    if bin_cache[root] then
      on_dir(root)
      return
    end
    for _, bin in ipairs({
      vim.fs.joinpath(root, 'node_modules/.bin/tsc'),
      'tsc',
    }) do
      if supports_lsp(bin) then
        bin_cache[root] = bin
        on_dir(root)
        return
      end
    end
    vim.notify(
      'tsc: requires a TypeScript 7.0+ compiler with --lsp support',
      vim.log.levels.WARN
    )
  end,
})
