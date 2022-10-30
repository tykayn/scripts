#!/bin/bash

touch 	~/Nextcloud/textes/orgmode/incoming_inbox.org

# comparer le fichier de todo de nextcloud et le fichier modèle de base_inbox.org
# si une différence est notée, migrer les notes
if ! cmp ~/Nextcloud/Notes/todo.txt ~/Nextcloud/textes/orgmode/base_inbox.org >/dev/null 2>&1
then
		echo "les deux fichiers sont différents"

		echo "lignes à copier des notes de nextcloud: "

		cat ~/Nextcloud/Notes/todo.txt
		echo " "
		cat ~/Nextcloud/Notes/todo.txt | wc -l
		echo "lignes"
		echo " "

		sed -i 's/\*\ /\*\*\ /g' ~/Nextcloud/Notes/todo.txt
		cat ~/Nextcloud/Notes/todo.txt >> ~/Nextcloud/textes/orgmode/incoming_inbox.org
		echo "copiées dans ~/Nextcloud/textes/orgmode/incoming_inbox.org"
		echo " "
		echo " lignes dans l'incoming_inbox.org"
		cat ~/Nextcloud/textes/orgmode/base_inbox.org > ~/Nextcloud/Notes/todo.txt
		echo "copied ~/Nextcloud/Notes/todo.txt to incoming_inbox.org"
else
		echo "Rien à rajouter dans le fichier incoming inbox"
fi
