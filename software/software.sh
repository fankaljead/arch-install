#!/bin/bash

echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
pacman -Syy

# 必备软件
pacman -S --noconfirm vim git ranger neofetch rofi shadowsocks privoxy jdk nodejs go python-pip

pip install neovim

pacman -S --noconfirm neovim

# Google浏览器
yaourt -S --noconfirm google-chrome netease-cloud-music 
# 字体
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-inconsolata ttf-linux-libertine

pacman -S --noconfirm xorg-xinit xorg-server i3-gaps i3status rxvt-unicode terminator arandr lightdm lightdm-gtk-greeter pcmanfm feh nitrogen compton dmenu yaourt 

