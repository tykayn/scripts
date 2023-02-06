#!/bin/bash
# auto commit periodically
# add this script in crontab

cd ~/Nextcloud/textes/orgmode
git add .
git commit -m "auto commit in $hostname"
