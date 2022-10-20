#!/bin/bash
#####################################################
# author: @tykayn@mastodon.cipherbliss.com 
# website: https://www.cipherbliss.com 
#
# update all listed git projects in the home folder/www
# list of framagit repos to clone. Run this command to make it work
# ------------------------------------------------------------------------------------------------
#
#	cd ~/Téléchargements
#	curl -s https://forge.chapril.org/tykayn/scripts/raw/branch/master/update_git_projects.sh | bash
#
# ------------------------------------------------------------------------------------------------
#####################################################

######################################################
# liste de tous les projets pour chaque forge logicielle
#####################################################
declare -a list_repos_framagit=("caisse-bliss" "joinfediverse" "date-poll-api" "mastodon" "peertube" "events-liberator" "gitall" "dotclear-importer" "mobilizon" "fanzine-log" "crossed-words" "generator-tk" "circles" "card-deck" "sf-probe" "mastermind" "portfolio" "time-tracker" "cipherbliss" "caisse-bliss-frontend" "compta" "trafficjam" "ical-generator" "blueprint-cipherbliss" "dotclear2wordpress" "api" "diaspora" )
declare -a list_repos_forge_chapril=("transcription" "org-report-stats" "multi-account-post-schedule-mastodon" "framalibre-scraping" "scripts" "melting-pot" "funky-framadate-front" "rss-feeder-mobilizon" "mastodon-archive-stats" "gtg2json" "libreavous-audio-reader" "osm_my_commerce" "fromage-js" "ueberauth_openstreetmap" "events-liberator")

prefix_framagit='https://framagit.org/tykayn/'
prefix_forgechapril='https://forge.chapril.org/tykayn/'

cloning_place="/home/$USER/www/"
 cd $cloning_place
pwd
# fonction qui prend une url de base et une liste de noms de dépots à cloner
# si vous trouvez comment passer facilement un array en argument à une fonction bash, go faire la fonction pour que l'on puisse faire " pullOrCreateRepo base_url liste_de_dépots"
#function pullOrCreateRepo(){
#}

#####################################################
# tout ceci est très verbeux.
# fonctionnement:
# lancer les clonages et git pull sur chaque dépot
# test existence of a folder
# if there is no folder, clone it
# else, update with fetch from origin
#####################################################

echo "----------- from framagit"
  for project_name in "${list_repos_framagit[@]}";
    do
         cd $cloning_place
        if [ ! -d "$project_name" ]
 then
 	echo "+++++ cloning ${project_name}"
 	echo "from ${prefix_framagit}${project_name}.git"
 	git clone "${prefix_framagit}${project_name}.git"

 else
 	echo "##### update project $project_name"
 	cd $cloning_place$project_name
 	git fetch origin
 	git config pull.ff only
 	git pull
 fi
    done

echo "----------- from forge chapril"
  for project_name in "${list_repos_forge_chapril[@]}";
    do
     cd $cloning_place
      if [ ! -d "$project_name" ]
      then
        echo "+++++ cloning ${project_name}"
        echo "from ${prefix_forgechapril}${project_name}.git"
        git clone "${prefix_forgechapril}${project_name}.git"
      else
        echo "##### update project $project_name"
        cd $cloning_place$project_name
        git fetch origin
        git config pull.ff only
        git pull
      fi
    done

# vous pouvez ajouter vos autres dépots

 cd $cloning_place
ls -l |wc -l
echo "update done"

