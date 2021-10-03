##############
# APPEARANCE #
##############
# Window transparency
picom -b
# Set desktop wallpaper and terminal colorscheme (set via ~/.wallpaper).
# Also, note the (cat ~/.cache/wal/sequences &) in .bashrc & .zshrc
wal -i ~/Pictures/Wallpapers -o ~/.scripts/wal-set -e

####################
# STARTUP SETTINGS #
####################
# Start session with numlock enabled
numlockx
# Lock on system power change
xss-lock ~/.scripts/basiclock &

