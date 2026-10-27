-- Run: nvim --headless --clean -l tests/pack-test.lua
vim.opt.runtimepath:append(vim.fn.getcwd())
local pack = require('dcai.pack')
local events, setups = {}, {}
local added, fail_build = false, false
local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), vim.inspect(actual))
end
local function setup(name)
  assert(added, 'setup must run after all packages are added')
  setups[#setups + 1] = name
end
local function build(data)
  assert(
    vim.list_contains(vim.opt.runtimepath:get(), data.path),
    'build path missing'
  )
  assert(data.active == (data.kind == 'update'), 'build metadata changed')
  if fail_build then
    error('fixture build failed')
  end
  events[#events + 1] = data.kind .. ':' .. data.spec.name
end

-- Test the adapter, not the personal plugin inventory or individual settings.
local plugin = {
  src = 'https://example.test/owner/plugin.git',
  name = 'renamed',
  version = vim.version.range('1.*'),
  data = { marker = true },
  setup = function()
    setup('renamed')
  end,
  build = build,
}
pack.specs = {
  'https://example.test/owner/plain',
  plugin,
  {
    src = 'https://example.test/owner/derived.git',
    setup = function()
      setup('derived')
    end,
    build = build,
  },
}
local expected = {
  pack.specs[1],
  {
    src = plugin.src,
    name = plugin.name,
    version = plugin.version,
    data = plugin.data,
  },
  { src = pack.specs[3].src },
}
local clean = pack.native_specs()
equal(clean, expected)
assert(
  clean[2] ~= plugin and clean[2].version == plugin.version,
  'copy must preserve version'
)
assert(plugin.setup and plugin.build, 'stripping must not mutate declarations')
equal(setups, {})

local function changed(name, kind)
  vim.api.nvim_exec_autocmds('PackChanged', {
    data = {
      spec = { name = name },
      path = '/tmp/pack-test/' .. name,
      kind = kind,
      active = kind == 'update',
    },
  })
end
vim.pack.add = function(specs)
  added = false
  equal(specs, expected)
  local runtimepath = vim.o.runtimepath
  equal(#vim.api.nvim_get_autocmds({ group = 'dcai_pack_builds' }), 1)
  -- Cold-install events have native metadata, without our callback fields.
  if #events == 0 then
    changed('renamed', 'install')
    changed('derived', 'install')
    equal(setups, {})
  end
  equal(vim.o.runtimepath, runtimepath)
  added = true
end
pack.setup()
equal(setups, { 'renamed', 'derived' })
changed('renamed', 'update')
changed('derived', 'update')
equal(events, {
  'install:renamed',
  'install:derived',
  'update:renamed',
  'update:derived',
})
changed('renamed', 'delete')
changed('unrelated', 'install')
equal(#events, 4)
equal(setups, { 'renamed', 'derived' })

pack.setup()
equal(setups, { 'renamed', 'derived', 'renamed', 'derived' })
local hooks = vim.api.nvim_get_autocmds({ group = 'dcai_pack_builds' })
equal(#hooks, 1)
local runtimepath = vim.o.runtimepath
fail_build = true
-- Call directly because Neovim reports autocmd errors instead of throwing them.
local ok, err = pcall(hooks[1].callback, {
  data = {
    spec = { name = 'renamed' },
    path = '/tmp/pack-test/renamed',
    kind = 'update',
    active = true,
  },
})
assert(
  not ok and tostring(err):find('fixture build failed', 1, true),
  'build error lost'
)
equal(vim.o.runtimepath, runtimepath)
print(
  'Native packages: callback stripping, setup order, build events and cleanup passed'
)
