#!/bin/bash

SOURCE="/media/tykayn/catwoman/backup_land4to"
LOG_FILE_BACKUP=/media/tykayn/catwoman/stockage-syncable/www/backup/log_backup.log

# TODO optimize calls in a function

if [ -d "$SOURCE" ]; then

	# rugged, portable usb3 4To
	echo " "
	echo " $(date) - copie vers le disque - rugged_tk"
	echo " "
	if [ -d "/media/tykayn/rugged_tk" ]; then
	  	echo " =================================================================";
		echo " ===============            copie vers rugged      ===============";
		echo " =================================================================";
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/rugged_tk | tee -a $LOG_FILE_BACKUP  2>&1
		echo " ========================== rugged ok   ==========================";
				echo " ==========================  $(date) rugged ok   ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque rugged non détecté   ==========================";
		echo " ==========================  $(date) disque rugged non détecté    ==========================" >> $LOG_FILE_BACKUP;
	fi


	echo " "
	echo " copie vers le disque - 5DFE59D17034C63C"
	echo " "
	if [ -d "/media/tykayn/5DFE59D17034C63C" ]; then

		echo " =================================================================";
		echo " =============== copie vers tk4to 5DFE59D17034C63C ===============";
		echo " =================================================================";
		# copie de borg local vers disque tk4to, 4To disque 3.5"
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/5DFE59D17034C63C | tee -a $LOG_FILE_BACKUP  2>&1

		echo " ========================== tk4to 5DFE59D17034C63C ok   ==========================";
		echo " ==========================  $(date) disque rugged non détecté    ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque tk4to 5DFE59D17034C63C non détecté   ==========================";
	fi

	echo " "
	echo " copie vers le disque - blue_tk"
	echo " "
	if [ -d "/media/tykayn/blue_tk" ]; then
		echo " =================================================================";
		echo " =============== copie vers blue_tk                ===============";
		echo " =================================================================";
		# blue, portable usb3 4To
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/blue_tk | tee -a $LOG_FILE_BACKUP  2>&1


		echo " ========================== blue_tk ok   ==========================";
		echo " ==========================  $(date) blue_tk ok    ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque blue_tk non détecté   ==========================";
	fi
	
	echo " "
	echo " copie vers le disque - louisbraille"
	echo " "
	if [ -d "/media/tykayn/louisbraille" ]; then
		echo " =================================================================";
		echo " =============== copie vers louisbraille                ===============";
		echo " =================================================================";
		# blue, portable usb3 4To
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/louisbraille | tee -a $LOG_FILE_BACKUP  2>&1


		echo " ========================== louisbraille ok   ==========================";
		echo " ==========================  $(date) louisbraille ok    ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque louisbraille non détecté   ==========================";
	fi
	echo " "
	echo " copie vers le disque - goliath 9To btrfs"
	echo " "
	if [ -d "/media/tykayn/goliath" ]; then
		echo " =================================================================";
		echo " =============== copie vers goliath                ===============";
		echo " =================================================================";
		# blue, portable usb3 4To
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/goliath | tee -a $LOG_FILE_BACKUP  2>&1


		echo " ========================== goliath ok   ==========================";
		echo " ==========================  $(date) goliath ok    ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque goliath non détecté   ==========================";
	fi
	echo " "
	echo " copie vers le disque - brossadent btrfs"
	echo " "
	if [ -d "/media/tykayn/goliath" ]; then
		echo " =================================================================";
		echo " =============== copie vers brossadent                ===============";
		echo " =================================================================";
		# blue, portable usb3 4To
		rsync -avzP --delete --delete-delay --info=progress2 $SOURCE /media/tykayn/brossadent | tee -a $LOG_FILE_BACKUP  2>&1


		echo " ========================== brossadent ok   ==========================";
		echo " ==========================  $(date) brossadent ok    ==========================" >> $LOG_FILE_BACKUP;
	else
		echo " ========================== disque brossadent non détecté   ==========================";
	fi
	

		echo ""
		echo " ========================== fin de syncro de disques externes à Spaceship   ==========================";
		echo " ========================== $(date) fin de syncro de disques externes à Spaceship    ==========================" >> $LOG_FILE_BACKUP;
else
	echo "!!!! dossier source non trouvé !!!!"
	echo " ==========================  $(date) !!!! dossier source non trouvé !!!!    ==========================" >> $LOG_FILE_BACKUP;
exit 1
fi

exit 0
