#!/bin/bash


# Make sure WiFi network is accessible
while [[ "0%" != $(ping -c 3 8.8.8.8 | grep "packet loss" | cut -d " " -f 6) ]]
do
  echo -e "Connect to a WiFi network\n"
  wifi-menu
done
# Start WiFi daemon on boot
systemctl enable netctl-auto@wlp3s0.service
systemctl start netctl-auto@wlp3s0.service
# FIX: grep "ip link" to get interface name


# Use systemd-boot, since it's EFI
bootctl --path=/boot install
# Configure bootloader defaults
echo -e "default arch\ntimeout 3\neditor 0" > /boot/loader/loader.conf


# Copy default arch entry to boot loader entries
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/
# Fix options
sed -i -e "s/rootfstype=XXXX add_efi_memmap/rootfstype=ext4 add_efi_memmap rw/g" /boot/loader/entries/arch.conf
# Replace UUID with that of the new root partition
rootpart=$(lsblk | grep "/$" | cut -d " " -f 1 | sed "s/.*s/s/g")
sed -i -e "s/PARTUUID=XXXX/PARTUUID=$(blkid /dev/$rootpart | cut -d "\"" -f 6)/g" /boot/loader/entries/arch.conf
# Ensure that intel microcode is used
sed -i -e "/vmlinuz-linux/a initrd  \/intel-ucode.img" /boot/loader/entries/arch.conf


# Enable hibernation
swappart=$(lsblk | grep "SWAP" | cut -d " " -f 1 | sed "s/.*s/s/g")
echo "options resume=UUID=$(blkid /dev/$swappart | cut -d "\"" -f 2)" >> /boot/loader/entries/arch.conf
# Configure the initramfs
sed -i -e "s/^HOOKS.*/HOOKS=\"base udev resume autodetect modconf block filesystems keyboard fsck\"/g" /etc/mkinitcpio.conf
# Rebuild the initramfs
mkinitcpio -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img


# Allow Arch to see the Windows partition, assuming that it's on sda3
echo "/dev/sda3 /mnt/windows ntfs-3g defaults 0 0" >> /etc/fstab


# Set the root password
echo "Let's set the root password."
read -s -p "New password: " password; echo
read -s -p "Again, please: " password2; echo -e "\n"
while [[ $password != $password2 ]] ; do
  echo "The passwords do not match. Please, try again."
  read -s -p "New password: " password; echo
  read -s -p "Again, please: " password2; echo -e "\n"
done
echo "root:$password" | chpasswd
echo -e "The root password has been set.\n"


# Create user
echo "Now we'll create a new user."
read -p "What will be your user's name? " username
confirm=n
while [[ $confirm != y && $confirm != Y ]]; do
  read -p "'$username'? Is that right? (y/n) " confirm
  if [[ $confirm != y && $confirm != Y ]]; then
    echo; read -p "What's your username? " username
  fi
done
useradd -m -g users -G wheel,storage,power -s /bin/bash $username
read -s -p "New password for $username: " password; echo
read -s -p "Again, please: " password2; echo -e "\n"
while [[ $password != $password2 ]] ; do
  echo "Sorry, try again."
  read -s -p "New password for $username: " password; echo
  read -s -p "Again, please: " password2; echo -e "\n"
done
echo "$username:$password" | chpasswd
echo -e "User '$username' has been created.\n"


# Allow members of 'wheel' group to use sudo
sed -i -e "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g" /etc/sudoers


# Set the locale
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo -e "LANG=\"en_US.UTF-8\"\nLC_ALL=\"en_US.UTF-8\"" > /etc/environment


# Create a hook for every time pacman-mirrorlist upgrades
mkdir -p /etc/pacman.d/hooks/
echo -e "[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist\n
[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew...
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c \"reflector --country 'United States' --latest 200 --age 24 --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew\"" \
  > /etc/pacman.d/hooks/mirrorupgrade.hook


# Change the hostname to 'arch', configure hosts file
echo "arch" > /etc/hostname
echo "127.0.1.1	arch.localdomain	arch" >> /etc/hosts


# Set gksu to use sudo by default:
gconftool-2 --set --type boolean /apps/gksu/sudo-mode true


# Load the generic bluetooth driver, if not already loaded
modprobe btusb


# Make sure everything is up to date
pacman -Syu


# Switch from root to user
wget https://raw.githubusercontent.com/djpalumbo/dotfiles/master/.scripts/arch_setup_user.sh
chmod +x arch_setup_user.sh
su $username -c ./arch_setup_user.sh

