#!/bin/bash
# set timezone lang local

# Choose the  mirror
# 选择镜像源
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
cat /etc/pacman.d/mirrorlist.backup | grep .cn >> /etc/pacman.d/mirrorlist

# Update mirror
# 更新镜像包
pacman -Syy

pacman --noconfirm --needed -S wget

passwd

TZuser=$(cat tzfinal.tmp)

ln -sf /usr/share/zoneinfo/$TZuser /etc/localtime

hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo "zh_CN.GB18030 GB18030" >> /etc/locale.gen
echo "zh_CN.GBK GBK" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN GB2312" >> /etc/locale.gen
locale-gen

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

pacman --noconfirm --needed -S dialog
# larbs() { curl -O https://raw.githubusercontent.com/LukeSmithxyz/LARBS/master/src/larbs.sh && bash larbs.sh ;}
# dialog --title "Install Luke's Rice" --yesno "This install script will easily let you access Luke's Auto-Rice Boostrapping Scripts (LARBS) which automatically install a full Arch Linux i3-gaps desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no.\n\nLuke"  15 60 && larbs


# add a user 
name=$(dialog --no-cancel --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1)

re="^[a-z_][a-z0-9_-]*$"
while ! [[ "${name}" =~ ${re} ]]; do
	name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - and _." 10 60 3>&1 1>&2 2>&3 3>&1)
done

pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)

while [ $pass1 != $pass2 ]
do
	pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\n\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	unset pass2
done

dialog --infobox "Adding user \"$name\"..." 4 50
useradd -m -g wheel -s /bin/bash $name >/dev/tty6
echo "$name:$pass1" | chpasswd >/dev/tty6
