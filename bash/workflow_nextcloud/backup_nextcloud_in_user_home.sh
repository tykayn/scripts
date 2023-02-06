#/bin/bash
# 
# ----------------- documentation ----------------- 
# tâche à effectuer régulièrement sur les ordis portables
# 
# @author functions_sync by @tykayn - contact at cipherbliss.com

# copier le dossier nextcloud dans la home
mkdir ~/.backup_automatique
cd ~/.backup_automatique

git init 

rsync ~/Nextcloud/textes/orgmode ~/.backup_automatique --inplace --perms -avP --delete-before



git add .
git commit -m "auto commit de workflow nextcloud - backup nextcloud in user home"
