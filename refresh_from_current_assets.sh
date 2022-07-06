#/bin/bash
# @author script by @tykayn - contact at cipherbliss.com
# rafraîchir les assets du dépot d'example versionné avec ceux couramment utilisés.
# à installer sur un ordi que l'on utilise en tant que référence d'assets
# à installer en cronjob avec:
#   crontab -e
#
# m h  dom mon dow   command
# */30 * * * *    bash /home/tykayn/www/scripts/refresh_from_current_assets.sh

# configs
export USERNAME_CURRENT=tykayn
export HOME_OF_SCRIPTS=/home/$USERNAME_CURRENT/www/scripts
export HOME_OF_USERNAME_CURRENT=/home/$USERNAME_CURRENT

echo "mise à jour des assets de référence dans les scripts custom $HOME_OF_SCRIPTS depuis l'ordinateur actuel"

# orgmode
cp "$HOME_OF_USERNAME_CURRENT/.emacs" "$HOME_OF_SCRIPTS/assets/org" -r
cp "$HOME_OF_USERNAME_CURRENT/Nextcloud/textes/orgmode/config.org" "$HOME_OF_SCRIPTS/assets/org" -r
cp "$HOME_OF_USERNAME_CURRENT/Nextcloud/textes/orgmode/style.css" "$HOME_OF_SCRIPTS/assets/org" -r
cp "$HOME_OF_USERNAME_CURRENT/Nextcloud/textes/orgmode/upcalendar.sh" "$HOME_OF_SCRIPTS/assets/org" -r

# sauvegardes

echo "HOME_OF_SCRIPTS : $HOME_OF_SCRIPTS"
ls -l "$HOME_OF_SCRIPTS/assets/org"
cd $HOME_OF_SCRIPTS
git add .
git commit -m "update of assets from refresh script"
git push origin