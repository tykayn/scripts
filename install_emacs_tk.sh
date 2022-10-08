#!/bin/bash

echo "### installation de emacs avec la config TK"
echo "### ce script suppose que vous ayez Apt et Bash"


username=$USER

# installation des dépendances
sudo apt install snapd
snap install emacs --channel-beta --classic
emacs --version

# faire des sauvegardes si ces documents existent déjà
if test -f /home/$username/.emacs; then
    echo "config .emacs existante, on fait une copie de sauvegarde."
    mv /home/$username/.emacs /home/$username/.emacs_backup
fi

if test -f /home/$username/Nextcloud/textes/orgmode/tasks.org; then
    echo "Fichier de tâches Orgmode existant, on fait une copie de sauvegarde."
    mv /home/$username/Nextcloud/textes/orgmode/tasks.org /home/$username/tasks.org.backup
fi



# créer les dossiers nextcloud dont on a besoin
mkdir -p ~/Nextcloud/textes/orgmode/org-roam
mkdir -p ~/Nextcloud/textes/library

rm -rf /home/$username/.emacs.d
cp /home/$username/.emacs .emacs_backup

# prendre les documents d'exemple'
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/.emacs --directory-prefix="/home/$username/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/config.org --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/tasks.org --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/bulma.min.css --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/style.css --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/upcalendar.sh --directory-prefix="/home/$username/Nextcloud/textes/orgmode/"


cd /home/$username/Nextcloud/textes
git init
git add .
git status


cd cd /home/$username/Nextcloud/textes/orgmode
pwd
echo "### voilà, ça c'est fait. Dépot initialisé avec des fichiers d'exemple'"
