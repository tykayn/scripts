#!/bin/bash

echo "### installation de emacs avec la config TK"
echo "### ce script suppose que vous ayez Apt et Bash"

sudo apt install snapd
snap install emacs --channel-beta --classic
emacs --version

mkdir -p ~/Nextcloud/textes/orgmode/org-roam
mkdir -p ~/Nextcloud/textes/library

rm -rf ~/.emacs.d

wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/config.org ~/Nextcloud/textes/orgmode/
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/tasks.org ~/Nextcloud/textes/orgmode/
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/.emacs ~/

echo "export PATH=$PATH:/snap/bin/emacs" >> .bash_aliases


cp ~/.emacs .emacs_backup


echo "### voilà, ça c'est fait"
