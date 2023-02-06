#/bin/bash
# ----------------- documentation ----------------- 
#
# @author sync_spaceship by @tykayn - contact at cipherbliss.com
#
# L'archive Borg contient stockage syncable et vise à être mise dans le NAS pour la postérité
# 	BORG_NEW_PASSPHRASE=mon_pass_bien_compliqué borg init -e=repokey /home/poule/borg_archives/backup_land4to
# 	borg create --compression lzma,9 /home/poule/borg_archives/backup_land4to::backup_land4to_{now}
# 
#
# à installer en cronjob avec:
#   crontab -e
#
# 	m h  dom mon dow   command
# 	*/30 * * * *    bash /home/$USER/sync_spaceship.sh
#
# ----------------- configs ----------------- 
source /home/tykayn/functions_sync.sh

logDate ' start backup script from sync_spaceship script'
logDate "${pwd} sync_spaceship.sh"

logDate ' stop all rsync jobs'
killall rsync;

# ------------------
logDate ' copie du script actuel'
cp /home/$USER/sync_spaceship.sh /home/$USER/Nextcloud/boulot/syncro_scripts_spaceship
cp /home/$USER/sync_spaceship.sh $ARCHIVE_SYNCABLE/__scripts_syncro
cp /home/$USER/.bash_aliases $ARCHIVE_SYNCABLE/__scripts_syncro
cp /home/$USER/.emacs /home/$USER/Nextcloud/boulot/emacs


echo ' ' >> $LOG_FILE_BACKUP_DATES
echo "### ${today} start backup script from sync_spaceship script" >> $LOG_FILE_BACKUP_DATES

echo ' ' >> $LOG_FILE_BACKUP_DATES
echo "### ${today} list of debian apt packages saved in borg_archives list_of_debian_apt_packages.txt" >> $LOG_FILE_BACKUP_DATES
# save a list of apt packages
# to restore it:
# dpkg --set-selections < list_of_debian_apt_packages.txt
dpkg --get-selections>/home/$USER/list_of_debian_apt_packages.txt

# back pictures to ARCHIVE_SYNCABLE
logDate 'copy of Nextcloud InstantUpload photos'

