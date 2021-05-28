#!/bin/bash
#
# pour créer le dépot borg:
# 	borg init --encryption=repokey-blake2 /media/tykayn/catwoman/backup_land4to
#
# pour changer le mot de passe
# https://borgbackup.readthedocs.io/en/stable/usage/key.html
#
# 	borg key change-passphrase -v /media/tykayn/catwoman/backup_land4to
# et modifier le fichier .borg-passphrase
#
# sys borg root pass
# ➜  exporter en sauvegarde papier la clé du dépot
# 	borg key export --paper ./backups
# To restore key use:
#	borg key import --paper /path/to/repo
#
# ---------------------- creation de borg backup sur le spaceship dans le dépot borg local pour aller plus vite et ensuite syncro avec disque externe.

export BORG_PASSCOMMAND="cat /media/tykayn/catwoman/stockage-syncable/.borg-passphrase" # ce fichier doit être lisible uniquement par l'utilsateur gérant ces archives, et ce dossier doit être sur un disque dur chiffré
export ARCHIVE_CLEAR="/media/tykayn/catwoman/stockage-syncable" # place where we have our things sorted, other than home
export LOG_FILE_BACKUP_DATES="$ARCHIVE_CLEAR/www/backup/summary_log_backup.log" # log dates of execution of the script

export today=`date`+"%Y-%m-%d_%H-%I-%S"
export SPACESHIP_BORG_REPO=/media/tykayn/catwoman/backup_land4to
export LOG_FILE_BACKUP="$ARCHIVE_CLEAR/www/backup/log_backup.log"

echo ' ' >> $LOG_FILE_BACKUP
echo "### ${today} | SPACESHIP | start backup script borg_spaceship.sh " >> $LOG_FILE_BACKUP

	borg create $SPACESHIP_BORG_REPO::tk-spaceship_stockage-syncable_{user}-{now} $ARCHIVE_CLEAR /home/tykayn /var/www/html --exclude node_modules  --progress --verbose --stats  --compression zlib,9 | tee -a $LOG_FILE_BACKUP  2>&1
	# nettoyage
	borg prune -v --list --stats --keep-daily=8 --keep-weekly=6 --keep-monthly=3 --keep-yearly=2 $SPACESHIP_BORG_REPO | tee -a $LOG_FILE_BACKUP  2>&1

echo "### ${date} | SPACESHIP | done borg_spaceship.sh " >> $LOG_FILE_BACKUP
borg list $SPACESHIP_BORG_REPO | tee -a $LOG_FILE_BACKUP_DATES  2>&1
date -ud "@$SECONDS" "+Time elapsed: %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1