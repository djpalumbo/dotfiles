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
# XSETTINGS daemon, so running GTK3 apps follow light/dark theme changes
command -v xsettingsd >/dev/null && xsettingsd &
# Light/dark theme: darkman runs ~/.scripts/theme/apply, which sets a matching
# wallpaper + wal colorscheme (see ~/.scripts/theme/). Restarting re-runs its
# hook; clearing the marker makes it apply for this new session.
# Also, note the (cat ~/.cache/wal/sequences &) in .bashrc & .zshrc
rm -f "${XDG_RUNTIME_DIR}/theme-applied"
systemctl --user restart darkman || wal -i ~/Pictures/Wallpapers -o ~/.scripts/theme/wal-set

####################
# STARTUP SETTINGS #
####################
# Start session with numlock enabled
numlockx
# Lock on system power change
xss-lock -l -- "${1:-${HOME}/.scripts/lock/basiclock}" &
# libinput-gestures
libinput-gestures-setup start
# Notify when default audio output changes
~/.scripts/pa-notify &
# IBus daemon for Unicode/IM input (Ctrl+Shift+U in Alacritty)
ibus-daemon -drx &

