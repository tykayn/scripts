#!/bin/bash
# update all projects
# list of framagit repos to clone

declare -a StringArray=("caisse-bliss" "duniter" "joinfediverse" "date-poll-api" "mastodon" "peertube" "events-liberator" "gitall" "dotclear-importer" "mobilizon" "fanzine-log" "crossed-words" "generator-tk" "circles" "card-deck" "sf-probe" "mastermind" "portfolio" "time-tracker" "cipherbliss" "caisse-bliss-frontend" "compta" "trafficjam" "ical-generator" "blueprint-cipherbliss" "dotclear2wordpress" "api" "diaspora" )

prefix_framagit='https://framagit.org/tykayn/'

cloning_place="/home/$USER/www/"

cd $cloning_place
echo "Number of items in original list: ${#list[*]}"
for folder_name in ${StringArray[@]}
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
		 # update dependencies if there is an update script
    if [ -f "update.sh" ]
	    then
	      bash update.sh
	  fi

	  if [ -f "yarn.lock" ]
	    then
	      yarn install --pure-lockfile
#	  elif [ -f "package.lock" ]
#	    npm i
	  fi

		cd ..
	fi
done

ls -l
echo "update done"

