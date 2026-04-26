local ok, fff = pcall(require, 'fff')
if not ok then
  return
end
fff.setup({
  base_path = vim.fn.getcwd(),
  prompt = '> ',
  layout = {
    width = 0.9,
  },
  preview = {
    enabled = false,
    max_size = 10 * 1024 * 1024,
    chunk_size = 8192,
    binary_file_threshold = 1024,
    imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
    line_numbers = false,
    cursorlineopt = 'both',
    wrap_lines = false,
    filetypes = {
      svg = { wrap_lines = true },
      markdown = { wrap_lines = true },
      text = { wrap_lines = true },
    },
  },
  keymaps = {
    close = { '<Esc>', '<C-c>' },
  },
  git = {
    status_text_color = true,
  },
})
