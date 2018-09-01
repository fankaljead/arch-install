#!/bin/bash

echo "----------------------------------------------------"
echo "----------------add the Chinese aur-----------------"
echo "----------------------------------------------------"
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
pacman -Syy

echo "----------------------------------------------------"
echo "--------installing some basic softwares-------------"
echo "----------------------------------------------------"
# 必备软件
pacman -S --noconfirm vim git ranger neofetch rofi shadowsocks privoxy jdk nodejs go python-pip linux-header zsh cmake highlight

pip install neovim

pacman -S --noconfirm neovim

# Google浏览器
yaourt -S --noconfirm google-chrome netease-cloud-music 
# 字体
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-inconsolata ttf-linux-libertine

pacman -S --noconfirm xorg-xinit xorg-server i3-gaps i3status i3lock-fancy rxvt-unicode terminator arandr lightdm lightdm-gtk-greeter pcmanfm feh nitrogen compton dmenu yaourt mpd mpv ncmpcpp

# 配置桌面环境的基本设置
wget https://raw.githubusercontent.com/fankaljead/arch-install/master/desktop/install.sh

bash install.sh

