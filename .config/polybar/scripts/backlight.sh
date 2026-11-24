#!/usr/bin/env bash
# [module/backlight] (tail = true): print a moon ramp and the screen brightness,
# then again whenever it changes. ~/.scripts/brightness sends SIGUSR1 after each
# step for an immediate redraw; otherwise it rechecks once a second, which also
# catches changes made by anything else.
#
# Not internal/backlight: polybar 3.7 sleeps 200 ms after each change and drops
# changes that arrive meanwhile, so held keys lag. Not custom/ipc: its initial
# hook output often fails to appear in polybar 3.7. Builtins only in the loop.

# Polybar shows stderr too: without this, `sleep` crashing (e.g. started while
# pacman is replacing glibc) puts bash's crash report in the bar
exec 2>/dev/null

dev=/sys/class/backlight/acpi_video0
ramp=(🌕 🌔 🌓 🌒 🌑)

# One file per running instance (one per bar), named by PID, for the signaller
pids="${XDG_RUNTIME_DIR:-/tmp}/polybar-backlight"
mkdir -p "$pids" && : > "$pids/$$"
trap 'rm -f "$pids/$$"' EXIT
trap 'exit' TERM INT HUP
trap ':' USR1   # just interrupts the wait below

read -r max < "$dev/max_brightness"
last=
while :; do
  read -r cur < "$dev/actual_brightness"
  pct=$(( (cur * 100 + max / 2) / max ))
  out="%{T2}${ramp[(pct * 4 + 50) / 100]}%{T-} $pct%"
  [[ $out != "$last" ]] && { echo "$out"; last=$out; }
  sleep 1 & wait $!
  kill $! 2>/dev/null
done
