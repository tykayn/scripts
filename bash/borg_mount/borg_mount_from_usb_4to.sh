#/bin/bash
#
# touch $ARCHIVE_SYNCABLE/.tk-borg-passphrase-light
# remplir le fichier avec les données prises depuis bitwarden
#
# bash /home/tykayn/Nextcloud/projets/rangement/borg_mount.sh
#
# l'archive borg fait 1.3 To
#
echo "monter le borg backup de /home/poule/borg_archives/backup_land4to dans /media/$USER/backup_land4to"

export ARCHIVE_SYNCABLE="/home/poule/encrypted/stockage-syncable" # place where we have our things sorted, other than home
export BORG_PASSCOMMAND="cat /home/$USER/.tk-borg-passphrase-light" # get the borg repo pass
export MEDIA_BORG_REPO="/media/$USER/chaton/borg_archives/backup_land4to"


mkdir /media/$USER/tmp_mount_borg

borg mount /media/$USER/chaton/backup_land4to /media/$USER/tmp_mount_borg
ls -l /media/$USER/tmp_mount_borg

echo "dossier borg monté dans /media/$USER/tmp_mount_borg"
