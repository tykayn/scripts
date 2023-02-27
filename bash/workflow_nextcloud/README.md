# Workflow avec Nextcloud
Gérer ses flux de travaux et autres gestion de projets avec des scripts.
J'unifie le comportement de mes stations de travail avec une gestion syncronisée de certains scripts pemettant d'installer certains programmes avec des configurations par défaut.

Ce dossier doit être présent dans votre dossier nextcloud,
idéalement dans:
```
~/Nextcloud/ressources/workflow_nextcloud
```

# débuter
Récupérer le script d'initialisation
```bash
git clone https://forge.chapril.org/tykayn/scripts
cd scripts/bash/workflow_nextcloud
```
Configrer les variables, puis lancer le script d'initialisation
```bash
editor workflow_variables.sh
sudo bash ~/Nextcloud/ressources/workflow_nextcloud/init_workflow_tykayn.sh
```

# TODO 
* gestion des secrets automatiques pour les rsync