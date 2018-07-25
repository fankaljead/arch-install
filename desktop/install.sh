#!/bin/bash
# This should be run after open i3

su zxh
cd

mkdir mytemp
cd mytemp
git clone https://github.com/fankaljead/myrice.git

mv ~/.config/i3/config ~/.config/i3/config.backup
cp myrice/.i3/config ~/.config/i3/config


cp -r myrice/.config/shadowsocks ~/.config

mv /etc/profile /etc/profile.backup
mv /etc/privoxy/config /etc/privoxy/config.backup

cp myrice/.config/profile /etc/profile
cp myrice/.config/privoxy/config /etc/privoxy/config
cp myrice/.Xdefaults ~/.Xresources

reboot now
