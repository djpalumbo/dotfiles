#!/bin/bash


# (Optional) Format the entire disk
#dd if=/dev/zero of=/dev/sda bs=1M status=progress


# Identify existing disk partitions if needed
#lsblk


# Partition the disk if not already done
# sda1 is boot
#   /dev/sda2  |  +24G   |  8200  |  Linux swap
#   /dev/sda3  |  +96G   |  8304  |  Linux x86-64 root (/)
#   /dev/sda4  |  (end)  |  8302  |  Linux /home
#gdisk /dev/sda


# Create and enable swap
#mkswap /dev/sda2
#swapon /dev/sda2
# Format root and home partitions
#mkfs.ext4 /dev/sda3
#mkfs.ext4 /dev/sda4


# Mount the partitions, creating directories where necessary
#mount /dev/sda3 /mnt
#mkdir /mnt/home
#mount /dev/sda4 /mnt/home
#mkdir /mnt/boot
#mount /dev/sda1 /mnt/boot


# Remove boot files if previous install
rm /mnt/boot/vmlinuz-linux
rm /mnt/boot/intel-ucode.img


# Make sure WiFi network is accessible
while [[ "0%" != $(ping -c 3 8.8.8.8 | grep "packet loss" | cut -d " " -f 6) ]]
do
  echo -e "Connect to a WiFi network:\n"
  echo -e "\t[iwd]# device list"
  echo -e "\t[iwd]# station DEVICE scan"
  echo -e "\t[iwd]# station DEVICE get-networks"
  echo -e "\t[iwd]# station DEVICE connect SSID\n"
done


# Sync database, update keyring, and update pacman mirrorlist
pacman -Sy
pacman -S --noconfirm archlinux-keyring  reflector
reflector --verbose --country 'United States' --sort rate --save /etc/pacman.d/mirrorlist
# Double-check that everything went OK; if not, manually put US mirrors up top
vim /etc/pacman.d/mirrorlist


# Install packages
pacstrap -i /mnt --noconfirm                                                   \
  base  linux  linux-firmware                                                  \
  base-devel  linux-headers                                                    \
\
  intel-ucode                                                                  \
\
  reflector                                                                    \
\
  iwd                                                                          \
\
  tlp                                                                          \
\
  xorg  xorg-xinit                                                             \
  xf86-video-nouveau  mesa                                                     \
  xf86-input-synaptics  numlockx                                               \
\
  pipewire  wireplumber  qpwgraph                                              \
  pipewire-alsa  pipewire-pulse  pipewire-jack                                 \
  pavucontrol  alsa-utils                                                      \
  blueman                                                                      \
\
  sddm                                                                         \
\
  i3-wm                                                                        \
\
  polybar  ttf-dejavu  woff2-font-awesome                                      \
\
  picom                                                                        \
  dunst                                                                        \
  python-pywal  feh                                                            \
  redshift  python-xdg                                                         \
\
  rofi                                                                         \
  i3lock  xss-lock                                                             \
  alacritty  powerline  ttf-hack-nerd                                          \
  nemo  nemo-fileroller  nemo-preview                                          \
  lxappearance                                                                 \
\
  chromium  firefox                                                            \
  vlc  libmicrodns  protobuf                                                   \
  code                                                                         \
  gimp  inkscape                                                               \
  audacity                                                                     \
  libreoffice                                                                  \
  zathura  zathura-pdf-mupdf  zathura-djvu                                     \
  gucharmap                                                                    \
  cups  sane  python-pillow  hplip                                             \
\
  wget                                                                         \
  ack                                                                          \
  htop  powertop                                                               \
  zsh                                                                          \
  git  github-cli                                                              \
  neovim  xclip  python-pynvim                                                 \
  ranger  highlight  atool  w3m                                                \
  fzf  the_silver_searcher                                                     \
  speedcrunch  bc                                                              \
  p7zip                                                                        \
  tree                                                                         \
  openssh                                                                      \
  scrot                                                                        \
\
  ntfs-3g                                                                      \
\
  playerctl                                                                    \
\
  texlive-most                                                                 \
\
  transmission-cli                                                             \
\
  aws-cli                                                                      \
\
  xdg-user-dirs                                                                \
\
  arc-gtk-theme                                                                \
\
  obsidian                                                                     \
\
  reaper                                                                       \
\
  neofetch                                                                     \
  fortune-mod  cowsay  lolcat  cmatrix                                         \
\


# Generate mount configuration file
genfstab -U /mnt > /mnt/etc/fstab


# Switch from USB to Arch root on your system
wget https://raw.githubusercontent.com/djpalumbo/dotfiles/master/.scripts/arch-install/arch-setup.sh
mv arch-setup.sh /mnt/
chmod +x /mnt/arch-setup.sh
arch-chroot /mnt ./arch-setup.sh

