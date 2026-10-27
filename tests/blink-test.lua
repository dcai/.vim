-- Run: nvim --headless --clean -l tests/blink-test.lua
-- Requires the native test dependencies; exercises the real async downloader.
vim.opt.runtimepath:append(vim.fn.getcwd())
vim.opt.packpath:append(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
vim.cmd.packadd({ 'blink.cmp', bang = true })

local path =
  vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack/core/opt/blink.cmp')
local tag = vim
  .system({ 'git', '-C', path, 'describe', '--tags', '--exact-match' })
  :wait()
assert(tag.code == 0, 'Blink must use a release tag for its prebuilt matcher')
local version = vim.trim(tag.stdout)
assert(
  vim.version.range('1.*'):has(version),
  'Expected a compatible 1.x release'
)

local notifications = {}
vim.notify = function(message)
  notifications[#notifications + 1] = tostring(message)
end
-- Test the actual configuration, not just get_lsp_capabilities(), which never
-- waits for the matcher download or proves that native matching is available.
dofile('after/plugin/blink_userconfig.lua')
local fuzzy = require('blink.cmp.fuzzy')
assert(
  vim.wait(120000, function()
    return fuzzy.implementation_type == 'rust'
  end, 20),
  'Rust matcher did not initialize: ' .. table.concat(notifications, '\n')
)
assert(
  vim.list_contains(fuzzy.get_words('local answer = 42'), 'answer'),
  'Native matcher did not extract words'
)
print(
  'Blink: release '
    .. version
    .. ', async initialization and Rust matcher verified'
)
