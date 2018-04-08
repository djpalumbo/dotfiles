#!/bin/bash


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
pacman -S --noconfirm archlinux-keyring reflector
reflector --verbose --country 'United States' --sort rate --save /etc/pacman.d/mirrorlist


# Install packages
pacstrap -i /mnt --noconfirm                                                   \
  base  base-devel                                                             \
\
  linux-headers                                                                \
\
  wget                                                                         \
\
  efibootmgr  intel-ucode  ntfs-3g  gksu                                       \
\
  tlp                                                                          \
\
  wpa_supplicant  dialog  wireless_tools                                       \
  networkmanager  network-manager-applet                                       \
  dhclient  gnome-keyring                                                      \
  networkmanager-openconnect                                                   \
\
  xorg-server  xorg-xinit  xorg-xprop  mesa                                    \
  xf86-video-nouveau                                                           \
\
  i3-gaps  sddm                                                                \
  obconf                                                                       \
\
  xorg-xinput  xorg-xev  xf86-input-synaptics                                  \
  xclip  numlockx  gucharmap                                                   \
\
  pulseaudio  pulseaudio-alsa  pavucontrol  alsa-utils                         \
  blueman  pulseaudio-bluetooth  bluez  bluez-libs  bluez-utils                \
\
  htop  powertop                                                               \
\
  cmake  clang  gdb  peda                                                      \
  jdk8-openjdk                                                                 \
  python  python2  python-pip                                                  \
  nodejs  npm                                                                  \
\
  mariadb  mysqlworkbench                                                      \
  mongodb  mongodb-tools                                                       \
\
  uncrustify  yapf                                                             \
\
  git  termite  rxvt-unicode  zsh  powerline                                   \
  neovim  python-neovim  python2-neovim                                        \
  ranger  atool  w3m  rofi  compton  feh  scrot                                \
\
  virtualbox  virtualbox-host-modules-arch                                     \
  vagrant                                                                      \
\
  xdg-user-dirs                                                                \
  nemo  nemo-fileroller  nemo-preview                                          \
  lxappearance                                                                 \
\
  chromium  firefox                                                            \
  pepper-flash                                                                 \
\
  zathura  zathura-pdf-mupdf  zathura-djvu                                     \
  pdfsam                                                                       \
  texlive-most                                                                 \
  libreoffice                                                                  \
\
  xss-lock                                                                     \
  i3lock  imagemagick                                                          \
\
  mpd  mpc  ncmpcpp  mopidy                                                    \
  vlc  qt4                                                                     \
\
  speedcrunch  bc                                                              \
  p7zip                                                                        \
\
  python-xdg  redshift                                                         \
\
  audacity  gimp                                                               \
  blender  cura                                                                \
\
  transmission-cli                                                             \
\
  openssh  aws-cli                                                             \
\
  ttf-dejavu  ttf-inconsolata  ttf-roboto                                      \
  adobe-source-han-sans-kr-fonts                                               \
\
  parted  gparted                                                              \
\
  neofetch                                                                     \
  fortune-mod  cowsay  lolcat  cmatrix                                         \
\


# Generate mount configuration file
genfstab -U -p /mnt > /mnt/etc/fstab


# Switch from USB to Arch root on your system
wget https://raw.githubusercontent.com/djpalumbo/dotfiles/master/.scripts/arch_setup.sh
mv arch_setup.sh /mnt/
chmod +x /mnt/arch_setup.sh
arch-chroot /mnt ./arch_setup.sh

