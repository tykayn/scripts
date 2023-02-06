#/bin/bash
# ----------------- documentation ----------------- 
#
# @author functions_sync by @tykayn - contact at cipherbliss.com



export today=`date` # to log current time
export ARCHIVE_SYNCABLE="/home/poule/encrypted/stockage-syncable" # place where we have our things sorted, other than home
export BORG_PASSCOMMAND="cat $ARCHIVE_SYNCABLE/.tk-borg-passphrase-light" # get the borg repo pass
export SPACESHIP_BORG_REPO="/home/poule/borg_archives/backup_land4to"
export LOG_FILE_BACKUP="$ARCHIVE_SYNCABLE/www/backup/log_backup.log"
export LOG_FILE_BACKUP_DATES="$ARCHIVE_SYNCABLE/www/backup/summary_log_backup.log" # log dates of execution of the script
CURRENT_YEAR="2022"
USER="tykayn"
# --------- log de la date courante -------- #
function logDate()
{

	echo "--- $1"	| tee -a $LOG_FILE_BACKUP_DATES  2>&1
	date "+%Y-%m-%d %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
	echo "--- "	| tee -a $LOG_FILE_BACKUP_DATES  2>&1
}

# --------- gestion des exclusions de rsync -------- #
EXCLUDE=( ".yarn" "cache" ".cache" "Cache" "Steam" "steamapps" ".npm" ".yarn" "node_modules" ".mozilla" "vendor" "Steam" ".rbenv" ".config/borg" "@eaDir" "steamapps" "bower_components")
exclude_opts=()
	for item in "${EXCLUDE[@]}"; do
		exclude_opts+=( --exclude="$item" )
	done
	
logDate  "exclusions de rsync: \n ${exclude_opts[@]}"
# --------- syncro uniquement de borg backup -------- #
# du -sch /home/poule/borg_archives/backup_land4to
function clearDiskSyncBorg()
{
	local diskName=$1
	echo " " >> $LOG_FILE_BACKUP_DATES
	echo " ---------- sync borg folder to disk $diskName " >> $LOG_FILE_BACKUP_DATES
	# chech that the disk exists
	FILE=/media/$USER/$diskName
	if test -d "$FILE"; then
		echo "### $FILE , $diskName exists."  >> $LOG_FILE_BACKUP_DATES
		echo "### ${today} replicate to disk $diskName" >> $LOG_FILE_BACKUP_DATES
		logDate "disk $diskName : partie backup_land4to";
		# log the date of the last big syncro
		touch /home/poule/borg_archives/backup_land4to/last_synced.txt
		rm -rf /media/$USER/$diskName/backup_land4to
		rsync -avhWP /home/poule/borg_archives /media/$USER/$diskName --perms --delete-before --inplace 
		
	else
		echo "### $FILE introuvable."  >> $LOG_FILE_BACKUP_DATES
	fi
	date "+%Y-%m-%d %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
	echo "---- clearDiskSyncBorg $diskName faite -----------------------" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
}

