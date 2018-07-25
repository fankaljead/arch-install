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

echo "Set the root password:"
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


curl https://raw.githubusercontent.com/fankaljead/arch-install/master/software/software.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

# add a user 
echo "adding a default user"
useradd -m -g wheel -s /bin/bash zxh 
echo "zxh ALL=(ALL) ALL" >> /etc/sudoers
passwd zxh
212kawhi
212kawhi
echo "add user succeeded"
