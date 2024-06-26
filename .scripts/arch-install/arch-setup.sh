#!/bin/bash


# Use systemd-boot, since it's EFI
bootctl install
# Configure bootloader defaults
echo -e "default arch.conf\nconsole-mode max\neditor 0" > /boot/loader/loader.conf


# Copy default arch entry to boot loader entries
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/
# Provide UUID of the new root partition and update to the correct kernel params
rootpart="/dev/$(lsblk | grep "/$" | cut -d " " -f 1 | sed "s/.*s/s/g")"
rootuuid=$(blkid $rootpart -o export | grep "^UUID" | cut -d "=" -f 2)
sed -i "s/options root=.*/options root=UUID=$rootuuid rw acpi_backlight=video/g" /boot/loader/entries/arch.conf
# Ensure that intel microcode is used
sed -i "/vmlinuz-linux/a initrd  \/intel-ucode.img" /boot/loader/entries/arch.conf


# Enable hibernation
swappart="/dev/$(lsblk | grep "SWAP" | cut -d " " -f 1 | sed "s/.*s/s/g")"
swapuuid=$(blkid $swappart -o export | grep "^UUID" | cut -d "=" -f 2)
echo "options resume=UUID=$swapuuid" >> /boot/loader/entries/arch.conf
# Configure the initramfs
sed -i "s/^HOOKS.*/HOOKS=(base udev resume autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/g" /etc/mkinitcpio.conf
# Rebuild the initramfs
# Add `-k $(ls /usr/lib/modules | grep arch)` if it fails to find the kernel version
mkinitcpio -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img


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
useradd -m -g users -G wheel,storage,power -s /bin/zsh $username
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
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g" /etc/sudoers


# Set the locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
#echo -e "LANG=\"en_US.UTF-8\"\nLC_ALL=\"en_US.UTF-8\"" > /etc/environment


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


# Change the hostname; configure hosts file
hostname=arch
echo "$hostname" > /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	$hostname.localdomain	$hostname" >> /etc/hosts


# Enable color option for pacman
sed -i "s/#Color/Color/g" /etc/pacman.conf


# Set touchpad options (frequently used options @ "Touchpad Synaptics" Arch wiki)
echo -e "Section \"InputClass\"
    Identifier \"touchpad\"
    Driver \"synaptics\"
    MatchIsTouchpad \"on\"
        Option \"TapButton1\" \"1\"
        Option \"TapButton2\" \"3\"
        Option \"TapButton3\" \"2\"
        Option \"VertEdgeScroll\" \"on\"
        Option \"VertTwoFingerScroll\" \"on\"
        Option \"HorizEdgeScroll\" \"on\"
        Option \"HorizTwoFingerScroll\" \"on\"
        Option \"CircularScrolling\" \"on\"
        Option \"CircScrollTrigger\" \"2\"
        Option \"EmulateTwoFingerMinZ\" \"40\"
        Option \"EmulateTwoFingerMinW\" \"8\"
        Option \"CoastingSpeed\" \"20\"
        Option \"FingerLow\" \"30\"
        Option \"FingerHigh\" \"50\"
        Option \"MaxTapTime\" \"125\"
        Option \"VertScrollDelta\" \"-111\"
        Option \"HorizScrollDelta\" \"-111\"
EndSection" \
  > /etc/X11/xorg.conf.d/70-synaptics.conf


# Force constant device pixel ratio across all screens for Alacritty
echo "WINIT_X11_SCALE_FACTOR=1.0" >> /etc/environment


# Make sure everything is up to date
pacman -Syu


# Limit the amount of logs retained by systemd/journalctl to 64M
sed -i "s/#SystemMaxUse=/SystemMaxUse=64M/g" /etc/systemd/journald.conf


# Load the generic bluetooth driver, if not already loaded
modprobe btusb


# Enable built-in network configuration & resolve DNS with systemd-resolved
echo -e "[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd" \
  > /etc/iwd/main.conf
ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf


# Start certain daemons on boot
systemctl enable systemd-resolved.service
systemctl enable iwd.service
systemctl enable tlp.service
systemctl enable bluetooth.service
systemctl enable sddm.service
#systemctl enable insync@$username.service
systemctl enable cups


# Mask certain systemd services so that TLP power management works correctly
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket


# Configure SDDM with defaults and theme (installed later via AUR)
cp -r /usr/lib/sddm/sddm.conf.d /etc/
sed -i "s/Current=/Current=aerial/g" /etc/sddm.conf.d/sddm.conf


# Switch from root to user
wget https://raw.githubusercontent.com/djpalumbo/dotfiles/master/.scripts/arch-install/arch-user-setup.sh
chmod +x arch-user-setup.sh
su $username -c ./arch-user-setup.sh

