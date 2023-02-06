 echo "############"
 echo "syncro du dossier BORG local de fatland vers le NAS BROUMIAH"
 echo "############"
 
SOURCE="/media/tykayn/DATA/backup_land4to/*"
rsync -avzP --perms --delete-after --progress $SOURCE -e ssh tykayn@192.168.0.3/var/services/homes/tykayn/archives/backup_land4to -p 20522

 echo -e "${GREEN}############${NC}"
 echo -e "${GREEN}syncro backup vers disque NAS BROUMIAH faite${NC}"
