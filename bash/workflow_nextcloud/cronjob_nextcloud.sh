#!/bin/bash
# 
# ----------------- documentation ----------------- 
# tâche à effectuer régulièrement sur les ordis portables
# 
# @author functions_sync by @tykayn - contact at cipherbliss.com
source ~/Nextcloud/ressources/workflow_nextcloud/workflow_variables.sh

# récupérer les notes du mobile et les stocker dans l'incoming inbox orgmode
bash $WORKFLOW_PATH/update_calendar_tkwulfi.sh
bash $WORKFLOW_PATH/get_nextcloud_notes_todo.sh
bash $WORKFLOW_PATH/backup_nextcloud_in_user_home.sh
