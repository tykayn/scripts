#/bin/bash 
# @author sync_spaceship by @tykayn - contact at cipherbliss.com
#
# On peut lancer ce script après avoir créé le dépot borg dans ARCHIVE_CLEAR
#   borg init --encryption=repokey-blake2 /media/tykayn/catwoman/backup_land4to
#
# à installer en cronjob avec:
#   crontab -e
#
# m h  dom mon dow   command
# */30 * * * *    bash /media/tykayn/catwoman/stockage-syncable/sync_spaceship.sh

# configs
export today=$(get_date()) # to log current time 
export ARCHIVE_CLEAR="/media/tykayn/catwoman/stockage-syncable" # place where we have our things sorted, other than home
export BORG_PASSCOMMAND="cat /media/tykayn/catwoman/stockage-syncable/.borg-passphrase" # get the borg repo pass
export LOG_FILE_BACKUP="$ARCHIVE_CLEAR/www/backup/log_backup.log"
export LOG_FILE_BACKUP_DATES="$ARCHIVE_CLEAR/www/backup/summary_log_backup.log" # log dates of execution of the script

echo ' ' >> $LOG_FILE_BACKUP
echo "### ${today} start backup script from sync_spaceship script" >> $LOG_FILE_BACKUP
echo "### ${today} ${pwd} sync_spaceship.sh" >> $LOG_FILE_BACKUP

echo ' ' >> $LOG_FILE_BACKUP_DATES
echo "### ${today} start backup script from sync_spaceship script" >> $LOG_FILE_BACKUP_DATES

# clean borg current task
killall borg
rm -rf /media/tykayn/catwoman/backup_land4to/lock.exclusive
rm -rf /home/tykayn/.cache/borg/83e2bcd4c1832b93b0926232b9bb5e942ca469b6c4c90cff66f327e879f04027/lock.exclusive

echo "### ${today} clean of borg task ok " | tee -a $LOG_FILE_BACKUP_DATES  2>&1
date -ud "@$SECONDS" "+Time elapsed: %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
# retrieve web servers data to the ARCHIVE_CLEAR
# bash webservers_sync.sh


# back pictures to ARCHIVE_CLEAR
mv /home/tykayn/Nextcloud/InstantUpload/Camera/* "$ARCHIVE_CLEAR/photos/2021" | tee -a $LOG_FILE_BACKUP  2>&1
mv /home/tykayn/Nextcloud/InstantUpload/Screenshots/* "$ARCHIVE_CLEAR/photos/screenshots" | tee -a $LOG_FILE_BACKUP  2>&1
mv /home/tykayn/Nextcloud/InstantUpload/Download/* "$ARCHIVE_CLEAR/BAZAR" | tee -a $LOG_FILE_BACKUP  2>&1
# update local nextcloud to stockage syncable
rsync -avzP --perms --delete-after --progress /home/tykayn/Nextcloud/* $ARCHIVE_CLEAR/clouds/Nextcloud | tee -a $LOG_FILE_BACKUP  2>&1


echo "### ${today} copy of nextcloud content ok " | tee -a $LOG_FILE_BACKUP_DATES  2>&1
date -ud "@$SECONDS" "+Time elapsed: %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1

bash $ARCHIVE_CLEAR/__scripts_syncro/borg_spaceship.sh
bash $ARCHIVE_CLEAR/__scripts_syncro/disk_ext_sync.sh

bash sync_to_nas.sh

echo "### ${today} end" >> $LOG_FILE_BACKUP_DATES
date -ud "@$SECONDS" "+Time elapsed: %H:%M:%S" | tee -a $LOG_FILE_BACKUP  2>&1
echo "voir les logs: gedit $LOG_FILE_BACKUP"
echo "voir les logs: gedit $LOG_FILE_BACKUP_DATES"
echo " " | tee -a $LOG_FILE_BACKUP  2>&1
echo "taille du BAZAR: " | tee -a $LOG_FILE_BACKUP  2>&1
du -sch $ARCHIVE_CLEAR/BAZAR | tee -a $LOG_FILE_BACKUP  2>&1