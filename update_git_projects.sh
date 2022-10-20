#!/bin/bash
# update all projects
# list of framagit repos to clone

declare -a StringArrayFramagit=("caisse-bliss" "joinfediverse" "date-poll-api" "mastodon" "peertube" "events-liberator" "gitall" "dotclear-importer" "mobilizon" "fanzine-log" "crossed-words" "generator-tk" "circles" "card-deck" "sf-probe" "mastermind" "portfolio" "time-tracker" "cipherbliss" "caisse-bliss-frontend" "compta" "trafficjam" "ical-generator" "blueprint-cipherbliss" "dotclear2wordpress" "api" "diaspora" )

declare -a StringArrayForgeChapril=("transcription" "org-report-stats" "multi-account-post-schedule-mastodon" "framalibre-scraping" "scripts" "melting-pot" "funky-framadate-front" "rss-feeder-mobilizon" "mastodon-archive-stats" "gtg2json" "libreavous-audio-reader" "osm_my_commerce" "fromage-js" "ueberauth_openstreetmap" "events-liberator")

prefix_framagit='https://framagit.org/tykayn/'
prefix_forgechapril='https://forge.chapril.org/tykayn/'

cloning_place="/home/$USER/www/"

mkdir -p $cloning_place

cd $cloning_place

echo "Number of items in original list: ${#list[*]}"
echo "cloning from framagit"

for folder_name in ${StringArrayFramagit[@]}
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
# done framagit

for folder_name in ${StringArrayForgeChapril[@]}
do
  echo "check project ${folder_name}"
	if [ ! -d $folder_name ]
	then
		echo "cloning ${folder_name}"
		git clone "${prefix_forgechapril}${folder_name}.git"

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

ls -l
echo "update done"

