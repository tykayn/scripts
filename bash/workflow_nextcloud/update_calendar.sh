#!/bin/bash
# getting a nextcloud calendar without auth and convert it to org file
# add this to a cronjob
# nécessite icsorg, installable par :
# npm install icsorg -g

echo "updating calendar from nextcloud"
#URL="https://cloud.tykayn.fr/remote.php/dav/public-calendars/ABCDEFFFFFFFFFFFFFFF\?export" # public link to orgmode calendar of nextcloud https://cloud.tykayn.fr/index.php/apps/calendar/timeGridWeek/now

URL_CAL="https://nuage.tykayn.fr/remote.php/dav/public-calendars/ABCDEFFFFFFFFFFFFFFF?export" # calendrier partagé
echo $URL_CAL

wget $URL_CAL -O orgcalendar.ics --show-progress

du -sch orgcalendar.ics
icsorg -i orgcalendar.ics -o calendar.org -p 999999
cat calendar.org |wc -l
cp calendar.org ~/Nextcloud/textes/orgmode
echo "DONE"
