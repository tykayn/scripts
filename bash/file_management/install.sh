#!/bin/bash

echo "installation des outils de file management pour geequie"


if ! hash "exiftool" > /dev/null; then
	echo "installer les paquets apt: apt install exiftool xfce4-terminal geeqie "
	apt install exiftool xfce4-terminal geeqie gnome-terminal

fi

if ! hash "guessfilename" > /dev/null; then
	echo "installer les paquets python :  guessfilename filetags date2name appendfilename"
	pip install guessfilename filetags date2name appendfilename

fi


# créer le dossier de scripts
if [ ! -d $HOME/areas/www/misc ]; then
	echo "installer les dossiers PARA dans la home"
	mkdir -p $HOME/areas/www/misc
	mkdir -p $HOME/projects
	mkdir -p $HOME/archives
	mkdir -p $HOME/ressources
fi


if [ ! -d $HOME/areas/www/misc/novoid/filetags ]; then
    git clone https://github.com/novoid/filetags.git $HOME/areas/www/misc/novoid
fi



mkdir -p $HOME/.config/geeqie/applications

# copier les wrappers
echo "copier les wrappers dans $HOME/areas/www/misc"
cp vk-filetags*.sh $HOME/areas/www/misc

cp guess_filename.sh $HOME/areas/www/misc
cp vkorgheadingstats.sh $HOME/areas/www/misc
# rendre éxécutable les scripts
chmod u+x /home/cipherbliss/areas/www/misc/*.sh

# copier les scripts qui seront utilisés par geeqie
echo "copier  les scripts qui seront utilisés par geeqie dans $HOME/.config/geeqie/applications/"
cp *.desktop $HOME/.config/geeqie/applications/

echo "ça c'est fait. plus qu'a configurer les raccourcis de ces scripts dans la partie plugins de Geeqie"
