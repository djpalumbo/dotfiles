###################
# LAPTOP TOUCHPAD #
###################
# Mouse sensitivity
xinput set-prop "Asus TouchPad" "Device Accel Constant Deceleration" 1.30
# Tap to click
xinput set-prop "Asus TouchPad" "Synaptics Tap Action" 1 1 1 1 1 1 1
# Natural scrolling
xinput set-prop "Asus TouchPad" "Synaptics Scrolling Distance" -66 -66

##############
# APPEARANCE #
##############
# Window transparency
compton -b
# Set desktop wallpaper and terminal colorscheme (set via ~/.wallpaper).
#  Also, note the (cat ~/.cache/wal/sequences &) in .bashrc & .zshrc
wal -i ~/Pictures/Wallpapers -o ~/.scripts/wal-set -e
# Make wal colors automatic (urxvt, polybar)
xrdb -merge ~/.cache/wal/colors.Xresources
# Status bar
~/.config/polybar/launch.sh

####################
# STARTUP SETTINGS #
####################
# Start session with numlock enabled
numlockx
# Lock on system power change
xss-lock ~/.scripts/basiclock

