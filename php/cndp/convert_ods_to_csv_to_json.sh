#!/bin/bash

echo " prendre le fichier odt"
cp "/home/tykayn/Nextcloud/projets/cndp débat penly/cndp_calcul_temps_parole.ods" .

echo " convertir en csv"
libreoffice --headless --convert-to csv cndp_calcul_temps_parole.ods

echo " lignes du fichier csv"
cat cndp_calcul_temps_parole.csv | wc -l

echo "faire un json"
php extract_from_csv.php