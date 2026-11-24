#!/usr/bin/env bash
# [module/theme] (tail = true): print a sun or moon for the applied light/dark
# mode, then again whenever it changes. ~/.scripts/theme/apply records the mode.
#
# Polls rather than using custom/ipc, whose initial hook output often fails to
# appear in polybar 3.7. Builtins only (no sleep, no $(...)), since it runs every
# second: a process started while pacman is replacing glibc can crash. Polybar
# shows stderr too, so silence it or bash's crash report becomes the label.
# Font Awesome Solid is polybar font-3, i.e. %{T4}.

exec 2>/dev/null
# A pipe nothing ever writes to: `read -t` on it is a builtin sleep
exec {idle}<> <(:)

applied="${XDG_RUNTIME_DIR:-/tmp}/theme-applied"
last=
while :; do
  mode=dark
  [[ -r $applied ]] && read -r mode < "$applied"
  [[ $mode == light ]] && icon=$'%{T4}\uf185%{T-}' || icon=$'%{T4}\uf186%{T-}'
  [[ $icon != "$last" ]] && { echo "$icon"; last=$icon; }
  read -rt 1 -u "$idle"
done
