#!/bin/bash
echo "mise à jour du fichier de tâches orgmode du workflow nextcloud";
cp /home/cipherbliss/Nextcloud/textes/orgmode/tasks.org .
node index.js > output.txt