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
rm -r /tmp/trizen


# Install packages from the AUR
trizen -S --noedit --noconfirm                                                 \
  light-git                                                                    \
  openbox-patched                                                              \
\
  zscroll-git                                                                  \
  ttf-iosevka  ttf-font-awesome-4  ttf-material-design-icons                   \
  polybar-git                                                                  \
\
  ultra-flat-icons-blue                                                        \
  urxvt-resize-font-git                                                        \
  powerline-fonts-git                                                          \
\
  python-pywal                                                                 \
\
  universal-ctags-git                                                          \
  visual-studio-code-bin                                                       \
  android-studio  android-tools  android-udev                                  \
\
  studio-3t                                                                    \
\
  vmware-workstation                                                           \
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
  bash-pipes  cli-visualizer  cava                                             \
\


################################################################################

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


# Create user directories
xdg-user-dirs-update
mkdir ~/Pictures/Screenshots
# Make the directory structure convenient using symbolic links
ln -s /mnt/windows/Users/Dave ~/dwin
ln -s /mnt/windows/Users/Dave/Google\ Drive ~/gdrive
ln -s /mnt/windows/Users/Dave/Google\ Drive/vimwiki ~/vimwiki
ln -s /mnt/windows/Users/Dave/Google\ Drive/Wallpapers ~/Pictures/Wallpapers
ln -s /mnt/windows/Users/Dave/Google\ Drive/3D\ Models ~/Documents/3D\ Models
ln -s /mnt/windows/Users/Dave/Google\ Drive/VLC\ Playlists ~/Music/VLC\ Playlists
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


# Download themes
# GTK
git clone https://github.com/addy-dclxvi/gtk-theme-collections /tmp/gtk-theme-collections
mv /tmp/gtk-theme-collections/Fantome ~/.themes/Fantome
rm -rf /tmp/gtk-theme-collections/
# Openbox
git clone https://github.com/addy-dclxvi/openbox-theme-collections /tmp/openbox-theme-collections
mv /tmp/openbox-theme-collections/Triste-Froly ~/.themes/Triste-Froly
mv /tmp/openbox-theme-collections/Vent ~/.themes/Vent
rm -rf /tmp/openbox-theme-collections/


# Use zsh instead of bash
chsh -s $(which zsh)


################################################################################


# Enable gdb-peda
echo "source ~/peda/peda.py" >> ~/.gdbinit


# Set up VMWare
# Enable these services as desired:
#sudo systemctl enable vmware-networks.service       # network access
#sudo systemctl enable vmware-usbarbitrator.service  # connecting USB devices
#sudo systemctl enable vmware-hostd.service          # sharing virtual machines
# Lastly, load the VMware modules:
#sudo modprobe vmw_vmci
#sudo modprobe vmmon
# Run 'vmplayer' unless you have a Workstation license key


################################################################################

# Done!
reboot

