#!/bin/bash
# Scrypt for automating arch install process as described in (https://wiki.archlinux.org/title/installation_guide)
#set -xeuo pipefail

#check if we're root
if [[ "$UID" -ne 0 ]]; then
    echo "This script needs to be run as root!" >&2
    exit 3
fi

### Config options
rootmnt="/mnt"
locale="en_US.UTF-8"
locale2="es_ES.UTF-8"
keymap="es"
timezone="Europe/Madrid"
hostname="pcOmen"


# Continue configuring the system
echo "Continue configuring the system..."
genfstab -U "$rootmnt" >> "$rootmnt"/etc/fstab
arch-chroot "$rootmnt"
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
hwclock --systohc
sed -i -e "/^#"$locale"/s/^#//" /etc/locale.gen
sed -i -e "/^#"$locale2"/s/^#//" /etc/locale.gen
echo "LANG="$locale"" >> /etc/locale.conf
echo "KEYMAP="$keymap"" >> /etc/vconsole.conf
echo "$hostname" > /etc/hostname

echo "---- Enter root password ----"
passwd

# Bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


echo "-----------------------------------"
echo "- Install complete. Rebooting.... -"
echo "-----------------------------------"
# sleep 5
# sync
# reboot
