local status_ok, pywal = pcall(require, "pywal")
if not status_ok then
  return
end

pywal.setup()

-- Reload colorscheme whenever wal regenerates colors
local w = (vim.uv or vim.loop).new_fs_event()
w:start(vim.fn.expand("~/.cache/wal"), {}, function(err, filename)
  if not err and filename == "colors-wal.vim" then
    vim.schedule(function()
      pywal.setup()
    end)
  end
end)
