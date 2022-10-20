#!/bin/bash
# author: @tykayn@mastodon.cipherbliss.com 
# website: https://www.cipherbliss.com 
#
# update all listed git projects in the home folder/www
# list of framagit repos to clone. Run this command to make it work
# --------------------------------
#
# 	cd ~/Téléchargements
#	curl -s https://forge.chapril.org/tykayn/scripts/raw/branch/master/update_git_projects.sh | bash
#
# --------------------------------

declare -a list_repos_framagit=("caisse-bliss" "joinfediverse" "date-poll-api" "mastodon" "peertube" "events-liberator" "gitall" "dotclear-importer" "mobilizon" "fanzine-log" "crossed-words" "generator-tk" "circles" "card-deck" "sf-probe" "mastermind" "portfolio" "time-tracker" "cipherbliss" "caisse-bliss-frontend" "compta" "trafficjam" "ical-generator" "blueprint-cipherbliss" "dotclear2wordpress" "api" "diaspora" )

declare -a list_repos_forge_chapril=("transcription" "org-report-stats" "multi-account-post-schedule-mastodon" "framalibre-scraping" "scripts" "melting-pot" "funky-framadate-front" "rss-feeder-mobilizon" "mastodon-archive-stats" "gtg2json" "libreavous-audio-reader" "osm_my_commerce" "fromage-js" "ueberauth_openstreetmap" "events-liberator")

prefix_framagit='https://framagit.org/tykayn/'
prefix_forgechapril='https://forge.chapril.org/tykayn/'

cloning_place="/home/$USER/www/"

mkdir -p $cloning_place

cd $cloning_place

echo "Number of items in original list: ${#list[*]}"

# fonction qui prend une url de base et une liste de noms de dépots à cloner
function pullOrCreateRepo(){

	baseUrl=$1
	listOfRepos=$2

	for folder_name in ${listOfRepos[@]}
	do
	  echo "check project ${folder_name}"
		if [ ! -d $folder_name ]
		then
			echo "cloning ${folder_name}"
			git clone "${prefix_framagit}${folder_name}.git"

		# test existence of a folder
		# if there is no folder, clone it
		# else, update with fetch from origin
		else
			echo "##### update project $folder_name"
			cd $folder_name

			git remote -v
			git fetch origin
		fi
	done

}

# lancer les clonages et git pull sur chaque dépot

echo "cloning from framagit"
pullOrCreateRepo $prefix_framagit $list_repos_framagit

echo "cloning from forge chapril"
pullOrCreateRepo $prefix_forgechapril $list_repos_forge_chapril

# vous pouvez ajouter vos autres dépots et lancer la fonction pullOrCreateRepo

ls -l
echo "update done"

