#!/bin/bash
#       rsync_other_servers_from_soyoustart.sh
# --------------------- syncro des différents serveurs ---------------------
# ici on clone le dossier borg vers les autres serveurs BORG_FOLDER_SOYOUSTART
# tous les autres serveurs ont un dossier /home/tykayn/backup/serveurs-production contenant le nom de$
# 
# /home/tykayn/backup/serveurs-production/soyoustart
# /home/tykayn/backup/serveurs-production/peertube
# /home/tykayn/backup/serveurs-production/vps
# /home/tykayn/backup/serveurs-production/cloud
# 
# ------- noms des serveurs --------
#
# CLOUD         cloud.tykayn.fr
# SPARE         peertube.cipherbliss.com        
# VPS           events.cipherbliss.com          
# SOY           www.cipherbliss.com             


 echo "############"
 echo " ${date} syncro du dossier BORG backup de tk sur soyoustart vers Cloud"
 echo "############"
 
SOURCE="/home/tykayn/backup/backup_land4to/*"
DESTINATION="tykayn@peertube.cipherbliss.com:/home/tykayn/backup/backup_land4to/"
rsync -avzP --perms --delete --progress $SOURCE -e ssh $DESTINATION

 echo -e "${GREEN}############${NC}"
 echo -e "${GREEN} ${date}syncro backup vers disque vers soyoustart cipherbliss.com ${NC}"
