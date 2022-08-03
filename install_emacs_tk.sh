#!/bin/bash

echo "### installation de emacs avec la config TK"
echo "### ce script suppose que vous ayez Apt et Bash"


username="tykayn"

sudo apt install snapd
snap install emacs --channel-beta --classic
emacs --version

mkdir -p ~/Nextcloud/textes/orgmode/org-roam
mkdir -p ~/Nextcloud/textes/library

rm -rf /home/$username/.emacs.d
cp /home/$username/.emacs .emacs_backup

wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/.emacs --directory-prefix="/home/$username/"
#wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/config.org --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
#wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/tasks.org --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/bulma.min.css --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/style.css --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/upcalendar.sh --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"






echo "### voilà, ça c'est fait"
