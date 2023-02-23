#!/bin/bash
#
#
# ----------------- documentation -----------------
# auto commit des textes orgmode
#
# @author functions_sync by @tykayn - contact at cipherbliss.com

source ~/Nextcloud/ressources/workflow_nextcloud/workflow_variables.sh

cd $orgmode_path
git add .
git commit -m "auto commit in $hostname"
