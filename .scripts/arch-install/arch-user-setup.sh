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
  light-git                                                                    \
\
  zscroll-git                                                                  \
\
  fonts-tlwg                                                                   \
\
  insync                                                                       \
\
  vtop                                                                         \
\
  chromium-widevine                                                            \
\
  spotify                                                                      \
\
  polybar-spotify                                                              \
\
  sddm-theme-aerial-git                                                        \
\
  bash-pipes  cli-visualizer  cava  cbonsai                                    \
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


# TODO: Link input peripheral settings


# Create user directories
xdg-user-dirs-update
mkdir ~/Pictures/Screenshots
mkdir ~/repos
# Make the directory structure convenient using symbolic links
ln -s /mnt/win/Users/Dave ~/dwin
ln -s /mnt/win/Users/Dave/Google\ Drive ~/gdrive
ln -s /mnt/win/Users/Dave/Google\ Drive/Obsidian\ Vault ~/Obsidian\ Vault
ln -s /mnt/win/Users/Dave/Google\ Drive/Wallpapers ~/Pictures/Wallpapers
ln -s /mnt/win/Users/Dave/Google\ Drive/3D\ Models ~/Documents/3D\ Models
ln -s /mnt/win/Users/Dave/Google\ Drive/VLC\ Playlists ~/Music/VLC\ Playlists
ln -s /mnt/win/Users/Dave/Google\ Drive/Teenage\ Engineering\ OP-1 ~/Music/Teenage\ Engineering\ OP-1


# Set up printing (with my old HP Deskjet F4400, hence the hplip package)
f4400cxn="hp:/usb/Deskjet_F4400_series?serial=CN04OCM1SQ05C5"
f4400driver=$(lpinfo -m | grep '^drv.*f4400.*ppd' | awk '{print $1}')
lpadmin -p "HP_Deskjet_F4400_series" -E -v $f4400cxn -m $f4400driver
lpoptions -d "HP_Deskjet_F4400_series"


# Done!
reboot