mv /home/$USER/Nextcloud/InstantUpload/Camera/* "$ARCHIVE_SYNCABLE/photos/$CURRENT_YEAR" | tee -a $LOG_FILE_BACKUP  2>&1
echo ' ' >> $LOG_FILE_BACKUP_DATES
echo "### ${today} medias in $ARCHIVE_SYNCABLE/photos/2022" >> $LOG_FILE_BACKUP_DATES
ls -l "$ARCHIVE_SYNCABLE/photos/2022" | wc -l | tee -a $LOG_FILE_BACKUP  2>&1
 
logDate ' Screenshots et Download'

mv /home/$USER/Nextcloud/InstantUpload/Screenshots/* "$ARCHIVE_SYNCABLE/photos/screenshots" | tee -a $LOG_FILE_BACKUP  2>&1
mv /home/$USER/Nextcloud/InstantUpload/Download/* "$ARCHIVE_SYNCABLE/BAZAR" | tee -a $LOG_FILE_BACKUP  2>&1

logDate 'update local nextcloud to stockage syncable';
rsync -avhWP --perms --inplace --delete-before /home/$USER/Nextcloud/* $ARCHIVE_SYNCABLE/archivage/clouds/Nextcloud | tee -a $LOG_FILE_BACKUP  2>&1

logDate 'update home backup';
rsync -avhWP --inplace --delete-before /home/$USER/* /home/poule/encrypted/home/$USER "${exclude_opts[@]}" --exclude 'Nextcloud' --exclude 'www' | tee -a $LOG_FILE_BACKUP  2>&1


# --------- sauver les dossiers de développement dans l'archive stockage syncable sans supprimer les projets présents -------- #

logDate 'WWW et HTML sauver les dossiers de développement';
rsync -avP /home/tykayn/www/* /home/poule/encrypted/stockage-syncable/www/development/html "${exclude_opts[@]}"
rsync -avP /var/www/html/* /home/poule/encrypted/stockage-syncable/www/development/html "${exclude_opts[@]}"

# ----------------------------------------------------------------------


# --------- disques -------- #
# - blue 4To (squatt à lyon)
# - brossadent 4To
# - chaton 5To (usb boitier)
# - lilia 4To
# - louisbraille 4To
# - brossadent 4To (squatt à vovo)
# -|(disque sur dock)
#  |--|
#  |  |- moonmoon 3To 
#  |  |- rondoudou 1To --- non chiffré
#  |
#  |--|
#	  |- catwoman 4To (dans le NAS)
# - Taiga 1To

echo "le log de backup se situe dans : $LOG_FILE_BACKUP_DATES"


# --------- mettre à jour les borg backup des serveurs distants -------- # 
getWebServersBorg; 

# --- raspberry pi ---------- # 
logDate 'update local backup de domoticz vers stockage-syncable/www/backup/domoticz/synced';
rsync -avhWP pi@192.168.1.8:/home/pi /home/poule/encrypted/stockage-syncable/www/backup/domoticz/synced --delete-before --inplace

# --- maj borg de stockage syncable ---------- # 
upBorg;


# --------- disques avec beaucoup de place -------- #
# --------- disques chiffrés -------- #
syncToBigDiskName louisbraille
syncToBigDiskName rugged
syncToBigDiskName moonmoon  # dernier disque source pour temporisation
syncToBigDiskName lilia
syncToBigDiskName chaton

syncToBigDiskName brossadent
syncToBigDiskName blue

# --------- disques non chiffrés -------- # 
# --------- disques de petite taille -------- #
# ne peuvent prendre que le stockage syncable 
	# ----------- small disks --------------
	# syncro vers Taiga de borg
	FILE=/media/$USER/Taiga
		if test -d "$FILE"; then
			echo "### $FILE , Taiga exists."  >> $LOG_FILE_BACKUP_DATES
			logDate 'Taiga disk monté - sync borg backup';
	#		rsync -avhWP /home/poule/encrypted/stockage-syncable/* /media/$USER/$diskName/encrypted/stockage-syncable --perms --delete-before --inplace "${exclude_opts[@]}"
			rsync -avhWP /home/poule/borg_archives/backup_land4to/* /media/tykayn/Taiga/backup_land4to --delete-before --inplace
		else
			echo 'Taiga disk NON monté ';  >> $LOG_FILE_BACKUP_DATES
		fi

# --------- autres pool ZFS -------- # 
syncfatland;



## possible amélioration de vitesse de rsync sur les gros dossiers
# ls $dossier_source | xargs -n1 -P4 -I% rsync -Pa % $destination


# ----------------- sync to NAS ----------------- 
# à destination du NAS, les borg backups perso et de serveurs
logDate ' à destination du NAS: backup_land4to';
rsync -avhWP /home/poule/borg_archives/backup_land4to/* tykayn@192.168.1.15:/var/services/homes/tykayn/borg_archives/backup_land4to --delete-before --inplace --perms 
rsync -avhWP /home/poule/cryptomator/*  tykayn@192.168.1.15:/volume1/bidules_partagés/cryptomator --delete-before --inplace --perms

logDate ' à destination du NAS: production-servers-backup';
#rsync -avhWP /home/poule/borg_archives/production-servers-backup/*  tykayn@192.168.1.15:/var/services/homes/tykayn/borg_archives/production-servers-backup --delete-before --inplace --perms --exclude="@eaDir" "${exclude_opts[@]}"
logDate ' à destination du NAS: vidéos DL';
#rsync -avhWP /home/poule/videos/DOCU-CONF-YOUTUBE/*  tykayn@192.168.1.15:/volume1/bidules_partagés/videos/DOCU-CONF-YOUTUBE --delete-before --inplace --perms 
logDate ' à destination du NAS: vidéos';
#rsync -avhWP /home/poule/videos/*  tykayn@192.168.1.15:/volume1/bidules_partagés/videos --delete-before --inplace --perms 

logDate ' à destination du NAS: music';
#rsync -avhWP /home/poule/music tykayn@192.168.1.15:/volume1/music --delete-before --inplace --perms

# en provenance du NAS ----- les bidules partagés
logDate 'en provenance du NAS: bidules_partagés Documents administratifs';
#rsync -avhWP tykayn@192.168.1.15:/volume1/bidules_partagés/Documents\\\ administratifs /home/poule/encrypted/bidules_partagés_backup  --delete-before --inplace --perms "${exclude_opts[@]}"
logDate 'en provenance du NAS: bidules_partagés Briis';
#rsync -avhWP tykayn@192.168.1.15:/volume1/bidules_partagés/Briis /home/poule/encrypted/bidules_partagés_backup --delete-before --inplace --perms "${exclude_opts[@]}"

logDate 'en provenance du NAS: bidules_partagés Mariage';
#rsync -avhWP tykayn@192.168.1.15:/volume1/bidules_partagés/Mariage /home/poule/encrypted/bidules_partagés_backup --delete-before --inplace --perms "${exclude_opts[@]}"

logDate 'en provenance du NAS: bidules_partagés wulfila_home sans backups ordi';
#rsync -avhWP tykayn@192.168.1.15:/volume1/bidules_partagés/wulfila_home /home/poule/encrypted/other_people_content --inplace --exclude=TK-LAND --exclude=musique_tykayn --exclude=windows_backup_laptop_claire --delete-before --inplace --perms  "${exclude_opts[@]}"

logDate 'en provenance du NAS: fait';

echo "### ${today} end" >> $LOG_FILE_BACKUP_DATES
date -ud "@$SECONDS" | tee -a $LOG_FILE_BACKUP  2>&1
echo "voir les logs: gedit $LOG_FILE_BACKUP"
echo "voir les logs des sections par dates: gedit $LOG_FILE_BACKUP_DATES"
echo " " | tee -a $LOG_FILE_BACKUP  2>&1
echo "taille du BAZAR: $ARCHIVE_SYNCABLE/BAZAR " | tee -a $LOG_FILE_BACKUP  2>&1
du -sch $ARCHIVE_SYNCABLE/BAZAR | tee -a $LOG_FILE_BACKUP  2>&1
date -ud "@$SECONDS" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
echo " " | tee -a $LOG_FILE_BACKUP  2>&1
echo " " | tee -a $LOG_FILE_BACKUP  2>&1

logDate 'fin de sync_spaceship.sh';

