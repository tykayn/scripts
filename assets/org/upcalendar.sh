#!/bin/bash
# getting a nextcloud calendar without auth and convert it to org file
# add this to a cronjob
#
echo "updating calendar from nextcloud"
#URL="https://cloud.tykayn.fr/remote.php/dav/public-calendars/M2XZMF5KpfmXJcfc\?export" # public link to orgmode calendar of nextcloud https://cloud.tykayn.fr/index.php/apps/calendar/timeGridWeek/now
URL_CAL="https://cloud.tykayn.fr/remote.php/dav/public-calendars/xke8x4NKbyMan92W/?export" # calendrier tkwulfi
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
icsorg -i orgcalendar.ics -o calendar.org
cat calendar.org |wc -l
echo "DONE"
