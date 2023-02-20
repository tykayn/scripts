#!/bin/bash
# @author script by @tykayn - contact at cipherbliss.com
# rafraîchir les assets du dépot d'example versionné avec ceux couramment utilisés.
# à installer sur un ordi que l'on utilise en tant que référence d'assets
# à installer en cronjob avec:
#   crontab -e
#
# m h  dom mon dow   command
# */30 * * * *    bash /home/tykayn/www/scripts/refresh_from_current_assets.sh

# configs
source ~/Nextcloud/ressources/workflow_nextcloud/workflow_variables.sh
echo "mise à jour des assets de référence dans les scripts custom $HOME_OF_SCRIPTS depuis l'ordinateur actuel"


if [ ! -d $HOME_OF_SCRIPTS ]; then
  mkdir -p $HOME_OF_SCRIPTS
  git clone https://forge.chapril.org/tykayn/scripts $HOME_OF_SCRIPTS
fi

# bouger le dossier www
if [ -d $HOME/www ]; then
	echo "déplacement du dossier $HOME/www dans $www_folder"
	mv $HOME/www/* $www_folder
fi

# orgmode
echo " "
echo "copie de config emacs vers le dossier $HOME_OF_SCRIPTS"
cp "$WORKFLOW_PATH/.emacs" "$HOME_OF_SCRIPTS/assets/org" -r
cp "$orgmode_path/config.org" "$HOME_OF_SCRIPTS/assets/org" -r
cp "$orgmode_path/style.css" "$HOME_OF_SCRIPTS/assets/org" -r

cp "$WORKFLOW_PATH/update_calendar.sh" "$HOME_OF_SCRIPTS/assets/org" -r
# sauvegardes
cp "$HOME/test-func.sh" "$HOME_OF_SCRIPTS/bash/backups"

cp "$WORKFLOW_PATH/workflow_variables.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/init_workflow_nextcloud.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/cronjob_nextcloud.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/git_autocommit.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/update_calendar.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/README.md" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/refresh_from_current_assets.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/update_git_projects.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/"
cp "$WORKFLOW_PATH/sync_spaceship.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud"
cp "$WORKFLOW_PATH/functions_sync.sh" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud"
cp -r "$WORKFLOW_PATH/ansible/*" "$HOME_OF_SCRIPTS/bash/workflow_nextcloud/ansible"

cd $HOME_OF_SCRIPTS
git status

echo " "
echo "copie de des fichiers d'alias vers la home utilisateur"
# workflow things
cp "$WORKFLOW_PATH/install/.bash_aliases" ~/
cp "$WORKFLOW_PATH/install/.bash_custom_aliases" ~/
cp "$WORKFLOW_PATH/install/.bashrc" ~/
cp "$WORKFLOW_PATH/install/.zshrc" ~/
cp "$WORKFLOW_PATH/install/.emacs" ~/


echo "HOME_OF_SCRIPTS : $HOME_OF_SCRIPTS"
ls -l "$HOME_OF_SCRIPTS/assets/org"
cd $HOME_OF_SCRIPTS
git add .
git commit -m "update of assets from refresh script"
git push origin
