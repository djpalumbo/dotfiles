#!/usr/bin/env bash
# [module/theme] (tail = true): print a sun or moon for the applied light/dark
# mode, then again whenever it changes. ~/.scripts/theme/apply records the mode.
#
# Polls rather than using custom/ipc, whose initial hook output often fails to
# appear in polybar 3.7. Builtins only, since it runs every second.
# Font Awesome Solid is polybar font-3, i.e. %{T4}.

applied="${XDG_RUNTIME_DIR:-/tmp}/theme-applied"
last=
while :; do
  mode=dark
  [[ -r $applied ]] && mode=$(< "$applied")
  [[ $mode == light ]] && icon=$'%{T4}\uf185%{T-}' || icon=$'%{T4}\uf186%{T-}'
  [[ $icon != "$last" ]] && { echo "$icon"; last=$icon; }
  sleep 1
done
