#!/bin/bash
# récupérer tous les borg backup de conteneurs de Rise

rsync tykayn@proxmox.coussinet.org:/poule/encrypted/* /media/tykayn/disque_usb/backup_rise/encrypted -avzP
