#!/bin/bash


# (Optional) Format the entire disk
#dd if=/dev/zero of=/dev/sda bs=1M status=progress


# Identify existing disk partitions if needed
#lsblk


# Partition the disk if not already done
# sda1 is boot while sda2-sda4 are Windows
#   /dev/sda5  |  +24G   |  8200  |  Linux swap
#   /dev/sda6  |  +48G   |  8304  |  Linux x86-64 root (/)
#   /dev/sda7  |  (end)  |  8302  |  Linux /home
#gdisk /dev/sda


# Create and enable swap
#mkswap /dev/sda5
#swapon /dev/sda5
# Format root and home partitions
#mkfs.ext4 /dev/sda6
#mkfs.ext4 /dev/sda7


# Mount the partitions, creating directories where necessary
#mount /dev/sda6 /mnt
#mkdir /mnt/home
#mount /dev/sda7 /mnt/home
#mkdir /mnt/boot
#mount /dev/sda1 /mnt/boot


# Remove boot files if previous install
rm /mnt/boot/vmlinuz-linux
rm /mnt/boot/intel-ucode.img


# Make sure WiFi network is accessible
while [[ "0%" != $(ping -c 3 8.8.8.8 | grep "packet loss" | cut -d " " -f 6) ]]
do
  echo -e "Connect to a WiFi network\n"
  wifi-menu
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
  efibootmgr  intel-ucode  ntfs-3g  exfat-utils                                \
\
  dhcpcd  dhclient                                                             \
  networkmanager                                                               \
  network-manager-applet  gnome-keyring                                        \
  networkmanager-openconnect                                                   \
\
  reflector                                                                    \
\
  tlp                                                                          \
\
  xorg  xorg-xinit                                                             \
  xf86-video-nouveau  mesa                                                     \
  xf86-input-synaptics  numlockx                                               \
\
  pulseaudio  pulseaudio-alsa  pavucontrol  alsa-utils                         \
  blueman  pulseaudio-bluetooth                                                \
\
  sddm                                                                         \
\
  i3-gaps                                                                      \
\
  picom                                                                        \
  python-pywal  feh                                                            \
  redshift  python-xdg                                                         \
\
  rofi                                                                         \
  i3lock  xss-lock                                                             \
  termite  powerline                                                           \
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
\
  wget                                                                         \
  ack                                                                          \
  htop  powertop                                                               \
  zsh                                                                          \
  git  hub                                                                     \
  neovim  xclip  python-pynvim                                                 \
  ranger  highlight  atool  w3m                                                \
  fzf  the_silver_searcher                                                     \
  speedcrunch  bc                                                              \
  p7zip                                                                        \
  tree                                                                         \
  openssh                                                                      \
  scrot                                                                        \
\
  mpd  mpc                                                                     \
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
  ttf-dejavu  ttf-inconsolata  ttf-roboto  ttf-hack                            \
\
  arc-gtk-theme                                                                \
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

