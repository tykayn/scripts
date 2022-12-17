#!/bin/bash
# ------------- pour créer le dépot borg:
# borg init --encryption=repokey-blake2 /media/tykayn/catwoman/stockage-syncable
# ------------- ajouter dans la crontab root 
# 	sudo crontab -e
# # lancer toutes les 4 heures le script de création borg
# 0 */4 * * * bash /home/tykayn/cloud_borg.sh
#
# -------------
# config
#
today=$(date +"%Y-%m-%d_%H-%I-%S")
LOG_FILE_BACKUP=/poule/encrypted/log_backup_rise.log

# destination
BORG_FOLDER_RISE=/poule/encrypted/tksites

# sources
TKSITES_FOLDER_RISE=/poule/subvol-103-disk-0/home/www
NGINX_FOLDER_RISE=/poule/subvol-103-disk-0/etc/nginx
LETSENCRYPT_FOLDER_RISE=/poule/subvol-103-disk-0/etc/letsencrypt
AUTOMYSQLBACKUP_FOLDER_RISE=/poule/subvol-103-disk-0/etc/automysqlbackup

export BORG_PASSCOMMAND="cat /root/.borg-passphrase"
# ====================== dossiers a sauvegarder ======================
# les bases de données sont sauvegardées avec automysqlbackup et autopostgresqlbackup
# les fichiers des sites web
# la config nginx

NGINX_FOLDER=/etc/nginx

echo ' ' >> $LOG_FILE_BACKUP
echo "### ${today} start backup script " | tee -a $LOG_FILE_BACKUP  2>&1

# ====================== creation de borg backup
echo ' ' >> $LOG_FILE_BACKUP
echo "### ${today} | RISE | start backup script cloud_borg.sh " | tee -a $LOG_FILE_BACKUP  2>&1

	borg create $BORG_FOLDER_RISE::cloud_{user}-{now}  $TKSITES_FOLDER_RISE $NGINX_FOLDER_RISE $AUTOMYSQLBACKUP_FOLDER_RISE $LETSENCRYPT_FOLDER_RISE --exclude '.bundler/gems' --exclude 'node_modules' --progress --verbose --stats  --compression zlib,9 | tee -a $LOG_FILE_BACKUP  2>&1
# ====================== nettoyage
	borg prune -v --list --stats --keep-daily=6 --keep-weekly=4 --keep-monthly=3 --keep-yearly=2 $BORG_FOLDER_RISE | tee -a $LOG_FILE_BACKUP  2>&1
	
echo "### ${date} | RISE | done cloud_borg.sh " | tee -a $LOG_FILE_BACKUP  2>&1