# --------- recopie des éléments de poule zfs -------- #
# les disques de desintation doivent avoir environ 2.5To de place disponible
# chacun doit refléter la partie interne de /home/poule ainsi que le dossier music
function syncToBigDiskName()
{
	local diskName=$1
	echo " " >> $LOG_FILE_BACKUP_DATES
	# chech that the disk exists
	FILE=/media/$USER/$diskName
	if test -d "$FILE"; then
		echo "### $FILE , $diskName exists."  >> $LOG_FILE_BACKUP_DATES
		echo "### ${today} replicate to disk $diskName" >> $LOG_FILE_BACKUP_DATES
		logDate "disk $diskName : part illus";
		rsync -avhWP /home/poule/encrypted/dessins_autres_gens /media/$USER/$diskName/encrypted --perms --delete-before --inplace "${exclude_opts[@]}"
		rsync -avhWP /home/poule/encrypted/mangas /media/$USER/$diskName/encrypted --perms --delete-before --inplace "${exclude_opts[@]}"
		logDate "disk $diskName : part home and installateurs";
		rsync -avhWP /home/poule/encrypted/home /media/$USER/$diskName/encrypted --perms --delete-before --inplace "${exclude_opts[@]}"
		rsync -avhWP /home/poule/encrypted/installateurs /media/$USER/$diskName/encrypted --perms --delete-before --inplace "${exclude_opts[@]}"
		logDate "disk $diskName : part stockage-syncable : photos current year";
		rsync -avhWP /home/poule/encrypted/stockage-syncable/photos/$CURRENT_YEAR/* /media/$USER/$diskName/encrypted/stockage-syncable/photos/$CURRENT_YEAR --delete-before --inplace "${exclude_opts[@]}" 
		logDate "disk $diskName : part stockage-syncable : photos all";
		rsync -avhWP /home/poule/encrypted/stockage-syncable/photos/* /media/$USER/$diskName/encrypted/stockage-syncable/photos --delete-before --inplace "${exclude_opts[@]}" 
		logDate "disk $diskName : part production-servers-backup";
rsync -avhWP /home/poule/borg_archives/production-servers-backup/* /media/$USER/$diskName/borg_archives/production-servers-backup --delete-before --inplace  "${exclude_opts[@]}"
		logDate "disk $diskName : part encrypted all";
		# log the date of the last big syncro
		touch /home/poule/encrypted/last_synced.text
		rsync -avhWP /home/poule/encrypted/* /media/$USER/$diskName/encrypted --delete-before  "${exclude_opts[@]}" 


		#logDate "disk $diskName : part music";
		#rsync -avhWP /home/poule/music /media/$USER/$diskName/ --delete-before --inplace  "${exclude_opts[@]}"
	else
		echo "### $FILE introuvable."  >> $LOG_FILE_BACKUP_DATES
	fi
	date "+%Y-%m-%d %H:%M:%S" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
	echo "---- syncToBigDiskName $diskName faite -----------------------" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
}
# ----------------------------------------------------------------------


# --------- le laptop fatland n"a que 2 To de disponible -------- #
function syncfatland()
{
	echo " " >> $LOG_FILE_BACKUP_DATES
	echo " - envoi vers FATland" >> $LOG_FILE_BACKUP_DATES
	#### vers le laptop FATland
	rsync /home/poule/encrypted/stockage-syncable/photos/$CURRENT_YEAR tykayn@192.168.1.12:/home/poule/encrypted/stockage-syncable/photos -avhWP --delete-before "${exclude_opts[@]}" 
	rsync -avhWP /home/poule/encrypted/stockage-syncable/photos/* tykayn@192.168.1.12:/home/poule/encrypted/stockage-syncable/photos --delete-before "${exclude_opts[@]}" 
	rsync /home/poule/encrypted/stockage-syncable tykayn@192.168.1.12:/home/poule/encrypted -avhWP --delete-before "${exclude_opts[@]}" 
	rsync /home/poule/encrypted/mangas/* tykayn@192.168.1.12:/home/poule/encrypted/mangas -avhWP --delete-before "${exclude_opts[@]}" 
	rsync /home/poule/encrypted/home/* tykayn@192.168.1.12:/home/poule/encrypted/home -avhWP --delete-before "${exclude_opts[@]}" 
	rsync /home/poule/borg_archives/* tykayn@192.168.1.12:/home/poule/borg_archives -avhWP --delete-before
	date | tee -a $LOG_FILE_BACKUP_DATES  2>&1
	echo "sync fatland fait" | tee -a $LOG_FILE_BACKUP_DATES  2>&1
}


# --------- serveurs web -------- #
# retrieve web servers data to zfs spaceship
# récup des borg backup des serveurs web

function getWebServersBorg()
{
	echo " " >> $LOG_FILE_BACKUP_DATES
	echo "### ${today} copy of servers borg_backup production contents " | tee -a $LOG_FILE_BACKUP_DATES  2>&1
	rsync -avzhWP --perms --delete-before tykayn@peertube.cipherbliss.com:/home/$USER/backup/borgbackup_peertube /home/poule/borg_archives/production-servers-backup/spare & rsync -avzhWP --perms --delete-before tykayn@www.cipherbliss.com:/home/$USER/backup/borgbackup_soy /home/poule/borg_archives/production-servers-backup/soyoustart & rsync -avzhWP --perms --delete-before tykayn@peertube.cipherbliss.com:/home/$USER/backup/serveurs-production/borgbackup_cloudland /home/poule/borg_archives/production-servers-backup/cloud
}


# ----------------- BORG ----------------- 
# partie contenant tout stockage-syncable
function upBorg()
{
	killall borg
	logDate  "### --------- SPACESHIP | creating borg archive at $SPACESHIP_BORG_REPO" 
	rm -rf /home/$USER/.cache/borg/150867528afd85114c8aba98af201a7ad8cf01869c507a87c025d2f8701040a9/lock.exclusive
	rm -rf $SPACESHIP_BORG_REPO/lock.exclusive
	borg create $SPACESHIP_BORG_REPO::encrypted_spaceship_{now} $ARCHIVE_SYNCABLE /home/poule/encrypted/home/$USER /home/poule/encrypted/dessins_autres_gens /home/poule/encrypted/bidules_partagés_backup /home/poule/encrypted/installateurs "${exclude_opts[@]}"  --progress --verbose --stats  --compression zstd,9 | tee -a $LOG_FILE_BACKUP  2>&1
	echo " "  | tee -a $LOG_FILE_BACKUP  2>&1
	logDate "### --------- ${today} | SPACESHIP | pruning old archives"  | tee -a $LOG_FILE_BACKUP  2>&1 
	# nettoyage tk_backup
	borg prune -v --list --stats --keep-daily=8 --keep-weekly=6 --keep-monthly=3 --keep-yearly=2 $SPACESHIP_BORG_REPO | tee -a $LOG_FILE_BACKUP  2>&1
	logDate "### --------- pruning done"
}

# ---------- manage log git

function logGit_csv()
{
	git log --pretty=format:"%cd - %an : %s" --graph --since=8.weeks | tee -a log_boulot.org 2>&1
}

# écrire un log des commits réalisés groupés par jour pour le dossier courant
function logGit_per_day(){ 
  while read -r -u 9 since name
  do
    until=$(date "+%Y-%m-%d %H:%M:%S" )

    echo "$since $name"
    echo

    GIT_PAGER=cat git log             \
      --no-merges                     \
      --committer="$name"             \
      --since="$since 00:00:00 +0000" \
      --until="$until 00:00:00 +0000" \
      --format="  * [%h] %s"

    echo
  done 9< <(git log --no-merges --format=$"%cd %cn" --date=short --since=8.weeks | sort --unique --reverse)

}

function logGit_to_org()
{
	folder_name=${PWD##*/} 
	touch log_git_list.org
	echo "* Log git $folder_name\n"> log_git_list.org;
	pwd >> log_git_list.org;
	cat log_git_list.org;
	logGit_per_day | tee -a log_git_list.org 2>&1
}


