-- Run with isolated XDG_CONFIG_HOME and XDG_DATA_HOME to test latest upstream,
-- not the full configuration's lockfile or personal plugin installations.
vim.opt.packpath:append(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
vim.opt.runtimepath:append(vim.fn.getcwd())
local sources = {
  ['https://github.com/nvim-lua/plenary.nvim'] = true,
  ['https://github.com/copilotlsp-nvim/copilot-lsp'] = true,
  ['https://github.com/saghen/blink.cmp'] = true,
}
local specs = vim.tbl_filter(function(spec)
  local source = type(spec) == 'string' and spec or spec.src
  return sources[source]
end, require('dcai.pack').native_specs())
vim.pack.add(specs, { confirm = false, load = false })
for _, plugin in ipairs(vim.pack.get()) do
  print(plugin.spec.name .. ': ' .. plugin.rev)
end
