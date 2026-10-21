local DIAGNOSTIC_LEVELS = {
  'ERR',
  'WARN',
  'INFO',
  'HINT',
}
local IGNORE_TS_DIAGNOSTICS_CODES = {
  80001, -- commonjs module
  2345, -- argument of type '<type>' is not assignable to parameter of type '<type>'
  -- 2339, -- property does not exist on type
  -- 6133, -- unused var
  7006, -- parameter implicitly has an 'any' type
  7016, -- missing declaration file
}
local IGNORE_PHP_DIAGNOSTIC_CODES = {
  'worse.undefined_variable',
}

local IGNORE_DIAGNOSTIC_CODES =
  vim.g.merge_list(IGNORE_PHP_DIAGNOSTIC_CODES, IGNORE_TS_DIAGNOSTICS_CODES)

vim.diagnostic.config({
  -- :help diagnostic-toggle-virtual-lines-example
  virtual_lines = false,
  virtual_text = {
    virt_text_pos = 'eol',
    -- virt_text_pos = 'eol_right_align',
    -- virt_text_pos = 'overlay',
    -- severity = { min = vim.diagnostic.severity.WARN },
    severity = { min = vim.diagnostic.severity.HINT },
    source = true,
    format = function(report)
      if DIAGNOSTIC_LEVELS[report.severity] then
        return string.format(
          '[%s] %s [%s]',
          report.code, -- this is a number, for example 80000
          report.message,
          DIAGNOSTIC_LEVELS[report.severity]
        )
      else
        return report.message
      end
    end,
  },
  underline = false, -- use underline for diagnostics
  float = {
    format = function(report)
      return string.format(
        'RULE_CODE: %s\n[%s] from [%s]\nMessage: %s',
        report.code,
        DIAGNOSTIC_LEVELS[report.severity],
        report.source,
        report.message
      )
    end,
  },
  signs = {
    severity = { min = vim.diagnostic.severity.HINT },
    linehl = {
      -- -- line hl has background color, so disable
      -- [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

-- Push, document-pull, and workspace-pull diagnostics all pass through here.
local set_diagnostics = vim.diagnostic.set
vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
  local filtered = vim.tbl_filter(function(diagnostic)
    local user_data = diagnostic.user_data
    local is_lsp = type(user_data) == 'table' and type(user_data.lsp) == 'table'
    return not (
      is_lsp and vim.list_contains(IGNORE_DIAGNOSTIC_CODES, diagnostic.code)
    )
  end, diagnostics)
  return set_diagnostics(namespace, bufnr, filtered, opts)
end
