#!/bin/bash

echo "### installation de emacs avec la config TK"
echo "### ce script suppose que vous ayez Apt et Bash"


username="tykayn"

sudo apt install snapd
snap install emacs --channel-beta --classic
emacs --version

mkdir -p ~/Nextcloud/textes/orgmode/org-roam
mkdir -p ~/Nextcloud/textes/library

rm -rf ~/.emacs.d

cp ~/.emacs .emacs_backup

wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/.emacs "/home/$username/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/config.org "/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/tasks.org "/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/bulma.min.css "/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/style.css "/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/upcalendar.sh "/home/$username/Nextcloud/textes/orgmode/"

# 

# run emacs


echo "### voilà, ça c'est fait"

snap run emacs