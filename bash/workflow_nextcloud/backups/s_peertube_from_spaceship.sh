 echo "############"
 echo " ${date} syncro du dossier BORG local de fatland vers SPARE peertube.cipherbliss.com"
 echo "############"
 
SOURCE="/media/tykayn/catwoman/backup_land4to/*"
DESTINATION="tykayn@peertube.cipherbliss.com"
DESTINATION_FOLDER="/home/tykayn/backup/backup_land4to"
rsync -avzP --perms --delete --progress $SOURCE -e ssh $DESTINATION:$DESTINATION_FOLDER

 echo -e "${GREEN}############${NC}"
 echo -e "${GREEN} ${date}syncro backup vers disque vers soyoustart cipherbliss.com ${NC}"
