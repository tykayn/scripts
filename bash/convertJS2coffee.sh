#!/bin/bash
#text formatting
neutre='\e[0;m'
bleuclair='\e[1;34m'
bold=$(tput bold)
normal=$(tput sgr0)
# get the name of the js scripts folder
echo -e "${bleuclair} ${bold} conversion de projet ${normal} vers coffeescript "
read -p "nommez le dossier où se trouvent vos scripts .js [js]: " -e -i "js" name
# if the coffee folder doesnt exist, create it
if [ ! -e coffee ]; then
echo "pas de dossier coffee, on le crée"
mkdir coffee
fi
echo -e " copie du dossier ${bleuclair}${bold}${name}${normal} vers le dossier ${bold}coffee${normal} ${neutre}"
cp -R ${name}/* coffee
echo "lire les fichiers du dossier coffee"
# list files and exclude node modules
COUNTER=0
for FILE in `find coffee -name "*.js" -type f -o -path './node_modules' -prune -o -path './components' -prune`
do
if [ -e $FILE ] ; then
COFFEE=${FILE//\.js/\.coffee}
echo -e "    converting ${FILE} to ${bleuclair}${COFFEE}${neutre}${normal}"
js2coffee "$FILE" > "$COFFEE"
rm $FILE
COUNTER=$((COUNTER+1))
else
echo "File: $1 does not exist!"
fi
done
echo -e "${bleuclair}${bold} $COUNTER ${normal}${neutre} fichiers convertis"
cd ../