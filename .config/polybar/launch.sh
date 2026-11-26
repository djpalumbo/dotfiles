#!/bin/bash

# Serialize launches: i3's exec_always and wal-set (on every theme/wallpaper
# change) can run this at the same moment, and two overlapping runs would each
# kill the old bars and then each start new ones, leaving duplicates.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/polybar-launch.lock"
flock 9

# The bars are override-redirect (drawn over i3, not docked in it), so each
# monitor gets a ~/.scripts/dock-spacer holding the bar's space in i3's dock
# area instead. Spacers persist across relaunches, so the layout never shifts.
height=$(awk -F= '/^height *=/ { gsub(/ /, "", $2); print $2; exit }' \
  ~/.config/polybar/config)
# Active monitors only: one that's connected but switched off has nowhere to
# put a bar. Lines look like " 0: +*eDP-1 1920/344x1080/193+0+0  eDP-1".
monitors=()
want=()
while read -r _ _ geo name; do
  [[ $geo =~ ^([0-9]+)/[0-9]+x[0-9]+/[0-9]+\+([0-9]+)\+([0-9]+)$ ]] || continue
  monitors+=("$name")
  want+=("${BASH_REMATCH[1]}x${height}+${BASH_REMATCH[2]}+${BASH_REMATCH[3]}")
done < <(xrandr --listactivemonitors)
# Keep one spacer per wanted geometry; end the rest (e.g. a monitor's old spot)
declare -A spacer
while read -r pid geo; do
  if [[ -z ${spacer[$geo]} && " ${want[*]} " == *" $geo "* ]]; then
    spacer[$geo]=$pid
  else
    kill "$pid"
  fi
done < <(pgrep -af '^python3 [^ ]*/dock-spacer [^ ]+$' | awk '{ print $1, $NF }')
for geo in "${want[@]}"; do
  if [[ -z ${spacer[$geo]} ]]; then
    ~/.scripts/dock-spacer "$geo" 9>&- &
  fi
done

# Crossfade: start the new bars while the old ones are still up (picom fades
# them in), then end the old ones (picom fades them out). A new bar takes over
# the tray once the old one lets go of it. (9>&-: the bars mustn't inherit and
# hold the lock.)
old=$(pgrep -d" " -x polybar)
pids=()
for m in "${monitors[@]}"; do
  MONITOR=$m polybar --reload main 9>&- &
  pids+=($!)
done

if [[ -n $old ]]; then
  # Once the new bars are on screen and faded in
  for _ in {1..100}; do
    up=1
    for p in "${pids[@]}"; do
      xdotool search --onlyvisible --pid "$p" >/dev/null 2>&1 || { up=0; break; }
    done
    (( up )) && break
    sleep 0.05
  done
  sleep 0.3
  kill $old 2>/dev/null

  # Wait until the old bars have shut down. One can survive SIGTERM, and
  # waiting on it forever while holding the lock stalls every later launch, so
  # give it 5 s, then stop its module scripts (letting their traps run) and
  # SIGKILL it.
  alive() { for p in $old; do kill -0 "$p" 2>/dev/null && return 0; done; return 1; }
  for _ in {1..25}; do
    alive || break
    sleep 0.2
  done
  if alive; then
    for p in $old; do pkill -P "$p"; done
    kill -KILL $old 2>/dev/null
    while alive; do sleep 0.2; done
  fi
fi

echo "Bars launched..."
