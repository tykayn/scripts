#!/bin/bash

##################
#
# pour lancer l'installation de la config de démo:
# wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/install_emacs_tk.sh | bash
# 
##################

echo "### installation de emacs avec la config TK"
echo "### ce script suppose que vous ayez Apt et Bash"


username=$USER
orgmode_folder_demo="/home/$username/Nextcloud/textes/orgmode/demo"

# installation des dépendances
echo " installation des dépendances"

sudo apt install snapd git arp-scan wget kompare
snap install emacs --channel-beta --classic
emacs --version

# faire des sauvegardes si ces documents existent déjà
if test -f /home/$username/.emacs; then
    echo "config .emacs existante, on fait une copie de sauvegarde."
    mv /home/$username/.emacs /home/$username/.emacs_backup
fi

if test -d $orgmode_folder_demo; then
fi

if test -f $orgmode_folder_demo/tasks.org; then
    echo "Fichier de tâches Orgmode existant, on fait une copie de sauvegarde."
    mv $orgmode_folder_demo/tasks.org /home/$username/tasks.org.backup
fi



# créer les dossiers nextcloud dont on a besoin
mkdir -p $orgmode_folder_demo/org-roam
mkdir -p $orgmode_folder_demo/library

rm -rf /home/$username/.emacs.d
cp /home/$username/.emacs .emacs_backup

# prendre les documents d'exemple'
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/.emacs --directory-prefix="/home/$username/"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/config.org --directory-prefix="$orgmode_folder_demo"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/tasks.org --directory-prefix=="$orgmode_folder_demo"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/bulma.min.css --directory-prefix=="$orgmode_folder_demo"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/style.css --directory-prefix=="$orgmode_folder_demo"
wget https://forge.chapril.org/tykayn/scripts/raw/branch/master/assets/org/upcalendar.sh --directory-prefix=="$orgmode_folder_demo"


cd $orgmode_folder_demo
git init
git add .
git status


cd cd /home/$username/Nextcloud/textes/orgmode
pwd
echo "### voilà, ça c'est fait. Dépot initialisé avec des fichiers d'exemple'"
echo "### "
echo "### pour lancer l'exemple:"
echo "### emacs -Q l $orgmode_folder_demo/.emacs_demo"
echo "### "
echo "### pour transformer l'exemple en fichier par défaut:"
echo "### mv $orgmode_folder_demo/.emacs_demo /home/$username/.emacs"
