local DIAGNOSTIC_LEVELS = {
  'ERR',
  'WARN',
  'INFO',
  'HINT',
}
local IGNORE_TS_DIAGNOSTICS_CODES = {
  80001, -- commonjs module
  6133, -- unused var
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

vim.lsp.handlers['textDocument/publishDiagnostics'] = function(
  __err,
  result,
  ctx,
  _config
)
  local filtered_diagnostic = {}
  for _i, diagnostic in ipairs(result.diagnostics) do
    -- vim.g.logger.info('all codes: ' .. vim.inspect(IGNORE_DIAGNOSTIC_CODES))
    -- vim.g.logger.info('code: ' .. vim.inspect(diagnostic.code))
    if not vim.tbl_contains(IGNORE_DIAGNOSTIC_CODES, diagnostic.code) then
      table.insert(filtered_diagnostic, diagnostic)
    end
  end

  result.diagnostics = filtered_diagnostic
  return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx)
end
