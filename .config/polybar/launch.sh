#!/bin/bash

# Serialize launches: i3's exec_always and wal-set (on every theme/wallpaper
# change) can run this at the same moment, and two overlapping runs would each
# kill the old bars and then each start new ones, leaving duplicates.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/polybar-launch.lock"
flock 9

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down. A bar can survive SIGTERM (one
# started a second before a run missed it), and waiting on it forever while
# holding the lock stalls every later launch, so give it 5 s, then stop its
# module scripts (letting their traps run) and SIGKILL it.
for _ in {1..25}; do
  pgrep -x polybar >/dev/null || break
  sleep 0.2
done
if bars=$(pgrep -d, -x polybar); then
  pkill -P "$bars"
  killall -q -KILL polybar
  while pgrep -x polybar >/dev/null; do sleep 0.2; done
fi

# Launch bar (9>&-: the bars mustn't inherit and hold the lock)
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main 9>&- &
  done
else
  polybar --reload main 9>&- &
fi

echo "Bars launched..."
