--- https://www.npmjs.com/package/@github/copilot-language-server
---
--- The Copilot Language Server enables any editor or IDE
--- to integrate with GitHub Copilot via
--- [the language server protocol](https://microsoft.github.io/language-server-protocol/).
---
--- **[GitHub Copilot](https://github.com/features/copilot)**
--- is an AI pair programmer tool that helps you write code faster and smarter.
---
--- **Sign up for [GitHub Copilot Free](https://github.com/settings/copilot)!**
---
--- Please see [terms of use for GitHub Copilot](https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features#github-copilot)

---@param bufnr integer,
---@param client vim.lsp.Client
local function sign_in(bufnr, client)
  client:request(
    ---@diagnostic disable-next-line: param-type-mismatch
    'signIn',
    vim.empty_dict(),
    function(err, result)
      if err then
        vim.print(err.message)
        return
      end
      if result.command then
        local code = result.userCode
        local command = result.command
        vim.fn.setreg('+', code)
        vim.fn.setreg('*', code)
        local continue = vim.fn.confirm(
          'Copied your one-time code to clipboard.\n'
            .. 'Open the browser to complete the sign-in process?',
          '&Yes\n&No'
        )
        if continue == 1 then
          client:exec_cmd(
            command,
            { bufnr = bufnr },
            function(cmd_err, cmd_result)
              if cmd_err then
                vim.print(cmd_err.message)
                return
              end
              if cmd_result.status == 'OK' then
                vim.print('Signed in as ' .. cmd_result.user .. '.')
              end
            end
          )
        end
      end

      if result.status == 'PromptUserDeviceFlow' then
        vim.print(
          'Enter your one-time code '
            .. result.userCode
            .. ' in '
            .. result.verificationUri
        )
      elseif result.status == 'AlreadySignedIn' then
        vim.print('Already signed in as ' .. result.user .. '.')
      end
    end
  )
end

---@param client vim.lsp.Client
local function sign_out(_, client)
  client:request(
    ---@diagnostic disable-next-line: param-type-mismatch
    'signOut',
    vim.empty_dict(),
    function(err, result)
      if err then
        vim.print(err.message)
        return
      end
      if result.status == 'NotSignedIn' then
        vim.print('Not signed in.')
      end
    end
  )
end

local features = require('dcai.lsp.copilot-features')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { 'utf-16' }
vim.lsp.config('copilot', {
  capabilities = capabilities,
  cmd = { 'copilot-language-server', '--stdio' },
  init_options = {
    editorInfo = { name = 'Neovim', version = tostring(vim.version()) },
    editorPluginInfo = {
      name = 'neovim-copilot-lsp',
      version = tostring(vim.version()),
    },
  },
  settings = {
    nextEditSuggestions = { enabled = false },
    telemetry = { telemetryLevel = 'all' },
  },
  -- Gate startup before didOpen can send the buffer's contents to the server.
  root_dir = function(bufnr, on_dir)
    if features.allowed(bufnr) then
      on_dir(
        vim.fs.root(bufnr, '.git')
          or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
      )
    end
  end,
  handlers = { didChangeStatus = features.status_handler },
  on_attach = function(client, bufnr)
    features.attach(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignIn', function()
      sign_in(bufnr, client)
    end, { desc = 'Sign in Copilot with GitHub' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignOut', function()
      sign_out(bufnr, client)
    end, { desc = 'Sign out Copilot with GitHub' })
  end,
})
vim.lsp.enable('copilot')
