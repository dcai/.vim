local vim_home = vim.fn.expand('<sfile>:p:h')

vim.cmd(string.format('source %s/vimrc', vim_home))

function find_executable(files)
  for _, file in ipairs(files) do
    if vim.fn.executable(file) then
      return file
    end
  end
  return nil
end

vim.g.python3_host_prog = find_executable({
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
