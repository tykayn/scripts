#/bin/bash
#
# touch $ARCHIVE_SYNCABLE/.tk-borg-passphrase-light
# remplir le fichier avec les données prises depuis bitwarden
#
# bash /home/$USER/Nextcloud/projets/rangement/borg_mount.sh
#
# l'archive borg fait 1.3 To
#
echo "monter le borg backup local du disque dada /media/$USER/dada/backup_land4to"

export BORG_PASSCOMMAND="cat /home/$USER/.tk-borg-passphrase-light" # get the borg repo pass
 

mkdir -p /media/$USER/dada/backup_land4to
mkdir -p /media/$USER/dada/temp_mount_backup_land


rm -rf /media/$USER/dada/backup_land4to/lock.exclusive
borg mount /media/$USER/dada/backup_land4to /media/$USER/dada/temp_mount_backup_land

ls -l /media/$USER/dada/tmp_mount_borg

echo "dossier borg monté dans /media/$USER/tmp_mount_borg"
