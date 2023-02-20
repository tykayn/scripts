#!/bin/bash
# ajouter dans les scripts avec cette ligne:
#
# source ~/Nextcloud/ressources/workflow_nextcloud/workflow_variables.sh
#
#
export main_user="tykayn"
export WORKFLOW_PATH=~/Nextcloud/ressources/workflow_nextcloud
export WORKFLOW_PATH_ROOT=/home/$main_user/Nextcloud/ressources/workflow_nextcloud
export ALIASES_PATH=$WORKFLOW_PATH/install/.bash_custom_aliases
# fichiers orgmode, wiki personnel
export orgmode_path=~/Nextcloud/textes/orgmode
export inbox_orgmode=$orgmode_path/incoming_inbox.org
export orgroam_path=~/Nextcloud/textes/orgmode/org-roam
export backup_texts_folder=~/archives/backup_automatique
export HOME_OF_SCRIPTS=$www_folder/scripts

# archives dans un pool zfs nommé poule
export stockage_syncable_folder=/home/poule/encrypted/stockage-syncable

# dossier où stocker les projets de dev
export www_folder=$HOME/areas/www

export node_version_expected=16

export today=`date` # to log current time
export ARCHIVE_SYNCABLE=$stockage_syncable_folder # place where we have our things sorted, other than home
export BORG_PASSCOMMAND="cat $ARCHIVE_SYNCABLE/.tk-borg-passphrase-light" # get the borg repo pass
export SPACESHIP_BORG_REPO="/home/poule/borg_archives/backup_land4to"
export LOG_FILE_BACKUP="$ARCHIVE_SYNCABLE/www/backup/log_backup.log"
# log dates of execution of the script
export LOG_FILE_BACKUP_DATES="$ARCHIVE_SYNCABLE/www/backup/summary_log_backup.log"