local mylsputils = require('dcai.lsp.utils')
vim.lsp.config('sourcekit', {
  cmd = {
    '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp',
    '-Xswiftc',
    '-sdk',
    '-Xswiftc',
    -- get this form `xcrun --sdk iphonesimulator --show-sdk-path`
    '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk',
    '-Xswiftc',
    '-target',
    '-Xswiftc',
    -- use `generate-triple.sh` script to generate
    'arm64-apple-ios18.5-simulator',
  },
  on_attach = mylsputils.common_on_attach,
  capabilities = mylsputils.get_capabilities(),
  filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
})
vim.lsp.enable('sourcekit')
