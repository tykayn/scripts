#!/bin/bash
# version 2.0.1
# Script crée par Tykayn

# Copyleft 2018 Tykayn
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

#code mise en forme
neutre='\e[0;m'
conseil='\e[1;32m' #vert
clear

# sudo!
if [ "$UID" -ne "0" ]
then
 echo -e "Il faut etre root pour executer ce script. ==> ${conseil} sudo ./tykayn_postinstall.sh ${neutre}"
 exit
fi




# script appelé par le script post-install dans le cas du choix profil automatique (tykayn 16)
### Developement tools

echo -e "${conseil}Ce script va installer de quoi faire marcher des sites web localement, des logiciels de bureautique et de graphisme. enjoy! ${neutre}"
        echo "*******************************************************"
# config de clavier
# TODO: FIX 
# echo "keybaord config"
# mv /etc/default/keyboard /etc/default/keyboard_backup
# wget https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/postinstall/keyboard --directory-prefix=/etc/default
echo "dolphin config"
mv /etc/default/keyboard /etc/default/keyboard_backup
wget https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/postinstall/user_config/dolphinrc --directory-prefix=/home/$USER/.config/

echo "add aliases to user profile"
# https://frama.link/tk_setup is equivalent to
# https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/postinstall/tykayn_postinstall.sh
# wget https://frama.link/tk_setup --directory-prefix=/home/$USER
wget https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/aliases.sh --directory-prefix=/home/$USER
mv /home/$USER/aliases.sh /home/$USER/.bash_aliases


echo "update and upgrade packages"
apt update && apt upgrade
### main programs
apt install git nano zsh nodejs npm docker docker-compose virtualbox pidgin openvpn
npm i -g yarn @angular/cli

### install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# LAMP server
# https://doc.ubuntu-fr.org/lamp#installation
apt install libapache2-mod-php mysql-server php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip
# PHP related
# php extensions

#apache server
a2enmod rewrite

echo "installing composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

### Internet/Web
apt install firefox chromium-browser -y
#telegram
add-apt-repository ppa:atareao/telegram
apt update
apt install telegram -y

### Multimédia
apt install gnome-mpv vlc blender kdenlive -y

### Graphisme
apt install mypaint krita krita-l10n -y
apt purge gimp -y ; add-apt-repository -y ppa:otto-kesselgulasch/gimp ; apt update ; apt upgrade -y ; apt install gimp -y #gimp dernière version

### Outils
#Support système de fichier BTRFS
#Support système de fichier ExFat
#Support d'autres systèmes de fichier (f2fs, jfs, nilfs, reiserfs, udf, xfs, zfs)
apt install baobab grsync screen subdownloader handbrake audacity easytag screenfetch ncdu btrfs-tools exfat-utils exfat-fuse f2fs-tools jfsutils nilfs-tools reiser4progs reiserfsprogs udftools xfsprogs xfsdump zfsutils-linux zfs-initramfs -y
######## config clavier



#Gnome Shell : augmenter durée capture vidéo de 30s à 10min
su $SUDO_USER -c "gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600"

#Optimisation grub : dernier OS booté comme choix par défaut
 sed -ri 's/GRUB_DEFAULT=0/GRUB_DEFAULT="saved"/g' /etc/default/grub ; echo 'GRUB_SAVEDEFAULT="true"' >> /etc/default/grub
 updade-grub
 #Grub réduction temps d'attente + suppression test ram dans grub
 sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/g' /etc/default/grub ; mkdir /boot/old ; mv /boot/memtest86* /boot/old/
 #Swapiness 95% +cache pressure 50
 echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf ; sysctl -p /etc/sysctl.d/99-swappiness.conf### Bureautique
apt install libreoffice-style-breeze libreoffice-style-elementary libreoffice-style-human libreoffice-style-sifr libreoffice-style-tango libreoffice-templates hunspell-fr mythes-fr hyphen-fr openclipart-libreoffice-y
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y
 #TLP pour économie d'énergie pour les pc portable.
            wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/EconomieEnergie_TLP_Bionic.sh ; chmod +x EconomieEnergie_TLP_Bionic.sh
            ./EconomieEnergie_TLP_Bionic.sh ; rm EconomieEnergie_TLP_Bionic.sh
 #police d'écriture MS
 #plugin correction grammalecte
wget https://www.dicollecte.org/grammalecte/oxt/Grammalecte-fr-v0.6.2.oxt && chown $SUDO_USER Grammalecte* && chmod +x Grammalecte* ; unopkg add --shared Grammalecte*.oxt && rm Grammalecte*.oxt ; chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/libreoffice #grammalecte

apt install steam -y
#snaps
snap install nextcloud-client

#config mysql
mysql_secure_installation

#config git
git config --global credential.helper store

# Nettoyage fichiers/dossiers inutiles qui étaient utilisés par le script
rm *.zip ; rm *.tar.gz ; rm *.tar.xz ; rm *.deb ; cd .. && rm -rf /home/$SUDO_USER/script_postinstall
clear

# Maj/Nettoyage
apt update ; apt autoremove --purge -y ; apt clean ; cd .. ; clear

echo -e "${conseil} TADAM! ça c'est fait ${neutre}"
        echo "*******************************************************"

echo "Script fait par Tykayn - https://www.cipherbliss.com"
echo "Pour prendre en compte tous les changements, il faut maintenant redémarrer !"
read -p "Voulez-vous redémarrer immédiatement ? [o/N] " rep_reboot
if [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "O" ]
then
    reboot
fi
