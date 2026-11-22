#!/bin/bash


# Set the timezone
timedatectl set-timezone America/Los_Angeles
# Make time/date auto-sync
timedatectl set-ntp true


# Install yay, an AUR package manager and pacman companion
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
cd ~
rm -rf /tmp/yay


# Install packages from the AUR
yay -S --noconfirm                                                             \
  zscroll-git                                                                  \
\
  iwgtk  snixembed                                                             \
\
  libinput-gestures                                                            \
\
  fonts-tlwg                                                                   \
\
  insync                                                                       \
\
  spotify                                                                      \
  polybar-spotify                                                              \
\
  bash-pipes  cli-visualizer  cbonsai  unimatrix                               \
\


# Configure git
echo -e "\nLet's configure git."
read -p "What's your email? " email
confirm=n
while [[ $confirm != y && $confirm != Y ]]; do
  read -p "'$email'? Is that right? (y/n) " confirm
  if [[ $confirm != y && $confirm != Y ]]; then
    echo; read -p "What's your email? " email
  fi
done
git config --global user.email "$email"
echo
read -p "What's your git username? " gitname
confirm=n
while [[ $confirm != y && $confirm != Y ]]; do
  read -p "'$gitname'? Is that right? (y/n) " confirm
  if [[ $confirm != y && $confirm != Y ]]; then
    echo; read -p "What's your git username? " gitname
  fi
done
git config --global user.name "$gitname"
# Cache credentials for one hour
git config credential.helper 'cache --timeout=3600'
echo -e "Git settings have been configured.\n"


# Clone my dotfiles
git init
git remote add origin https://github.com/djpalumbo/dotfiles.git
git fetch --all
git reset --hard origin/master
# You'll want to run the following:
#gh auth login


# Save an approximate location for sunrise/sunset times (redshift, darkman). It
# stays out of the dotfiles repo; two decimal places is plenty.
echo
read -p "Latitude (e.g. 47.61)? " lat
read -p "Longitude (e.g. -122.34, negative = west)? " lng
confirm=n
while [[ $confirm != y && $confirm != Y ]]; do
  read -p "'$lat, $lng'? Is that right? (y/n) " confirm
  if [[ $confirm != y && $confirm != Y ]]; then
    echo; read -p "Latitude? " lat; read -p "Longitude? " lng
  fi
done
mkdir -p ~/.config
cat > ~/.config/location <<EOF
# Approximate location, for sunrise/sunset times. Untracked; written by
# ~/.scripts/arch-install/arch-user-setup.sh.
LAT=$lat
LNG=$lng
EOF
echo -e "Location saved to ~/.config/location.\n"


# TODO: Link input peripheral settings


# Create user directories
xdg-user-dirs-update
mkdir ~/gdrive
mkdir ~/Pictures/Screenshots
mkdir ~/repos
# Make the directory structure convenient using symbolic links
# TODO: Sync ~/gdrive before running these
#ln -s ~/gdrive/Readings ~/Documents/Readings
#ln -s ~/gdrive/Music\ Production ~/Music/Music\ Production
#ln -s ~/gdrive/Readings/Manuals/Music ~/Music/Manuals
#ln -s ~/gdrive/Obsidian\ Vault ~/Obsidian\ Vault
#ln -s ~/gdrive/Wallpapers ~/Pictures/Wallpapers


# Keep Fn+F3 from pushing the keyboard backlight "below off" (asus-wmi bug)
sudo ~/.scripts/kbd-backlight-sync/install

# Install the aerial-fade SDDM login theme from the dotfiles
sudo ~/.scripts/aerial-fade/install
read -p "Download aerial login videos now (5 videos, ~0.5-1 GB)? (y/n) " fetch
if [[ $fetch == y || $fetch == Y ]]; then
  ~/.scripts/aerial-fetch 5
else
  echo "Skipped; the login screen stays black until you run ~/.scripts/aerial-fetch"
fi


# Enable libinput-gestures
sudo gpasswd -a $USER input


# Set up printing: Brother MFC-L2700DW on the LAN, driverless (IPP Everywhere).
# Addressed by mDNS name (resolved by systemd-resolved), so a DHCP change doesn't
# break it. Scanning needs no setup: sane-airscan finds it over WSD.
# NOTE: Never run its "Firmware Update" -- it's on 2016 firmware (L1604111143),
# predating Brother's alleged third-party-toner lockouts.
lpadmin -p "Brother_MFC-L2700DW" -E -v "ipp://BRN30055C738CBD.local/ipp/print" -m everywhere -D "Brother MFC-L2700DW"
lpoptions -d "Brother_MFC-L2700DW"


# Done!
reboot

