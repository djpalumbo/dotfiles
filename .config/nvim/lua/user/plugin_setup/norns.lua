local status_ok, norns = pcall(require, "norns")
if not status_ok then
  return
end

norns.setup{
    host = 'norns.local.',
    open = { cmd = 'new', range={10}},
    dust = nil,
}
