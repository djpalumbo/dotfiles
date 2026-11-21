#!/bin/bash

# Serialize launches: i3's exec_always and wal-set (on every theme/wallpaper
# change) can run this at the same moment, and two overlapping runs would each
# kill the old bars and then each start new ones, leaving duplicates.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/polybar-launch.lock"
flock 9

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 0.2; done

# Launch bar (9>&-: the bars mustn't inherit and hold the lock)
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main 9>&- &
  done
else
  polybar --reload main 9>&- &
fi

echo "Bars launched..."
