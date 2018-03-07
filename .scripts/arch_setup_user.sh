#!/bin/bash


# Make sure WiFi network is accessible
while [[ "0%" != $(ping -c 3 8.8.8.8 | grep "packet loss" | cut -d " " -f 6) ]]
do
  echo -e "Connect to a WiFi network\n"
  wifi-menu
done


# Set the timezone
timedatectl set-timezone America/New_York
# Make time/date auto-sync
timedatectl set-ntp true


# Install trizen, an AUR package manager and pacman companion
git clone https://aur.archlinux.org/trizen.git /tmp/trizen
cd /tmp/trizen
makepkg -si
cd ~
sudo rm -r /tmp/trizen


# Remove quirky 'man' directory so that universal-ctags can install
sudo rm /usr/local/share/man


# Install packages from the AUR
trizen -S --noedit --noconfirm                                                 \
  light-git                                                                    \
\
  xss-lock                                                                     \
\
  zscroll-git                                                                  \
  ttf-iosevka  ttf-font-awesome-4  ttf-material-design-icons                   \
  polybar-git                                                                  \
\
  paper-icon-theme-git                                                         \
  urxvt-resize-font-git                                                        \
  powerline-fonts-git                                                          \
\
  python-pywal                                                                 \
\
  universal-ctags                                                              \
  visual-studio-code-bin                                                       \
  android-studio  android-tools  android-udev                                  \
\
  insync                                                                       \
\
  chromium-widevine                                                            \
\
  mopidy-soundcloud  mopidy-spotify  mopidy-spotify-web                        \
\
  rambox-bin                                                                   \
\
  masterpdfeditor                                                              \
\
  neofetch  bash-pipes  cli-visualizer  cava                                   \
\


# Allow Android Studio to manage SDK installations via a user group
sudo groupadd sdkusers
sudo gpasswd -a $(whoami) sdkusers
sudo mkdir /opt/android-sdk
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
# NOTE: Once the system has rebooted, open Android Studio
#       Install the sdk to /opt/android-sdk/
#       Then you can download various SDK's
#       Finally, delete the following directories (they cause problems):
#         /opt/android-sdk/emulator/lib/libstdc++
#         /opt/android-sdk/emulator/lib64/libstdc++


# Install packages from NPM
sudo npm install -g                                                            \
  vtop  gtop                                                                   \
\
  js-beautify                                                                  \
\
  react-native-cli                                                             \
\


# Set up SDDM
sudo cp -r /usr/lib/sddm/sddm.conf.d /etc/
# Install the Aerial SDDM theme
sudo pacman -S qt5-multimedia  gst-libav  phonon-qt5-gstreamer  gst-plugins-good
sudo git clone https://github.com/3ximus/aerial-sddm-theme \
  /usr/share/sddm/themes/aerial
sudo sed -i -e "s/Current=/Current=aerial/g" /etc/sddm.conf.d/sddm.conf


# Start certain daemons on boot
sudo systemctl enable NetworkManager.service
sudo systemctl enable wpa_supplicant.service
sudo systemctl enable sddm.service
sudo systemctl enable bluetooth.service
sudo systemctl enable insync@$(whoami).service


# Remove unnecessary WiFi configuration now that NetworkManager is installed
sudo systemctl disable netctl-auto@wlp3s0.service
sudo pacman -R iw wpa_actiond


################################################################################

# Configure git
echo "Let's configure git for $(whoami)."
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
echo -e "Git settings have been configured.\n"


# Clone my dotfiles
git init
git remote add origin https://github.com/djpalumbo/dotfiles.git
git fetch --all
git reset --hard origin/master


# Move scripts into /usr/bin
sudo cp ~/.scripts/basiclock /usr/bin
sudo cp ~/.scripts/blurlock /usr/bin
sudo cp ~/.scripts/pixlock /usr/bin
sudo chmod +x /usr/bin/basiclock /usr/bin/blurlock /usr/bin/pixlock
sudo cp ~/.scripts/wal-set /usr/bin
sudo chmod +x /usr/bin/wal-set


# Create user directories
xdg-user-dirs-update
mkdir ~/Pictures/Screenshots
# Make the directory structure convenient using symbolic links
ln -s /mnt/windows/Users/Dave ~/dwin
ln -s /mnt/windows/Users/Dave/Google\ Drive ~/gdrive
ln -s /mnt/windows/Users/Dave/Google\ Drive/vimwiki ~/vimwiki
ln -s /mnt/windows/Users/Dave/Google\ Drive/Wallpapers ~/Pictures/Wallpapers
ln -s /mnt/windows/Users/Dave/repos ~/repos


# Install scripts for urxvt
mkdir -p ~/.urxvt/ext/
git clone https://github.com/pkkolos/urxvt-scripts ~/.urxvt/ext


# Set up neovim
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
alias vim="nvim"
# Install vim-plug:
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Update and initialize plugins
nvim +PlugInstall +UpdateRemotePlugins +xall


# Use zsh instead of bash
chsh -s $(which zsh)


################################################################################

reboot

