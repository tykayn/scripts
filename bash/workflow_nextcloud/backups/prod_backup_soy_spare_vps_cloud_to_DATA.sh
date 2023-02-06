 echo "############"
 echo " ${date} syncro du dossier borg de soyoustart vers le disque DATA local de FATland"
 echo "############"
 

SOURCE="tykayn@cipherbliss.com:/home/tykayn/backup/borgbackup_soy/*"
# sftp://tykayn@cipherbliss.com/home/tykayn/backup/borgbackup_soy
DESTINATION="/media/tykayn/DATA/borgbackup_soy"

rsync -avzP --perms --delete --progress $SOURCE -e ssh $DESTINATION

 echo -e "${GREEN}############${NC}"
 echo -e "${GREEN} ${date} syncro du dossier borg de soyoustart ok ${NC}"

# peertube 
 SOURCE="tykayn@peertube.cipherbliss.com:/home/tykayn/backup/borgbackup_peertube/*"
# sftp://tykayn@cipherbliss.com/home/tykayn/backup/borgbackup_soy
DESTINATION="/media/tykayn/DATA/borgbackup_peertube"

rsync -avzP --perms --delete --progress $SOURCE -e ssh $DESTINATION

