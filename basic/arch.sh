#!/bin/bash
#
 # ______                __  ___                   _           _ _
# |__  / |__   ___  _   _\ \/ (_) __ _ _ __   __ _| |__  _   _(_| )___
  # / /| '_ \ / _ \| | | |\  /| |/ _` | '_ \ / _` | '_ \| | | | |// __|
 # / /_| | | | (_) | |_| |/  \| | (_| | | | | (_| | | | | |_| | | \__ \
# /____|_| |_|\___/ \__,_/_/\_\_|\__,_|_| |_|\__, |_| |_|\__,_|_| |___/
                                           # |___/
    # _             _       _     _
   # / \   _ __ ___| |__   | |   (_)_ __  _   ___  __
  # / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /
 # / ___ \| | | (__| | | | | |___| | | | | |_| |>  <
# /_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\
#
 # ___           _        _ _   ____            _       _
# |_ _|_ __  ___| |_ __ _| | | / ___|  ___ _ __(_)_ __ | |_
 # | || '_ \/ __| __/ _` | | | \___ \ / __| '__| | '_ \| __|
 # | || | | \__ \ || (_| | | |  ___) | (__| |  | | |_) | |_
# |___|_| |_|___/\__\__,_|_|_| |____/ \___|_|  |_| .__/ \__|
                                               # |_|
#

# Choose the  mirror
# 选择镜像源
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
cat /etc/pacman.d/mirrorlist.backup | grep .cn >> /etc/pacman.d/mirrorlist

# Update mirror
# 更新镜像包
pacman -Syy


pacman -S --noconfirm dialog || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?"; exit; }
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/sda drive.\n\nThis script is only really for me so I can autoinstall Arch.\n\nt. ZhouXianghui"  15 60 || exit

dialog --defaultno --title "DON'T BE A BRAINLET!" --yesno "Do you think I'm meming? Only select yes to DELET your entire /dev/sda and reinstall Arch.\n\nTo stop this script, press no."  10 60 || exit 

dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

dialog --defaultno --title "Time Zone select" --yesno "Do you want use the default time zone(Asia/Chongqing)?.\n\nPress no for select your own time zone"  10 60 && echo "Asia/Chongqing" > tz.tmp || tzselect > tz.tmp

dialog --no-cancel --inputbox "Enter partitionsize in gb, separated by space (swap & root)." 10 60 2>psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(12 25);
fi

timedatectl set-ntp true

cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+${SIZE[0]}G
n
p


+${SIZE[1]}G
n
p


w
EOF
partprobe

mkfs.ext4 /dev/sda4
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/sda4 /mnt/home


pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab
cat tz.tmp > /mnt/tzfinal.tmp
rm tz.tmp
# curl https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/src/chroot.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

cat comp > /mnt/etc/hostname && rm comp

dialog --defaultno --title "Final Qs" --yesno "Eject CD/ROM (if any)?"  5 30 && eject
dialog --defaultno --title "Final Qs" --yesno "Reboot computer?"  5 30 && reboot
dialog --defaultno --title "Final Qs" --yesno "Return to chroot environment?"  6 30 && arch-chroot /mnt
clear
