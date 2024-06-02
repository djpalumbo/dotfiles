##############
# APPEARANCE #
##############
# Window transparency
picom -b
# Ensure that when HDMI output is enabled it is above the laptop display
# TODO: Update this to use variables in ~/.scripts/toggle-hdmi-out
if xrandr | grep -E "HDMI-1 connected [[:digit:]]+x[[:digit:]]+"; then
  xrandr --output HDMI-1 --auto --above eDP-1
fi
# Set desktop wallpaper and terminal colorscheme (set via ~/.wallpaper).
# Also, note the (cat ~/.cache/wal/sequences &) in .bashrc & .zshrc
wal -i ~/Pictures/Wallpapers -o ~/.scripts/wal-set

####################
# STARTUP SETTINGS #
####################
# Start session with numlock enabled
numlockx
# Lock on system power change
xss-lock ~/.scripts/basiclock &
# libinput-gestures
libinput-gestures-setup start

