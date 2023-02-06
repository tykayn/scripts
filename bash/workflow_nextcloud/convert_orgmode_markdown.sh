#!/bin/bash
# [[id:6053006f-121e-40a1-ae72-8c1557800e7c][hugo website]]
echo "syncronisation des fichiers org avec le site hugo de démo"
rsync ~/Nextcloud/textes/orgmode/org-roam/*.org ~/www/hugo-essais/quickstart/content/braindump

echo "fichiers org dans hugo"
ls -l  ~/www/hugo-essais/quickstart/content/braindump/*.org |wc -l
echo "fichiers markdown"
ls -l  ~/www/hugo-essais/quickstart/content/braindump/*.md |wc -l
