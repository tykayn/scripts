#/bin/bash
# @author sync_spaceship by @tykayn - contact at cipherbliss.com
#
# disques ext
# - blue 4To
# - brossadent 4To
# - catwoman 4To
# - chaton 5To
# - kouignamann 4To
# - lilia 4To
# - louisbraille 4To
# - monolith 6.2To
# - rondoudou 4To non chiffré
# - Taiga 1To

# configs
export today=`date` # to log current time
export ARCHIVE_CLEAR="/home/poule/encrypted/stockage-syncable" # place where we have our things sorted, other than home
export BORG_PASSCOMMAND="cat $ARCHIVE_CLEAR/.tk-borg-passphrase" # get the borg repo pass
export LOG_FILE_BACKUP="$ARCHIVE_CLEAR/www/backup/log_backup.log"
export LOG_FILE_BACKUP_DATES="$ARCHIVE_CLEAR/www/backup/summary_log_backup.log" # log dates of execution of the script

echo "watch the logs with \n tail -f $LOG_FILE_BACKUP_DATES"

# big disks can replicate the whole ZFS encrypted archives
big_disks=("blue","brossadent","catwoman","chaton","kouignamann","monolith","lilia","louisbraille","monolith")

# clear disk will take medias
clear_disks=("rondoudou")

# small disks will only take borg backups
small_disks=("Taiga")

# déclaration d'une fonction
function syncToBigDiskName() 
{ 
	local diskName=$1
	echo ' ' >> $LOG_FILE_BACKUP_DATES
	echo "### ${today} replicate to disk ${diskName}" >> $LOG_FILE_BACKUP_DATES

	# chech that the mounted folder of the disk exists
	FILE=/media/$USER/$diskName

	if test -d "$FILE"; then
		echo "### $FILE exists."  >> $LOG_FILE_BACKUP_DATES
		
		# ok to send Rsync of encrypted folder
		rsync -avP /home/poule/encrypted/* /media/$USER/$diskName/encrypted --delete --exclude '.npm' --exclude '.yarn' --exclude 'node_modules' --exclude '.mozilla' --delete --exclude '.cache' --exclude 'Cache'
rsync -avP /home/poule/borg_archives/* /media/$USER/$diskName/borg_archives --delete --exclude '.npm' --exclude '.yarn' --exclude 'node_modules' --exclude '.mozilla' --delete --exclude '.cache' --exclude 'Cache'

	else
		echo "### /!\ - folder not found $FILE"
	fi
}


syncToBigDiskName "monolith" 

