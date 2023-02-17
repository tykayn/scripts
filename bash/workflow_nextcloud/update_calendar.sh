#!/bin/bash
# getting a nextcloud calendar without auth and convert it to org file
# add this to a cronjob
#
echo "updating calendar from nextcloud"
# public link to orgmode calendar of nextcloud https://cloud.tykayn.fr/index.php/apps/calendar/timeGridWeek/now
#URL="https://cloud.tykayn.fr/remote.php/dav/public-calendars/abcdeffffffffffffffffff\?export"

URL_CAL="https://nuage.tykayn.fr/remote.php/dav/public-calendars/cHkSk5rG445MftpZ?export" # calendrier tkwulfi
echo $URL_CAL

wget $URL_CAL -O orgcalendar.ics --show-progress

# add content of other calendars
#URL_CAL="https://cloud.tykayn.fr/remote.php/dav/calendars/super_admin_tykayn/mobilizonfr/?export"
#wget $URL_CAL -O ->> orgcalendar.ics --show-progress

# annivs
#URL_CAL="https://cloud.tykayn.fr/remote.php/dav/calendars/super_admin_tykayn/contact_birthdays/?export"
#wget $URL_CAL -O ->> orgcalendar.ics --show-progress
# convert the ics to an org file
du -sch orgcalendar.ics
icsorg -i orgcalendar.ics -o calendar.org -p 999999
cat calendar.org |wc -l
cp calendar.org ~/Nextcloud/textes/orgmode
echo "DONE"
