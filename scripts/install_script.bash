#!/bin/bash
# Scrypt for automating arch install process as described in (https://wiki.archlinux.org/title/installation_guide)
#set -xeuo pipefail

#check if we're root
if [[ "$UID" -ne 0 ]]; then
    echo "This script needs to be run as root!" >&2
    exit 3
fi

### Config options
target="/dev/sda"
efisize="1G"
swapsize="16G"
rootmnt="/mnt"
locale="en_US.UTF-8"
locale2="es_ES.UTF-8"
keymap="es"
timezone="Europe/Madrid"
hostname="pcOmen"

### Packages to pacstrap ##
pacstrappacs=(
    base
    linux
    linux-firmware
    base-devel
    intel-ucode
    vim
    nano
    cryptsetup
    btrfs-progs
    dosfstools
    util-linux
    git
    unzip
    sbctl
    kitty
    networkmanager
    sudo
    wpa_supplicant
    grub
    grub-btrfs
    efibootmgr
    e2fsprogs
    )


# Set Timezone
echo "Setting Timezone..."
timedatectl set-timezone "$timezone"

# Creating Partitions
echo "Creating partitions..."
sgdisk -Z "$target"
sgdisk -n 0:0:+"$efisize" -t 0:ef00 -c 0:"EFI" "$target"
sgdisk -n 0:0:+"$swapsize" -t 0:8200 -c 0:"linuxswap" "$target"
sgdisk -n 0:0:0 -t 0:8300 -c 0:"linuxroot" "$target"
sgdisk -p "$target"
partprobe -s "$target"
fdisk -l "$target"
sleep 3

# # Encrypting root partition
# echo "Encrypting root partition..."
# cryptsetup luksFormat --type luks2 "$target"3
# cryptsetup luksOpen "$target"3 linuxroot

# Formating partitions
echo "Formating partitions..."
mkfs.fat -F 32 -n EFI "$target"1
mkswap "$target"2
mkfs.btrfs -f -L linuxroot "$target"3
# mkfs.btrfs -f -L linuxroot /dev/mapper/linuxroot # (if encryp)

# Mounting partitions
echo "Mounting partitions..."
mount "$target"3 "$rootmnt"
# mount /dev/mapper/linuxroot "$rootmnt" # (if encryp)
mount --mkdir "$target"1 "$rootmnt"/boot
btrfs subvolume create "$rootmnt"/home
btrfs subvolume create "$rootmnt"/srv
btrfs subvolume create "$rootmnt"/var
btrfs subvolume create "$rootmnt"/var/log
btrfs subvolume create "$rootmnt"/var/cache
btrfs subvolume create "$rootmnt"/var/tmp
swapon "$target"2
lsblk "$target"
sleep 3

# Install essential packages
echo "Installing essential packages..."
reflector --country Spain,France,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap -K $rootmnt "${pacstrappacs[@]}" 



# Configure the system
echo "Configuring the system..."
genfstab -U "$rootmnt" >> "$rootmnt"/etc/fstab
echo "-----------------------------------------------------------------------------"
echo "- First part of Install complete. Execute second, install_script2.bash .... -"
echo "-----------------------------------------------------------------------------"
arch-chroot "$rootmnt"
