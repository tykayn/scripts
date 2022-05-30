#!/bin/bash
# version 1.0.0
# Script crée par Tykayn

# Copyleft 2018 Tykayn
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

#code mise en forme
neutre='\e[0;m'
conseil='\e[1;32m' #vert
clear

# sudo!
if [ "$UID" -ne "0" ]
then
 echo -e "Il faut etre root pour executer ce script. ==> ${conseil} sudo ./tykayn_postinstall.sh ${neutre}"
 exit
fi
echo -e "**************************************************";
echo -e "";
echo -e "Ce script va installer Mastodon sur votre serveur.";
echo -e "";
echo -e "**************************************************";
read -p " Quel est le nom de domaine de votre site? ( www.exemple.com sans https:// devant) " domainName

read -p "${conseil} Installation pour ${domainName}, vous confirmez? [Yn]" -i "Y" confirmationAnswer
case $answer in
   [yY]* )
           echo "Okay, C'est parti pour ${domainName}"
           break;;

   [nN]* ) exit;;

   * )     echo "Dude, just enter Y or N, please.";;
  esac

echo -e "${conseil} TADAM! ça c'est fait ${neutre}"
        echo "*******************************************************"

echo "Script fait par Tykayn - https://www.cipherbliss.com"
echo "Pour prendre en compte tous les changements, il faut maintenant redémarrer !"
read -p "Voulez-vous redémarrer immédiatement ? [o/N] " rep_reboot
if [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "O" ]
then
    reboot
fi