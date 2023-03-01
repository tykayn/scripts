#!/bin/bash
echo "========== init de workflow par Tykayn ======="
source ~/Nextcloud/ressources/workflow_nextcloud/workflow_variables.sh

if ! -d ~/Nextcloud/ressources/workflow_nextcloud/ ; then
	echo "création du dossier nextcloud workflow_nextcloud"
	mkdir -p ~/Nextcloud/ressources/workflow_nextcloud
fi

mkdir -p $stockage_syncable_folder/www/backup
bash ./install/git_config_glob.sh

if ! hash ansible > /dev/null; then
	echo "* installation de Ansible"
  sudo apt install ansible python3-pip
fi
####### lancement des playbooks ansible pour initialisation
ansible-galaxy install coglinev3.veracrypt

echo "vérification et installation des paquets requis"
sudo ansible-playbook $WORKFLOW_PATH/ansible/tk_softwares.yml


ansible-playbook $WORKFLOW_PATH/ansible/pip_modules.yml
sudo ansible-playbook $WORKFLOW_PATH/ansible/snaps.yml
ansible-playbook $WORKFLOW_PATH/ansible/node_packages.yml

ansible-playbook $WORKFLOW_PATH/ansible/cronjob_workflow.yml
sudo ansible-playbook $WORKFLOW_PATH/ansible/cronjob_workflow_root.yml

sudo apt autoremove -y

############ install developping tools
# nvm node version manager
if ! hash nvm > /dev/null; then
	echo "installation de nvm"

  cd tmp
  echo "install nvm"

 wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi

# yarn
corepack enable
#npm i -g yarn

nvm install $node_version_expected
nvm alias default $node_version_expected
nvm alias global $node_version_expected

 echo "nvm installé, version des outils js:"
nvm --version
node --version
yarn --version

echo "install des outils en php"

# composer php
# symfony cli tool
# créer le dossier de scripts
if  ! hash symfony ; then
	wget https://get.symfony.com/cli/installer -O - | bash
fi

if  ! hash composer ; then
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php

	sudo mv composer.phar /usr/local/bin/composer
fi




############## java pour josm
if ! hash java ; then
  sudo apt install java -y
fi

if ! hash javaws; then
  cd tmp
	wget https://github.com/karakun/OpenWebStart/releases/download/v1.7.0/OpenWebStart_linux_1_7_0.deb
	sudo dpkg -i OpenWebStart_linux_1_7_0.deb
	rm -rf OpenWebStart_linux_1_7_0.deb

fi

if ! hash josm ; then
	mkdir -p ~/areas/www/misc/josm
  cd ~/areas/www/misc/josm

	wget https://josm.openstreetmap.de/download/josm.jnlp

	sudo apt install josm -y
fi


# bash ~/Nextcloud/ressources/workflow_nextcloud/update_git_projects.sh

echo "ajouter dans la crontab utilisateur le script cronjob_nextcloud.sh"
echo "# toutes les 5 minutes
#*/5 * * * *     bash ~/Nextcloud/ressources/workflow_nextcloud/cronjob_nextcloud.sh

# vérifiez avec la commande
crontab -e
"
# copier quelques fichiers de config dans la home

cp "$WORKFLOW_PATH"/install/.zshrc ~/
cp "$WORKFLOW_PATH"/install/.bash_aliases ~/
cp "$WORKFLOW_PATH"/install/.bashrc ~/

bash "$WORKFLOW_PATH"/files_management/install.sh
bash "$WORKFLOW_PATH"/install/git_config_glob.sh
bash "$WORKFLOW_PATH"/refresh_from_current_assets.sh
