#!/bin/bash
# version 2.0.1
# Script crée par Simbd

# Aperçu de ce que donne le script en capture vidéo ici : https://asciinema.org/a/GUjWf28yzmpzHLA69N5XUd7Wp

#  Copyleft 2018 Simbd
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#code mise en forme
noir='\e[1;30m'
gris='\e[1;37m'
avertissement='\e[1;31m' #rouge
appimage='\e[1;32m' #vert
snap='\e[1;33m' #jaune 
flatpak='\e[1;34m' #bleu
ppa='\e[1;35m' #violet
depext='\e[1;36m' #cyan
neutre='\e[0;m' 
couleur1='\e[1;34m' #bleu
couleur2='\e[1;36m' #cyan
couleur3='\e[1;35m' #violet
couleur4='\e[1;33m' #jaune
conseil='\e[1;32m' #vert
clear

# Contrôle de la configuration système (script correctement lancé + version 18.04 + gnome-shell présent)
. /etc/lsb-release

# Si besoin de mettre la fenêtre pour le script en plein écran (désactivé par défaut)
#apt install xdotool -y && xdotool key F11

# contrôle
if [ "$UID" -ne "0" ]
then
    echo -e "${avertissement}Ce script doit se lancer avec les droits d'administrateur : sudo ./Ubuntu18.04_Bionic_Postinstall.sh${neutre}"
    exit
    elif  [ "$DISTRIB_RELEASE" != "18.04" ] && [ "$DISTRIB_RELEASE" != "19" ] && [ "$DISTRIB_RELEASE" != "5" ] #(x)Ubuntu 18.04, Mint 19 et Eos5 acceptés
    then
        echo -e "${avertissement}Désolé $SUDO_USER, ce script n'est conçu que pour la 18.04LTS alors que vous êtes actuellement sur la version $DISTRIB_RELEASE${blanc}"
        exit
        elif [ "$(which gnome-shell)" != "/usr/bin/gnome-shell" ]
        then
            clear
            echo -e "${conseil}NB : Comme vous utilisez une variante et non la version de base d'Ubuntu, 2 questions spécifiques à Gnome seront ignorés${neutre}"
            echo "*******************************************************"
            echo -e "${couleur1}0/Vous utilisez actuellement une variante, merci de préciser laquelle (il est recommandé d'être en 64 bits) :${neutre}"
            echo "*******************************************************"
            echo "[1] Xubuntu 18.04 x64 (Xfce)"
            echo "[2] Ubuntu Mate 18.04 x64 (Mate)"
            echo "[3] Lubuntu ou Lubuntu Next 18.04 x64 (Lxde ou LxQt)"
            echo "[4] Kubuntu 18.04 x64 (Kde/Plasma)"  
            echo "[5] Linux Mint 19 x64 (Cinnamon/Mate/Xfce) {NB : snap ne sera pas activé !}"
            echo "[10] Autres variantes basées sur la 18.04 x64 (ex: Kubuntu 18.04, Ubuntu Budgie 18.04...)" 
            read -p "Répondre par le chiffre correspondant (exemple : 1) : " distrib
fi
clear

# Vérification de l'architecture
archi=$(uname -i) 
if [ "$archi" != "x86_64" ]
then
    echo -e "${avertissement}ATTENTION : vous n'êtes pas sous une architecture 64 bits actuellement ! Ce script est testé uniquement pour la version 64 bits. Beaucoup de logiciels ne seront installés qu'en 64 bits (dans ce cas ils ne pourront pas s'installer), néammoins la plupart devraient pouvoir s'installer en 32 bits${neutre}"
    echo "===================="
    read -p "Si vous voulez quand même poursuivre si vous êtes en 32 bits, écrivez : poursuivre : " poursuite
    if [ "$poursuite" != "poursuivre" ]
    then
        exit
    fi
fi

########################
echo "Ok, vous avez correctement lancé le script, passons aux questions..."
echo -e "#########################################################"
echo -e "Voici la légende pour vous informer de certaines choses :"
echo -e "${snap}[Snap]${neutre} => Le paquet s'installera au format Snap (NB : Snap n'est pas activé sous Linux Mint !)"
echo -e "${flatpak}[Flatpak]${neutre} => Le paquet s'installera au format Flatpak via le dépot Flathub)"
echo -e "${appimage}[Appimage]${neutre} => Application portable sans installation qui sera stocké dans ~/appimages"
echo -e "${ppa}[PPA]${neutre} => Utilisation d'un PPA pour l'installation du logiciel"
echo -e "${depext}[DepExt]${neutre} => Utilisation d'un dépot externe (autre que PPA) pour l'installation du logiciel"
echo -e "${avertissement}[I!]${neutre} => Intervention nécessaire (très rare) de la part de l'utilisateur pour l'installation"
echo -e "${avertissement}[D!]${neutre} => Potentiellement dangereux : le logiciel est peut être instable (version alpha etc...)"
echo -e "${avertissement}[X!]${neutre} => Xorg uniquement : logiciel ok en session Xorg (par défaut) mais pas en session Wayland"
echo -e "${avertissement}[M!]${neutre} => Manuel (rare) : pas de raccourci/lanceur (certaines applis seront dans ~/Application)"

echo -e "Si rien de précisé => Installation classique depuis les dépots officiels ou avec un .deb récupéré"
echo -e "#########################################################\n"    

### Section interactive avec les questions

## Mode normal
# Question 1 : sélection du mode de lancement du script
echo -e "${conseil}Conseil: Mettez votre terminal en plein écran pour un affichage plus agréable${neutre}"
echo "*******************************************************"
echo "1/ Mode de lancement du script : "
echo "*******************************************************"
echo -e "${couleur1}[1] Mode Manuel niveau 1 [[Basique]]${neutre} (choix réduit, ignore beaucoup de question)"
echo -e "${couleur2}[2] Mode Manuel niveau 2 [[Standard]]${neutre} (choix recommandé pour la plupart des utilisateurs)"
echo -e "${couleur3}[3] Mode Manuel niveau 3 [[Avancé]]${neutre} (choix large à part 2 exceptions)"
echo -e "${couleur4}[4] Mode Manuel niveau 4 [[Ultimate]]${neutre} (choix très large, toutes les questions posés)"
echo -e "${gris}[10] Profil A (automatique) - Basique${neutre}"
echo -e "${gris}[11] Profil B (automatique) - Technicien IT${neutre}"
echo -e "${gris}[12] Profil C (automatique) - Etablissements scolaires${neutre}"
echo -e "${gris}[13] Profil D (automatique) - Cedric.F${neutre}"
echo -e "${gris}[14] Profil E (automatique) - Raphael.B${neutre}"
echo -e "${gris}[15] Profil F (automatique) - HpFixeFamily/Tara${neutre}"
echo -e "${gris}[16] Profil F (automatique) - Tykayn${neutre}"
echo "*******************************************************"
read -p "Répondre par le chiffre correspondant (exemple : 3) : " choixMode
clear

while [ "$choixMode" != "1" ] && [ "$choixMode" != "2" ] && [ "$choixMode" != "3" ] && [ "$choixMode" != "4" ] && [ "$choixMode" != "10" ] && [ "$choixMode" != "11" ] && [ "$choixMode" != "12" ] && [ "$choixMode" != "13" ] && [ "$choixMode" != "14" ] && [ "$choixMode" != "15" ] && [ "$choixMode" != "16" ]
do
    read -p "Désolé, je ne comprend pas votre réponse, les seuls choix possibles sont les modes manuels (de 1 à 4) ainsi que les modes automatiques (de 10 à 16) : " choixMode
    clear
done

if [ "$choixMode" = "12" ] # étab scolaire (fait appel au script externe dédié aux établissements scolaires)
then
    wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-postinstall.sh ; chmod +x ubuntu-et-variantes-postinstall.sh
    ./ubuntu-et-variantes-postinstall.sh --extra ; rm ubuntu-et-variantes-postinstall.sh
    exit
fi

# Pour tous les modes manuels
if [ "$choixMode" = "1" ] || [ "$choixMode" = "2" ] || [ "$choixMode" = "3" ] || [ "$choixMode" = "4" ]
then
    # Pour tous les modes manuels sauf le 1 pour cette question et uniquement si l'utilisateur est sous Gnome-Shell
    if [ "$choixMode" != "1" ] && [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        echo "======================================================="
        echo -e "${conseil}Astuce 2: Pour toutes les questions, le choix [1] correspond toujours au choix par défaut, si vous faites ce choix, vous pouvez aller plus vite en validant directement avec la touche 'Entrée' de votre clavier.${neutre}"
        # Question 2 : Session 
        echo "*******************************************************"
        echo -e "${couleur2}2/ Quelle(s) session(s) supplémentaire(s) souhaitez-vous installer ? (plusieurs choix possibles)${neutre}"
        echo "*******************************************************"
        echo "[1] Aucune, rester avec la session Ubuntu par défaut (cad Gnome customizé + 2 extensions)"
        echo "[2] Ajouter la session 'Gnome Vanilla' (cad une session Gnome non-customizé et sans extension activée)"
        echo "[3] Ajouter la session 'Gnome Classique' (interface plus traditionnelle avec la techno Gnome-Shell donc Mutter)"
        echo "[4] Ajouter la session 'Gnome Flashback/Metacity' (interface proche du Gnome 2 de l'époque, légère, utilise Metacity)"
        echo "[5] Ajouter la session 'Gnome Flashback/Compiz' (idem mais utilise Compiz comme gestionnaire de fenêtre)"
        echo -e "[6] Ajouter une session 'Ubuntu avec Communitheme' (le nouveau thème communautaire : theme + icone + son) ${snap}[Snap]${neutre}"
        echo "[7] Ajouter la session 'Unity' (l'ancienne interface par défaut d'Ubuntu utilisée jusqu'à la 17.04 )"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 1) : " choixSession
        clear
    fi

    ### Pour tous les modes manuels
    # Question 3 : Navigateur web 
    echo -e "${conseil}Astuce 3: vous pouvez faire plusieurs choix, il suffit d'indiquer chaque chiffre séparé d'un espace, par exemple : 2 4 12 19${neutre}"
    echo "*******************************************************"
    echo -e "${couleur1}3/ Quel(s) navigateur(s) vous intéresse(nt) ? (plusieurs choix possibles)${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de navigateur supplémentaire (Firefox stable, version classique, par défaut)"
    echo -e "[2] Beaker ${appimage}[Appimage]${neutre} (Navigateur opensource qui permet de surfer en P2P)"
    echo -e "[3] Brave ${snap}[Snap]${neutre} (Navigateur avec protection pour la vie privée avec blocage des pisteurs)"
    echo "[4] Chromium (la version libre/opensource de 'Google Chrome')"
    echo "[5] Dillo (navigateur capable de tourner sur des ordinosaures)"
    echo -e "[6] Eolie ${flatpak}[Flatpak]${neutre} (une autre alternative pour Gnome)"
    echo "[7] Falkon [QupZilla] (une alternative libre et légère utilisant Webkit)"   
    echo -e "[8] Firefox Béta ${ppa}[PPA]${neutre} (n+1 : 1 version d'avance, remplace la version classique)"
    echo -e "[9] Firefox Developer Edition ${flatpak}[Flatpak]${neutre} (version alternative incluant des outils de développement, généralement n+1/n+2)"
    echo -e "[10] Firefox ESR ${ppa}[PPA]${neutre} (version plutôt orientée entreprise/organisation)"
    echo -e "[11] Firefox Nightly ${flatpak}[Flatpak]${neutre} (toute dernière build en dev, n+2/n+3)" 
    echo "[12] Gnome Web/Epiphany (navigateur de la fondation Gnome s'intégrant bien avec cet environnement)"
    echo -e "[13] Google Chrome ${depext}[DepExt]${neutre}(Le navigateur propriétaire de Google)"
    echo "[14] Lynx (navigateur 100% en ligne de commande, pratique depuis une console SSH)"
    echo -e "[15] Midori ${depext}[DepExt]${neutre} (libre & léger mais un peu obsolète maintenant...)"
    echo -e "[16] Min ${depext}[DepExt]${neutre} (un navigateur minimaliste et donc très léger)" 
    echo -e "[17] Opera ${depext}[DepExt]${neutre} (navigateur norvégien, propriétaire, basé sur Chromium)"
    echo -e "[18] PaleMoon ${depext}[DepExt]${neutre} (un navigateur plutôt récent, libre & performant)"
    echo -e "[19] SRWare Iron (Dérivé de Chromium avec des améliorations sur la confidentialité des données)"
    echo "[20] Tor Browser (pour naviguer dans l'anonymat avec le réseau tor : basé sur Firefox ESR)"
    echo -e "[21] Vivaldi ${depext}[DepExt]${neutre} (un navigateur propriétaire avec une interface sobre assez particulière)"
    echo -e "[22] WaterFox ${depext}[DepExt]${neutre} (un fork de Firefox compatible avec les anciennes extensions)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants séparés d'un espace (exemple : 4 9 21) : " choixNavigateur
    clear

    # Question 4 : Internet/messagerie
    echo "*******************************************************"
    echo -e "${couleur1}4/ Quel(s) logiciel(s) pour le web, messagerie & tchat souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (Thunderbird par défaut)"
    echo -e "[2] CoreBird (un client de bureau pour le réseau social Twitter)"
    echo -e "[3] Discord ${flatpak}[Flatpak]${neutre} (logiciel propriétaire multiplateforme pour communiquer à plusieurs)"
    echo "[4] Ekiga (anciennement 'Gnome Meeting', logiciel de visioconférence/VoIP)"
    echo "[5] Empathy (messagerie instantanée adaptée à Gnome, multi-protocole)"
    echo "[6] Gajim (un autre client Jabber utilisant GTK+)"
    echo "[7] Hexchat (client IRC, fork de xchat)"
    echo -e "[8] Jitsi ${depext}[DepExt]${neutre} (anciennement 'SIP Communicator' surtout orienté VoIP)"
    echo "[9] Linphone (visioconférence utilisant le protocole SIP)"
    echo "[10] Mumble (logiciel libre connue chez les gameurs pour les conversations audios à plusieurs)"
    echo "[11] Pidgin (une alternative à Empathy avec l'avantage d'être multiplateforme)"
    echo "[12] Polari (client IRC pour Gnome)"
    echo "[13] Psi (multiplateforme, libre et surtout conçu pour le protocole XMPP cad Jabber)"
    echo "[14] Ring (anciennement 'SFLphone', logiciel très performant pour la téléphonie IP)"
    echo -e "[15] Riot/Matrix ${flatpak}[Flatpak]${neutre} (Outil libre de messagerie instantannée sécurisée supportant le protocole Matrix)"
    echo -e "[16] Signal ${snap}[Snap]${neutre} (messagerie instantanée chiffrée recommandée par Edward Snowden)"
    echo -e "[17] Skype ${depext}[DepExt]${neutre} (logiciel propriétaire de téléphonie, vidéophonie et clavardage très connue)"
    echo -e "[18] Slack ${snap}[Snap]${neutre} (plate-forme de communication collaborative propriétaire avec gestion de projets)"
    echo "[19] TeamSpeak (discussion à plusieurs dans des canaux, équivalent à Mumble mais propriétaire)"
    echo -e "[20] Telegram (appli de messagerie basée sur le cloud avec du chiffrage)"
    echo -e "[21] Viber ${flatpak}[Flatpak]${neutre} (logiciel de communication, surtout connu en application mobile)"
    echo -e "[22] Weechat (client IRC léger, rapide et flexible s'utilisant en CLI)"   
    echo "[23] Whalebird (client de bureau pour le réseau social ouvert et décentralisé Mastodon)"
    echo "[24] WhatsApp (messagerie instantanée via Internet et les réseaux mobiles utilisée par plus d'1 milliard de personnes)"
    echo -e "[25] Wire ${depext}[DepExt]${neutre} (un autre client de messagerie instantanée chiffrée créé par Wire Swiss)" 
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 6 10 14) : " choixInternet
    clear

    # Question 5 : Download/Upload
    echo "*******************************************************"
    echo -e "${couleur1}5/ Quel(s) logiciel(s) de téléchargement/torrent/copie voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas de supplément (Transmission par défaut)"
    echo "[2] aMule (pour le réseau eDonkey2000, clone de Emule)"
    echo "[3] Bittornado (client très simple qui permet de se connecter au réseau BitTorrent)"
    echo "[4] Deluge (client BitTorrent basé sur Python et GTK+)"
    echo "[5] Dukto (transfert de fichiers en open source, et multi-plateforme dans le réseau local)"
    echo "[6] EiskaltDC++ (stable et en français, pour le réseau DirectConnect)"
    echo "[7] FileZilla (logiciel très répandu utilisé pour les transferts FTP ou SFTP)"
    echo -e "[8] FrostWire ${depext}[DepExt]${neutre} (client multiplate-forme pour le réseau Gnutella)"
    echo "[9] Grsync (une interface graphique pour l'outil rsync)"
    echo "[10] Gtk-Gnutella (un autre client stable et léger avec pas mal d'options)"
    echo -e "[11] Gydl ${snap}[Snap]${neutre} (permet de télécharger des vidéos Youtube ou juste la piste audio)"
    echo "[12] Ktorrent (client torrent pour l'environnement de bureau KDE/Plasma)"    
    echo "[13] Nicotine+ (client P2P pour le réseau mono-source Soulseek)"
    echo "[14] Qarte (permet de télécharger des vidéos des sites Arte : replay des émissions + Arte Live Web)"    
    echo "[15] qBittorrent (client BitTorrent léger développé en C++ avec Qt)"    
    echo "[16] Rtorrent (client BitTorrent en ligne de commande donc très léger)"
    echo "[17] SubDownloader (téléchargement de sous-titre)"
    echo "[18] Uget (gestionnaire de téléchargement multiplateforme supportant divers hébergeurs de fichiers)"    
    echo -e "[19] Vuze ${snap}[Snap]${neutre} (plate-forme commerciale d'Azureus avec BitTorrent)"
    echo -e "[20] WebTorrent ${flatpak}[Flatpak]${neutre} (permet le streamming de flux vidéo décentralisé via le protocole bittorrent)"
    echo -e "[21] WormHole (un outil en CLI permettant le transfert sécurisé à travers n'importe quel réseau)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 4 6 8 14 18) : " choixTelechargement
    clear

    # Question 6 : Lecture multimédia
    echo -e "${conseil}Astuce 4: Il est recommandé de choisir au moins VLC ou MPV car Totem est assez limité (lecteur de base)${neutre}"
    echo "*******************************************************"
    echo -e "${couleur1}6/ Quel(s) logiciel(s) de lecture audio/vidéo/stream voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (normalement par défaut : Totem pour la vidéo, Rhythmbox pour la musique)"
    echo "[2] Audacious (lecteur complet pour les audiophiles avec beaucoup de plugins)"
    echo "[3] Banshee (lecteur audio assez complet équivalent à Rhythmbox)"
    echo "[4] Clementine (lecteur audio avec gestion des pochettes, genres musicaux...)"
    echo -e "[5] DragonPlayer (lecteur vidéo pour l'environnement Kde)"   
    echo "[6] Gmusicbrowser (lecteur avec une interface très configurable)"
    echo "[7] Gnome MPV (Interface graphique GTK+ au lecteur mpv, léger, capable de lire de nombreux formats)" 
    echo "[8] Gnome Music (utilitaire 'Musique' de la fondation Gnome pour la gestion audio, assez basique)"
    echo "[9] Gnome Twitch (pour visionner les flux vidéo du site Twitch depuis votre bureau sans utiliser de navigateur)"
    echo -e "[10] GRadio ${flatpak}[Flatpak]${neutre} (application Gnome pour écouter la radio, plus de 1 000 références rien qu'en France !)"
    echo -e "[11] Guayadeque ${ppa}[PPA]${neutre} (lecteur audio et radio avec une interface agréable)"
    echo -e "[12] Lollypop ${flatpak}[Flatpak]${neutre} (lecteur de musique adapté à Gnome avec des fonctions très avancées)"
    echo -e "[13] Molotov.TV ${appimage}[Appimage]${neutre} (service français de distribution de chaînes de TV)"
    echo -e "[14] MuseScore (l'éditeur de partitions de musique le plus utilisé au monde !)"
    echo "[15] Musique (un lecteur épuré)"
    echo "[16] Qmmp (dans le même style de Winamp pour les fans)"
    echo "[17] QuodLibet (un lecteur audio très puissant avec liste de lecture basée sur les expressions rationnelles)"
    echo "[18] Rhythmbox (lecture audio et de gestion de bibliothèque musicale, normalement proposé par défaut sauf en mode minimal)"
    echo "[19] SmPlayer (lecteur basé sur mplayer avec une interface utilisant Qt)"
    echo -e "[20] Spotify ${flatpak}[Flatpak]${neutre} (permet d'accéder gratuitement et légalement à de la musique en ligne)"
    echo -e "[21] VLC {branche 3.0 Stable} ${couleur2}[Recommandé]${neutre}(le couteau suisse de la vidéo, très complet !)"
    echo -e "[22] VLC Dev (backporté) ${snap}[Snap]${neutre} dernière version en développement - branche Edge/instable (4.0...)"    
    echo "[23] Xmms2+Gxmms2 (un autre lecteur audio dans le style de Winamp)" 
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 4 7 13 20) : " choixMultimedia
    clear

    # Question 7 : Traitement/montage/capture video
    echo "*******************************************************"
    echo -e "${couleur1}7/ Souhaitez-vous un logiciel de montage/encodage/capture vidéo ?${neutre}"
    echo "*******************************************************"
    echo "[1] Non, aucun ajout"
    echo -e "[2] Cinelerra ${ppa}[PPA]${neutre} (montage non-linéaire sophistiqué, équivalent à Adobe première, Final Cut et Sony Vegas"
    # Alternative montage vidéo sophistiqué : Da Vinci Resolve, cf : https://www.blackmagicdesign.com/fr/products/davinciresolve/
    echo "[3] DeVeDe (création de DVD/CD vidéos lisibles par des lecteurs de salon)"
    echo -e "[4] Flowblade ${avertissement}[X!]${neutre} (logiciel de montage vidéo multi-piste performant)"
    echo "[5] Handbrake (transcodage de n'importe quel fichier vidéo)"
    echo -e "[6] Kazam ${avertissement}[X!]${neutre} (capture vidéo de votre bureau)"
    echo "[7] KDEnLive (éditeur vidéo non-linéaire pour monter sons et images avec effets spéciaux)"        
    echo "[8] Libav-tools (fork de FFmpeg, outil en CLI pour la conversion via : avconv)"
    echo "[9] Lives (dispose des fonctionnalités d'éditions vidéo/son classique, des filtres et multipiste"
    echo "[10] Mencoder (s'utilise en ligne de commande : encodage de fichiers vidéos)"    
    echo "[11] MMG : MkvMergeGui (interface graphique pour l'outil mkmerge : création/manipulation fichier mkv)"    
    echo -e "[12] Natron ${depext}[DepExt]${neutre} (programme de post-prod destiné au compositing et aux effets spéciaux)"    
    echo -e "[13] OpenBroadcaster Software (OBS) ${ppa}[PPA]${neutre} (pour faire du live en streaming, adapté pour les gamers)"
    echo "[14] OpenShot Video Editor (éditeur vidéo, libre et écrit en Python. Il est conseillé d'ajouter Blender pour certaines fonctions)"    
    echo -e "[15] Peek ${flatpak}[Flatpak]${neutre} (outil de création de Gif animé à partir d'une capture vidéo)"
    echo "[16] Pitivi (logiciel de montage basique avec une interface simple et intuitive)"    
    echo -e "[17] Shotcut ${ppa}[PPA]${neutre} (éditeur de vidéos libre, open source, gratuit et multiplateforme)"
    echo "[18] SimpleScreenRecorder (autre alternative pour la capture vidéo)"
    echo "[19] WinFF (encodage vidéo rapide dans différents formats)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 8 12) : " choixVideo
    clear

    # Question 8 : Traitement/montage photo & modélisation 3D
    echo "*******************************************************"
    echo -e "${couleur1}8/ Quel(s) logiciel(s) de montage photo ou modélisation 3D voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun ajout"
    echo "[2] Blender (suite libre de modélisation 3D, matériaux et textures, d'éclairage, d'animation...)"
    echo "[3] Darktable (gestionnaire de photos libre sous forme de table lumineuse et chambre noir)"
    echo "[4] Flameshot (outil de capture d'écran très complet avec de nombreuses possibilités)"
    echo "[5] Frogr (utile pour ceux qui utilisent le service web 'Flickr')"
    echo -e "[6] Gimp {version 2.8 stable} (montage photo avancé, équivalent à 'Adobe Photoshop' mais totalement libre)"
    echo -e "[7] Gimp backporté {2.10} ${ppa}[PPA]${neutre} (permet de profiter de la toute dernière version de Gimp)"     
    echo "[8] Inkscape (logiciel spécialisé dans le dessin vectoriel, équivalent de 'Adobe Illustrator')"
    echo "[9] K-3D (animation et modélisation polygonale et modélisation par courbes)"
    echo "[10] KolourPaint (logiciel basique équivalent à Microsoft Paint)"
    echo "[11] Krita (outil d'édition et retouche d'images, orienté plutôt vers le dessin bitmap)"
    echo "[12] LibreCAD (anciennement CADubuntu, DAO 2D pour modéliser des dessins techniques)"
    echo "[13] Luminance HDR (logiciel libre de réalisation d'image HDR supportant les formats HDR : OpenEXR, RGBE, Tiff, Raw)"  
    echo "[14] MyPaint (logiciel de peinture numérique développé en Python)"
    echo "[15] Pinta (graphisme simple équivalent à Paint.NET)"
    echo -e "[16] Pixeluvo ${depext}[DepExt]${neutre} (une autre alternative à Photoshop mais il reste propriétaire)"
    echo "[17] Shotwell (gestionnaire de photos pour Gnome en langage Vala, normalement installé par défaut sauf mode minimal)"
    echo -e "[18] Shutter ${avertissement}[X!]${neutre} (pour effectuer des captures d'écran + appliquer des modifications diverses)"
    echo "[19] SweetHome 3D (aménagement d'intérieur pour dessiner les plans d'une maison, placement des meubles...)"
    echo "[20] Ufraw (logiciel de dérawtisation capable de lire/interpréter la plupart des formats RAW)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 11) : " choixGraphisme
    clear

    # Question 9 : Traitement/encodage audio
    echo "*******************************************************"
    echo -e "${couleur1}9/ Quel(s) logiciel(s) pour l'encodage/réglage ou traitement audio voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun"
    echo "[2] Ardour (station de travail audio numérique avec enregistrement multipiste et mixage)"
    echo "[3] Audacity (enregistrement et édition de son numérique)"
    echo "[4] EasyTag (logiciel d'édition des tags ou metadata des fichiers audios, aussi appelés tags ID3)"  
    echo -e "[5] Flacon ${snap}[Snap]${neutre} (pour extraire les pistes d'un gros fichier audio)"
    echo "[6] Gnome Sound Recorder ('enregistreur de son' pour Gnome)"
    echo "[7] Hydrogen (synthétiseur de boite à rythme basé sur les patterns avec connexion possible d'un séquenceur externe)"
    echo "[8] Lame (outil d'encodage en CLI pour le format MP3, par exemple pour convertir un Wav en Mp3)"
    echo "[9] LMMS : Let's Make Music (station audio opensource crée par des musiciens pour les musiciens)"
    echo "[10] MhWaveEdit (application libre d'enregistrement et d'édition audio complète distribuée sous GPL)"
    echo "[11] Mixxx (logiciel pour Dj pour le mixage de musique)"
    echo "[12] OcenAudio (petit éditeur audio très pratique et multiplateforme plus simple que Audacity)"
    echo "[13] Pavucontrol (outil graphique de contrôle des volumes audio entrée/sortie pour Pulseaudio)"
    echo -e "[14] PulseEffects ${flatpak}[Flatpak]${neutre} (interface puissante GTK pour faire plein de réglages/effets sur le son)"
    echo "[15] RipperX (une autre alternative pour extraire les cd de musique)"
    echo "[16] Rosegarden (création musicale avec édition des partitions et peut s'interfacer avec des instruments)"
    echo "[17] Sound-Juicer (pour extraire les pistes audios d'un cd)"
    echo "[18] Xcfa : X Convert File Audio (extraction cd audio, piste dvd, normalisation, création pochette)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 3 10) : " choixAudio
    clear

    # Question 10 : Bureautique et Mail
    echo "*******************************************************"
    echo -e "${couleur1}10/ Quel(s) logiciel(s) de bureautique/courrier souhaitez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément (Thunderbird installé par défaut et LibreOffice est normalement présent de base)"
    echo "[2] Calligra Suite (suite bureautique de KDE, il s'intègre donc bien avec l'environnement kde/plasma)"
    echo "[3] FBReader (Lecteur de livres électroniques e-books supportant notamment les formats epub, fb2, chm, rtf, plucker...)"    
    echo -e "[4] FeedReader ${flatpak}[Flatpak]${neutre} (agrégateur RSS moderne pour consulter vos fils d'informations RSS)"
    echo -e "[5] FreeOffice {SoftMaker} ${avertissement}[D!]${neutre} (suite bureautique propriétaire, gratuite en utilisation privée mais peux nécessiter une clé !)"
    echo "[6] Freeplane (création de cartes heuristiques (Mind Map) avec des diagrammes représentant les connexions sémantiques)"
    echo "[7] Geary (logiciel de messagerie, alternative à Thunderbird et bien intégré à Gnome)"
    echo "[8] Gnome Evolution (logiciel de type groupware et courrielleur, facile à utiliser)"
    echo "[9] Gnome Office (pack contenant Abiword, Gnumeric, Dia, Planner, Glabels, Glom, Tomboy et Gnucash)"
    echo "[10] Gramps (logiciel libre et multiplateforme de gestion/recherche généalogique)"
    echo "[11] LaTex + Texworks (langage de description de document avec un éditeur spécialisé LaTex)"
    echo -e "[12] LibreOffice 6.0 {The Document Foundation} ${couleur2}[Recommandé]${neutre} (La suite bureautique libre la plus utilisée)"
    echo -e "[13] LibreOffice Fresh (backporté) ${ppa}[PPA]${neutre} (permet d'obtenir la toute dernière version de LibreOffice)"    
    echo -e "[14] LibreOffice Supplément : ajoute des styles d'icones, des modèles de documents & clipart + extension Grammalecte activé)"
    echo -e "[15] MailSpring ${snap}[Snap]${neutre} (client de messagerie moderne et multi-plateforme)"
    echo -e "[16] Master PDF Editor (éditeur PDF propriétaire capable de gérer les formulaires CERFA/XFA)" 
    echo -e "[17] Notes Up ${flatpak}[Flatpak]${neutre} (éditeur et manager de notes avec markdown, simple mais efficace)"
    echo -e "[18] OnlyOffice ${snap}[Snap]${neutre} (suite bureautique multifonctionnelle intégrée au CRM, avec jeu d'outils de collaboration)"
    echo "[19] OpenOffice {Apache} (suite bureautique opensource alternative, moins répendu et moins dynamique que LibreOffice)"
    echo "[20] PdfMod (logiciel permettant diverses modifications sur vos PDF)"
    echo "[21] Police d'écriture Microsoft (conseillé pour ne pas avoir de déformation de document crée avec MO)"
    echo -e "[22] Scenari ${depext}[DepExt]${neutre} (contient scenarichaine v4.2 et Opale v3.6) : édition avancée de chaîne éditoriale)"
    echo -e "[23] Scribus (Logiciel de PAO, convient plutôt pour la réalisation de plaquettes, livres et magazines)"
    echo "[24] Wordgrinder (traitement de texte léger en CLI, Formats OpenDocument, HTML import and export)"
    echo -e "[25] WPSOffice ${depext}[DepExt]${neutre} (suite bureautique propriétaire avec une interface proche de Microsoft Office)"
    echo "[26] Zim (wiki en local avec une collection de pages et de marqueurs)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 10 12 18) : " choixBureautique
    clear

    # Question 11 : Science et éducation
    echo "*******************************************************"
    echo -e "${couleur1}11/ Des logiciels de sciences ou pour l'éducation ?${neutre}"
    echo "*******************************************************"
    echo "[1] Pas d'ajout"
    echo "[2] [MATH] Algobox (logiciel libre d'aide à l'élaboration/exécution d'algorithmes en mathématique)"  
    echo "[3] [TECHNO] Algoid (langage de programmation éducatif - Java nécessaire en pré-requis !)"
    echo "[4] [ASTRO] Astro-education (meta-paquet d'Astronomie pour l'éducation : kstar, Gpredict, OpenUniverse...)"
    echo "[5] [CHIMIE] Avogadro (éditeur/visualiseur avancé de molécules pour le calcul scientifique en chimie)"
    echo "[6] [ASTRO] Celestia (simulation spatiale en temps réel qui permet d’explorer l'univers en trois dimensions)"
    echo "[7] [DIVERS] ConvertAll (l'utilitaire ultime pour convertir des unités de mesure avec un très grand choix)"
    echo "[8] [DIVERS] Einstein Puzzle (Jeu intellectuel ou il faut trouver toutes les cartes d'un tableau)"
    echo "[9] [GESTION] GanttProject (planification d'un projet à travers la réalisation d'un diagramme de Gantt)"    
    echo "[10] [DIVERS] GCompris (Suite de logiciels ludo-éducatifs adapté pour les enfants de 2 à 10 ans)"
    echo "[11] [CHIMIE] Gelemental (Tableau périodique regroupant de nombreuses informations sur les éléments chimiques)"    
    echo "[12] [MATH] GeoGebra (géométrie dynamique pour manipuler des objets avec un ensemble de fonctions algébriques)"
    echo "[13] [GEO] Gnome Maps {Carte} (visionneur de cartes utilisant OpenStreetMap riche en données géographiques)"
    echo -e "[14] [GEO] Google Earth Pro ${depext}[DepExt]${neutre} (globe terrestre de Google pour explorer la planète)"
    echo "[15] [GEO] Marble (globe virtuel opensource développé par KDE dans le cadre du projet KdeEdu)"
    echo "[16] [TECHNO] mBlock (environnement de programmation basé sur Scratch 2 pour Arduino)"
    echo "[17] [GEO] OooHg : extension pour LibreOffice qui ajoute 1600 cartes de géographie"
    echo "[18] [DIVERS] OpenBoard (tableau numérique interactif, fork d'OpenSankoré)"   
    echo "[19] [DIVERS] OpenSankore (gestion de tableau numérique interactif)"
    echo "[20] [MATH] OptGeo : logiciel d’optique géométrique libre et opensource"
    echo "[21] [GESTION] Planner : gestionnaire de planning/projets avec diagrammes de Gantt. Alternative à Microsoft Project"    
    echo "[22] [TECHNO] Scratch [v1.4] (langage de programmation visuel libre, créé par le MIT, à vocation éducative et ludique)"
    echo "[23] [TECHNO] Snap4Arduino (modification du language de programmation visuel snap pour les cartes Arduino)"
    echo "[24] [ASTRO] Stellarium (planétarium avec l'affichage du ciel réaliste en 3D avec simulation d'un téléscope)"
    echo "[25] [HANDICAP] ToutEnClic (cahier virtuel pour les enfants étant physiquement dans l’impossibilité d’écrire)"    
    echo "[26] [MATH] Xcas (le couteau suisse des maths : calcul formel, graphe de fonction, géométrie, tableur/stats etc...)"
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 13) : " choixScience
    clear
    
    # Question 12 : Utilitaires 
    echo "*******************************************************"
    echo -e "${couleur1}12/ Quel(s) utilitaire(s) supplémentaire(s) voulez-vous ?${neutre}"
    echo "*******************************************************"
    echo "[1] Aucun supplément"
    echo -e "[2] AnyDesk ${depext}[DepExt]${neutre} (assistance à distance comme teamviewer, natif linux)"
    echo "[3] Brasero (logiciel de gravure de cd/dvd)"  
    echo "[4] Cheese (outil pour prendre des photos/vidéos à partir d'une webcam)"
    echo "[5] DejaDup (utilitaire de sauvegarde très simple. Interface graphique pour l'outil duplicity)"
    echo -e "[6] Diodon (Gestionnaire de presse-papiers GTK+)"
    echo -e "[7] Etcher ${appimage}[AppImage]${neutre} (permet de créer une clé USB ou carte SD bootable à partir d'un fichier image)"
    echo "[8] Flash Player (Adobe) : permet de lire des vidéos qui utiliseraient encore Flash sans support HTML5"
    echo "[9] Gnome Recipes (Application Gnome spécialisée dans les recettes de cuisine)"
    echo -e "[10] MultiSystem ${depext}[DepExt]${neutre} Utilitaire permettant de créer une clé usb bootable avec plusieurs OS"
    echo -e "[11] Oracle Java 8 ${ppa}[PPA]${neutre} (plate-forme propriétaire d'Oracle pour les logiciels développés en Java)"
    echo -e "[12] Oracle Java 10 ${ppa}[PPA]${neutre} (version actuelle de Java distribué par Oracle)"
    echo "[13] Pack d'outils utiles : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone"
    echo "[14] RedShift (Ajuste la température de couleur de l'écran, fonction déjà incluse dans Gnome avec le mode nuit)" 
    echo "[15] Remmina (connexion à distance via une interface graphique à un poste distant, supporte VNC, SSH, SFTP, RDP)"
    echo "[16] Smartmontools (Fournit l'état physiques des disques durs et des SSD voir de certaines clés USB)"
    echo -e "[17] Synaptic Package Manager ${avertissement}[X!]${neutre} (gestionnaire graphique pour les paquets deb)"
    echo -e "[18] TeamViewer ${depext}[DepExt]${neutre}${avertissement}[X!]${neutre} (logiciel propriétaire de télémaintenance avec contrôle de bureau à distance)"
    echo "[19] Terminator (terminal virtuel permettant de partager la fenêtre et d'organiser plus simplement les fenêtres)"
    echo -e "[20] TimeShift ${ppa}[PPA]${neutre} (outil de sauvegarde pour créer/restaurer facilement des instantanés)"
    echo "[21] Variety (gestionnaire de wallpaper très complet, peux prendre en charge des sources comme la NASA, Flickr etc...)"
    echo "[22] VirtualBox {branche 5.2} (virtualisation de système Windows/Mac/Linux/Bsd)"
    echo -e "[23] VirtualBox backporté ${depext}[DepExt]${neutre} dernière version stable possible depuis dépot d'Oracle" 
    echo "[24] Wine {3.0 stable} (une sorte d'émulateur pour faire tourner des applis/jeux Windows)"  
    echo "*******************************************************"
    read -p "Répondre par le ou les chiffres correspondants (exemple : 5 13 26 27) : " choixUtilitaire
    clear

    # Pour tous sauf mode basique
    if [ "$choixMode" != "1" ] 
    then
        # Question 13 : Sécurité, hacking, récupération
        echo "*******************************************************"
        echo -e "${couleur2}13/ Souhaitez-vous un logiciel de réseau/sécurité/récupération de donnée ?${neutre}"
        echo "*******************************************************"
        echo "[1] Je n'en n'ai pas besoin"
        echo -e "[2] Crypter ${appimage}[Appimage]${neutre} (permet de chiffrer/déchiffrer des fichiers simplement)"
        echo "[3] DDRescue (Permet de dupliquer le mieux possible les parties intactes des disques usagés)"
        echo -e "[4] Enpass Password Manager ${depext}[DepExt]${neutre} (coffre-fort pour mdp, cpt bancaire, identité..., chiffrement AES-256 bits)"
        echo -e "[5] Gnome Encfs Manager ${ppa}[PPA]${neutre} (coffre-fort pour vos fichiers/dossiers)"
        echo -e "[6] Gns 3 (virtualisation réseau notamment des switchs et routeurs Cisco et de la console ios)"
        echo -e "[7] Gufw ${avertissement}[X!]${neutre} (interface graphique pour le pare-feu installé par défaut dans Ubuntu 'Ufw')"
        echo "[8] KeePass (utilise mono, centralise la gestion de vos mots de passe personnels, protégé par un master password)"
        echo "[9] KeePassX (utilise Qt, fork du logiciel Keepass, ne semble plus maintenu)"
        echo "[10] KeePassXC (une autre alternive recommandée, fork de KeepassX)"
        echo "[11] Pack d'outils de hacking/cybersécurité (aircrack + nmap + nikto + john the ripper + hashcat + kismet)"
        echo "[12] Sirikali (interface en Qt pour gérer les lecteurs chiffrés avec ecryptfs, cryfs, encfs, gocryptfs, securefs)"
        echo -e "[13] Testdisk (Permet de ressusciter les partitions supprimées accidentellement ou les contenus des fichiers)"
        echo -e "[14] VeraCrypt ${ppa}[PPA]${neutre} (utilitaire libre utilisé pour le chiffrement, suite du projet TrueCrypt)"    
        echo "[15] Wireshark (analyseur de paquets utilisé dans le dépannage et l'analyse de réseaux )" 
        echo "[16] Zenmap (interface graphique pour nmap, idéal pour l'audit réseau)"     
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixSecurite
        clear

        # Question 14a : Gaming
        echo "*******************************************************"
        echo -e "${couleur2}14a/ Quel(s) jeux-vidéo(s) (ou applis liées aux jeux) voulez-vous installer ?${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun, je ne suis pas un gamer"
        echo "[2] 0ad: Empires Ascendant (jeu de stratégie en temps réel RTS)" 
        echo -e "[3] Albion Online ${flatpak}[Flatpak]${neutre} (MMORPG avec système de quête et donjons)"    
        echo "[4] AlienArena (jeu de tir à la première personne, gratuit, dérivé du moteur de Quake)"        
        echo "[5] Assault Cube (clone de Counter Strike)" 
        echo -e "[6] Battle for Wesnoth (stratégie, le joueur doit se battre pour retrouver sa place dans le royaume)"  
        echo -e "[7] Dofus {+Adobe Air en dépendance!} ${avertissement}[D!]${neutre} (MMORPG qui se déroule dans un monde médiéval fantastique)"  
        echo "[8] DosBox (émulateur DOS permettant de jouer à n'importe quel vieux jeu DOS sur votre système d'exploitation moderne)" 
        echo "[9] FlightGear (simulateur de vol)"
        echo "[10] Frozen Bubble (jeu français dont le but est d'aligner des bulles de même couleur pour les faire tomber)"
        echo "[11] Gnome Games (pack d'une dizaine de mini-jeux pour Gnome)"
        echo -e "[12] Khaganat [Khanat] ${avertissement}[D!]${neutre} (MMORPG 100% libre avec un univers imaginaire, en phase alpha)"
        echo "[13] Lutris (Plate-forme de jeux équivalente à Steam mais libre, rassemble tous vos jeux natifs ou non)"
        echo "[14] Megaglest (RTS 3d dans un monde fantastique avec 2 factions qui s'affrontent : la magie et la technologie)"    
        echo -e "[15] Minecraft ${snap}[Snap]${neutre} (un des plus célèbres jeux sandbox mais jeu propriétaire et payant)"
        echo "[16] Minetest (un clone de Minecraft mais libre/opensource et totalement gratuit)"
        echo "[17] OpenArena (un clone libre du célèbre jeu 'Quake')"   
        echo "[18] Pingus (clone de Lemmings, vous devrez aider des manchots un peu idiots à traverser des obstacles)"    
        echo "[19] PlayOnLinux (permet de faire tourner des jeux Windows via Wine avec des réglages pré-établis)"    
        echo "[20] PokerTH (jeu de poker opensource Texas Holdem No Limit jusqu'à 10 participants, humains ou IA)"   
        echo -e "[21] Quake ${snap}[Snap]${neutre} (Pour les nostaligues : le célèbre jeu FPS sortie dans les années 90)"           
        echo "[22] Red Eclipse (jeu de tir subjectif en mode solo et multijoueur basé sur le moteur de jeu Cube Engine 2)"  
        echo "[23] RuneScape (reconnu MMORPG gratuit le plus populaire au monde avec plus de 15 millions de comptes F2P)"
        echo "[24] Steam (plateforme de distribution de jeux. Permet notamment d'installer Dota2, TF2, CS, TR...)"
        echo "[25] SuperTux (clone de Super Mario mais avec un pingouin)"
        echo "[26] SuperTuxKart (clone de Super Mario Kart)"
        echo "[27] Teeworlds (jeu de tir TPS multijoueur 2D, vous incarnez une petite créature, le tee)" 
        echo -e "[28] Trackmania Nation Forever ${snap}[Snap]${neutre} (célèbre jeu de course de voiture déjanté, émulé via Wine)"  
        echo -e "[29] Unreal Tournament 4 ${avertissement}[D!]${neutre} {Accès pré-alpha} (récupère 1 script d'installation qu'il faudra lancer vous-même)"
        echo "[30] Xqf (Explorateur de serveurs de jeu pour visualiser tous les serveurs de vos jeux de façon unifié)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 10 13 16 19) : " choixGaming
        clear
    fi

    # Uniquement pour mode ultimate seulement
    if [ "$choixMode" = "4" ] 
    then
        # Question 14b : Meta-Paquets/Suppléments
        echo "*******************************************************"
        echo -e "${couleur4}14b/ Quel(s) Meta-paquets/Suppléments voulez-vous ?${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun supplément"
        echo "[2] Games-Adventure (pack de jeux d'aventures)"
        echo "[3] Games-Arcade (pack de jeux d'arcades)"
        echo "[4] Games-Board (pack de jeux de sociétés)"
        echo "[5] Games-Card (pack de jeux de cartes)"
        echo "[6] Games-Console (pack de jeux en CLI)"
        echo "[7] Games-Education (pack de jeux éducatifs)"
        echo "[8] Games-Fps (pack de jeux Fps)"
        echo "[9] Games-Platform (pack de jeux de plateformes)"
        echo "[10] Games-Puzzle (pack de jeux de puzzles)"
        echo "[11] Games-Racing (pack de jeux de courses)"
        echo "[12] Games-Rpg (pack de jeux RPG et MMORPG)"
        echo "[13] Games-Shootemup (pack de jeux 'shoot them up')"
        echo "[14] Games-Simulation (pack de jeux de simulations)"
        echo "[15] Games-Sport (pack de jeux de sports)"    
        echo "[16] Games-Strategy (pack de jeux de stratégies)"  
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixMeta
        clear 
    fi

    # Uniquement pour mode avancé ou ultimate
    if [ "$choixMode" = "3" ] || [ "$choixMode" = "4" ] 
    then
        # Uniquement pour GS
        if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
        then
            # Question 15 : Extension 
            echo -e "${conseil}Astuce 5: Si vous aimez faire de la customisation graphique, il est recommandé d'installer l'extension 'user themes'${neutre}"
            echo "*******************************************************"
            echo -e "${couleur3}15/ Des extensions pour gnome-shell à installer ?${neutre}"
            echo "*******************************************************"
            echo "[1] Non, ne pas ajouter de nouvelles extensions"
            echo "[2] AlternateTab (alternative au Alt+Tab issu du mode classique)"
            echo "[3] AppFolders Management (permet de classer les applis dans des dossiers)"
            echo "[4] Caffeine (permet en 1 clic de désactiver temporairement les mises en veilles)"
            echo "[5] Clipboard Indicator (permet de conserver du contenu copié/collé facilement accessible depuis le panel)"        
            echo "[6] DashToDock (permet plus d'options pour les réglages du dock, celui d'Ubuntu étant basé dessus)"
            echo "[7] DashToPanel (un dock alternatif conçu pour remplacer le panel de Gnome, se place en bas ou en haut)"
            echo "[8] Dockilus (Ajoute les signets sur le clique droit de l'icone Nautilus dans le dock comme sous Unity)"
            echo "[9] GSConnect (Basé sur KdeConnect mais sans les dépendances Kde : pour gérer vos appareils Android)"
            echo "[10] Impatience (permet d'augmenter la vitesse d'affichage des animations de Gnome Shell)"
            echo "[11] Log Out Button (ajouter un bouton de déconnexion pour gagner 1 clic en moins pour cette action)"
            echo "[12] Media Player Indicator (ajouter un indicateur pour le contrôle du lecteur multimédia)"
            echo "[13] Multi monitors add on (ajoute au panel un icone pour gérer rapidement les écrans)"
            echo "[14] Openweather (pour avoir la météo directement sur votre bureau)"
            echo "[15] Places status indicator (permet d'ajouter un raccourci vers les dossiers utiles dans le panel)"
            echo "[16] Removable drive menu (raccourci pour démonter rapidement les clés usb/support externe)"
            echo "[17] Shortcuts (permet d'afficher un popup avec la liste des raccourcis possibles)"
            echo "[18] Suspend button (ajout d'un bouton pour activer l'hibernation)"
            echo "[19] System-monitor (moniteur de ressources visible directement depuis le bureau)"        
            echo "[20] Taskbar (permet d'ajouter des raccourcis d'applis directement sur le panel en haut)"
            echo "[21] Top Icons Plus (pour l'affichage d'icone de notif : normalement n'est plus nécessaire)"
            echo "[22] Trash (ajoute un raccourci vers la corbeille dans le panel en haut)"
            echo "[23] Unite (retire la décoration des fenêtres pour gagner de l'espace, pour un style proche du shell Unity)"
            echo -e "[24] User themes ${couleur2}[Recommandé]${neutre} (permet de charger des thèmes stockés dans votre répertoire perso)"
            echo "[25] Window list (affiche la liste des fenêtres en bas du bureau, comme à l'époque sous Gnome 2)"
            echo "[26] Workspace indicator (affiche dans le panel en haut dans quel espace de travail vous êtes)"
            echo "*******************************************************"
            read -p "Répondre par le ou les chiffres correspondants (exemple : 6 23) : " choixExtension
            clear
        fi
    
        # Question 16 : Customization
        echo -e "${conseil}Astuce 6: Si vous voulez transformer l'apparence du bureau, il faudra modifier vous-même l'agencement du bureau en plus d'appliquer les thèmes/icones${neutre}"
        echo "*******************************************************"
        echo -e "${couleur3}16/ Sélectionnez ce qui vous intéresse en terme de customisation${neutre}"
        echo "*******************************************************"
        echo "[1] Pas d'ajout"
        echo -e "[2] Communitheme ${ppa}[PPA]${neutre} thème GTK + icon Suru + sound theme (inutile si session communitheme installé)"
        echo "[3] Icones Papirus (Solus) avec différentes variantes : Adapta, Nokto, Dark, Light"   
        echo "[4] Pack de curseurs : Breeze + Moblin + Oxygen/Oxygen-extra"    
        echo "[5] Pack d'icones 1 : Numix et Numix Circle, Breathe, Breeze, Elementary, Brave + supplément extra icone Gnome"
        echo "[6] Pack d'icones 2 : Dust, Humility, Garton, Gperfection2, Nuovo"
        echo "[7] Pack d'icones 3 : Human, Moblin, Oxygen, Suede, Yasis"
        echo "[8] Thème complet Mac OS X High Sierra Light+Dark (thème+icone+wallpaper)"
        echo "[9] Thème Unity 8"    
        echo "[10] Thème Windows 10 (thème+icone)"
        echo "[11] Thèmes GTK pack1 : Arc + Numix"
        echo -e "[12] Thèmes GTK pack2 ${ppa}[PPA]${neutre} : Adapta + Greybird/Blackbird/Bluebird"
        echo "[13] Thèmes GTK pack3 : Albatross, Yuyo, Human, Gilouche, Materia"
        echo -e "[14] Visuel GDM avec thème gris [Pour G.S uniquement!] ${avertissement}=> Attention : ajoute la session Vanilla en dépendance !${neutre}"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 5 11) : " choixCustom
        clear

        # Question 17 : Prog
        echo "*******************************************************"
        echo -e "${couleur3}17/ Quel(s) éditeur(s) de texte et logiciel(s) de développement voulez-vous ?${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun (en dehors de Vim et Gedit)"
        echo -e "[2] Android Studio ${flatpak}[Flatpak]${neutre} (IDE de Google spécialisé pour le développement d'application Android)"    
        echo "[3] Anjuta (IDE simple pour C/C++, Java, JavaScript, Python et Vala)"  
        echo -e "[4] Atom ${snap}[Snap]${neutre} (éditeur sous licence libre qui supporte les plug-ins Node.js et implémente GitControl)"
        echo "[5] BlueFish (éditeur orienté développement web : HTML/PHP/CSS/...)"
        echo "[6] BlueGriffon (éditeur HTML/CSS avec aperçu du rendu en temps réel)"    
        echo -e "[7] Brackets ${snap}[Snap]${neutre} (éditeur opensource d'Adobe pour le web design et dev web HTML, CSS, JavaScript...)"    
        echo "[8] Code:Blocks (IDE spécialisé pour les langages C/C++)"    
        echo -e "[9] Eclipse ${snap}[Snap]${neutre} (Environnement de production de logiciels libre extensible s'appuyant principalement sur Java)"    
        echo "[10] Emacs (le couteau suisse des éditeurs de texte, il fait tout mais il est complexe)"
        echo "[11] Gdevelop (appli opensource et multiplateforme de création de jeux sans pré-requis de programmation)"
        echo "[12] Geany (IDE rapide et simple utilisant GTK2 supportant de nombreux langages)"
        echo "[13] GitCola (une interface utilisateur graphique git optimisée pour le travail avec l'index git)"    
        echo "[14] Gvim (interface graphique pour Vim)"
        echo -e "[15] IntelliJ Idea ${snap}[Snap]${neutre} (IDE Java commercial de JetBrains, plutôt conçu pour Java)"    
        echo "[16] JEdit (éditeur libre, multiplateforme et très personnalisable)"
        echo "[17] MySql WorkBench (logiciel de schématisation de tables, de MySQL Administrator le logiciel de gestion des bases de données)"    
        echo -e "[18] PyCharm [version communautaire] ${snap}[Snap]${neutre} (IDE pour le langage Python)"
        echo "[19] SciTE : Scintilla Text Editor (éditeur web avec une bonne coloration syntaxique)"
        echo -e "[20] Sublime Text ${depext}[DepExt]${neutre} (logiciel développé en C++ et Python prenant en charge 44 langages de programmation)"
        echo "[21] Unity3D Editor (éditeur pour le moteur de jeu  3D 'Unity' développé par Unity Technologies)" 
        echo -e "[22] Visual Studio Code ${snap}[Snap]${neutre} (développé par Microsoft, sous licence libre MIT)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 8 10 11) : " choixDev
        clear

        # Question 18 : Serveur 
        echo "*******************************************************"
        echo -e "${couleur3}18/ Des fonctions serveurs à activer ?${neutre}"
        echo "*******************************************************"
        echo "[1] Pas de service à activer"
        echo -e "[2] Cuberite ${snap}[Snap]${neutre} (Serveur de jeu Minecraft performant et opensource écrit en C++)"
        echo -e "[3] Docker ${depext}[DepExt]${neutre} (Permet d'empaqueter une appli+dépendances dans un conteneur isolé, utilisable partout)"
        echo "[4] Murmur (Mumble-serveur) serveur distribué permettant de connecter des clients Mumble"
        echo -e "[5] PHP5.6 ${ppa}[PPA]${neutre} (rétroportage de l'ancienne version de PHP)"
        echo "[6] PHP7.2 (dernière version stable de PHP)"
        echo "[7] Samba + Interface d'administration gadmin-samba"
        echo "[8] Serveur BDD PostgreSQL (pour installer une base de donnée PostgreSQL)"
        echo "[9] Serveur FTP avec ProFTPd (stockage de fichier sur votre machine via FTP)"   
        echo "[10] Serveur LAMP (pour faire un serveur web avec votre PC : Apache + MariaDB + PHP)"    
        echo "[11] Serveur SSH (pour contrôler votre PC à distance via SSH)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 1) : " choixServeur
        clear

        # Question 19 : Optimisation
        echo "*******************************************************"
        echo -e "${couleur3}19/ Des optimisations supplémentaires à activer ?${neutre}"
        echo "*******************************************************"
        echo "[1] Non aucune"
        #echo "[1a] Activation pavé numérique au démarrage pour Gnome (à vérifier/non testé dc pas proposé pour l'instant)"
        echo "[2] Ajout d'une commande 'maj' qui met tout à jour (maj apt + maj snap + maj flatpak)"
        echo "[3] Ajouter le support pour le système de fichier Btrfs"
        echo "[4] Ajouter le support pour le système de fichier exFat de Microsoft"
        echo "[5] Ajouter le support pour le système de fichier HFS/HFS+ d'Apple"
        echo "[6] Ajouter le support pour les systèmes de fichiers : F2fs, Jfs, Nilfs, ReiserFS, Udf, Xfs, Zfs"
        echo "[7] Augmenter la sécurité de votre compte : empêcher l'accès en lecture à votre dossier perso aux autres utilisateurs"
        echo "[8] Dépots supplémentaires en + de Flathub pour Flatpak : KDEApps et Winepak" 
        echo "[9] Désactiver complètement le swap (utile si vous avez un SSD et 8 Go de ram ou plus)" 
        echo -e "[10] GameMode ${avertissement}[D!]${neutre} ${avertissement}[Experimental]${neutre} : optimisation temporaire pour les performances en jeu"
        echo -e "[11] Gnome Shell : Activer la minimisation de fenêtre sur les icones pour DashToDock ${avertissement}(DtD doit être installé)${neutre}"
        echo "[12] Gnome Shell : Ajout d'une commande 'fraude' pour Wayland (permet de lancer une appli graphique en root comme sous Xorg)"
        echo "[13] Gnome Shell : Augmenter la durée maximale de capture vidéo intégré de 30s à 600s (soit 10min)"    
        echo "[14] Gnome Shell : Désactiver l'userlist de GDM (utile en entreprise intégrée à un domaine)"
        echo "[15] Installation de switcheroo-control : permet d'utiliser la carte dédié avec le pilote opensource" 
        echo "[16] Installer et activer Conky au démarrage pour afficher des infos (cpu, ram...) en temps réel sur le bureau"
        echo "[17] Installer le microcode Intel propriétaire (pour cpu intel uniquement)"    
        echo "[18] Installer le pilote propriétaire nVidia-390 + nvidia-prime (switch intel/nvidia) + mesa-utils (glxgears test)"   
        echo "[19] Lecture DVD commerciaux protégés par CSS (Content Scrambling System)"
        echo "[20] Optimisation Grub : en cas de multiboot, faire en sorte que le choix par défaut soit toujours le dernier OS démarré" 
        echo "[21] Optimisation Grub : réduire le temps d'attente (si multiboot) de 10 à 2 secondes + retirer le test de RAM dans grub"
        echo "[22] Optimisation Swap : swapiness à 5% (swap utilisé uniquement si plus de 95% de ram utilisée)"
        echo "[23] Spécifique pc portable Lenovo Legion Y520 : activation du Wifi"
        echo "[24] Support imprimantes HP (hplip + sane + hplip-gui)"
        echo "[25] TLP + TlpUI : installation + activation (permet de mieux gérer l'économie d'énergie pour les pc portable)"
        echo "[26] Vim : ajouter un fichier de config avec des paramètres utiles (coloration syntaxique, n°ligne...)"
        echo "*******************************************************"
        read -p "Répondre par le ou les chiffres correspondants (exemple : 2 5 8 10) : " choixOptimisation
        clear 
    fi

    # Mode Ultimate uniquement
    if [ "$choixMode" = "4" ] 
    then
        # Question 20a : Snap
        echo -e "${conseil}Astuce 7: Les paquets Snappy, flatpak et Appimages sont indépendants les uns des autres, ainsi, vous pouvez avoir un même logiciel en plusieurs exemplaires dans des versions différentes${neutre}"
        echo "*******************************************************"
        echo -e "${couleur4}20a/ Choix supplémentaires de paquets universel (Snap) :${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun logiciel via Snap supplémentaire"
        echo -e "[2] Blender ${orange}[--classic]${neutre} ${snap}[Snap]${neutre}"
        echo -e "[3] Dino ${snap}[Snap]${neutre}"
        echo -e "[4] Electrum ${snap}[Snap]${neutre}"
        echo -e "[5] Instagraph ${snap}[Snap]${neutre}"
        echo -e "[6] LibreOffice ${snap}[Snap]${neutre}"
        echo -e "[7] NextCloud client ${snap}[Snap]${neutre}"
        echo -e "[8] PyCharm édition Professionnelle ${avertissement}[X!]${neutre}${orange}[--classic]${neutre} ${snap}[Snap]${neutre}"
        echo -e "[9] Quassel client ${snap}[Snap]${neutre}"
        echo -e "[10] Rube cube ${snap}[Snap]${neutre}"
        echo -e "[11] Shotcut ${snap}[Snap]${neutre}"   
        echo -e "[12] Skype ${snap}[Snap]${neutre}"
        echo -e "[13] TermiusApp ${snap}[Snap]${neutre}"
        echo -e "[14] TicTacToe ${snap}[Snap]${neutre}"
        echo -e "[15] ZeroNet ${snap}[Snap]${neutre}"
        echo "*******************************************************"
        read -p "Choix paquets snappy (exemple : 4 12) : " choixSnap
        clear

        # Question 20b : Flatpak
        echo "*******************************************************"
        echo -e "${couleur4}20b/ Choix supplémentaires de paquets universel (Flatpak) :${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun logiciel via Flatpak supplémentaire"
        echo -e "[2] 0ad ${flatpak}[Flatpak]${neutre}"
        echo -e "[3] Audacity ${flatpak}[Flatpak]${neutre}"
        echo -e "[4] Blender ${flatpak}[Flatpak]${neutre}"  
        echo -e "[5] Dolphin Emulator ${flatpak}[Flatpak]${neutre}"
        echo -e "[6] Extreme Tuxracer ${flatpak}[Flatpak]${neutre}"
        echo -e "[7] Frozen Bubble ${flatpak}[Flatpak]${neutre}"
        echo -e "[8] Gimp ${flatpak}[Flatpak]${neutre}"    
        echo -e "[9] Gnome MPV ${flatpak}[Flatpak]${neutre}"
        echo -e "[10] Google Play Music Desktop Player ${flatpak}[Flatpak]${neutre}"
        echo -e "[11] Homebank ${flatpak}[Flatpak]${neutre}"
        echo -e "[12] Kdenlive ${flatpak}[Flatpak]${neutre}"
        echo -e "[13] LibreOffice ${flatpak}[Flatpak]${neutre}"
        echo -e "[14] Minetest ${flatpak}[Flatpak]${neutre}"
        echo -e "[15] Nextcloud cli ${flatpak}[Flatpak]${neutre}"  
        echo -e "[16] Password Calculator ${flatpak}[Flatpak]${neutre}"
        echo -e "[17] Skype ${flatpak}[Flatpak]${neutre}"
        echo -e "[18] VidCutter ${flatpak}[Flatpak]${neutre}"   
        echo -e "[19] VLC ${flatpak}[Flatpak]${neutre}"    
        echo "*******************************************************"
        read -p "Choix paquets flatpak (exemple : 5 16) : " choixFlatpak
        clear

        # Question 20c : Appimages
        echo -e "${conseil}Astuce 8: Vos AppImages seront disponibles dans un dossier 'appimage' dans votre dossier perso, pour lancer une application : ./nomdulogiciel.AppImage (les droits d'éxécutions seront déjà attribués)${neutre}"
        echo "*******************************************************"
        echo -e "${couleur4}20c/ Choix supplémentaires de paquets portables universel (AppImage) :${neutre}"
        echo "*******************************************************"
        echo "[1] Aucun logiciel portable au format AppImage supplémentaire"
        echo -e "[2] Aidos Wallet ${appimage}[Appimage]${neutre}"
        echo -e "[3] AppImageUpdate ${appimage}[Appimage]${neutre}"  
        echo -e "[4] CozyDrive (pour CozyCloud) ${appimage}[Appimage]${neutre}" 
        echo -e "[5] Digikam ${appimage}[Appimage]${neutre}"
        echo -e "[6] Freecad ${appimage}[Appimage]${neutre}"
        echo -e "[7] Imagine ${appimage}[Appimage]${neutre}"
        echo -e "[8] Infinite Electron ${appimage}[Appimage]${neutre}"
        echo -e "[9] Jaxx ${appimage}[Appimage]${neutre}"
        echo -e "[10] Kdenlive ${appimage}[Appimage]${neutre}"
        echo -e "[11] KDevelop ${appimage}[Appimage]${neutre}"
        echo -e "[12] LibreOffice Dev (pré-version en développement) ${appimage}[Appimage]${neutre}" 
        echo -e "[13] MellowPlayer ${appimage}[Appimage]${neutre}"
        echo -e "[14] Nextcloud Cli ${appimage}[Appimage]${neutre}"
        echo -e "[15] Openshot ${appimage}[Appimage]${neutre}"
        echo -e "[16] OpenToonz ${appimage}[Appimage]${neutre}"    
        echo -e "[17] Owncloud Cli ${appimage}[Appimage]${neutre}"
        echo -e "[18] Popcorntime ${appimage}[Appimage]${neutre}"
        echo -e "[19] Spotify web client ${appimage}[Appimage]${neutre}"
        echo -e "[20] Tulip ${appimage}[Appimage]${neutre}"
        echo "*******************************************************"
        read -p "Choix logiciels portables au format AppImage (exemple : 9 16) : " choixAppimage
        clear
    fi # fin condition pour le mode ultimate
        
fi # fin condition pour uniquement les modes manuels 

### Section installation automatisé

###################################################
# Communs à tous quelque soit la variante

# Pour automatiser l'installation de certains logiciels :
export DEBIAN_FRONTEND="noninteractive"

# Activation du dépot partenaire + installation de flatpak et vérification que snapd est bien installé
#(sauf pour Mint car c'est déjà le cas par défaut pour le dépot partenaire & flatpak et pas besoin de snap en +)
if [ "$distrib" != "5" ]
then
    sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list ; apt update
    apt install snapd flatpak -y ; flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

#Maj du système + nettoyage
apt update ; apt full-upgrade -y ; apt autoremove --purge -y ; apt clean

# Création d'un répertoire pour le script et on se déplace dedans
mkdir /home/$SUDO_USER/script_postinstall ; cd /home/$SUDO_USER/script_postinstall/

if [ "$1" = "vbox" ]
then  # installe les additions invités pour une vm si script lancé avec paramètre "vbox" : ./script.sh vbox
    apt install virtualbox-guest-utils -y    
fi

if [ "$2" != "NRI!" ] # Installé par défaut sauf dans un cas particulier si précision explicite en paramètre
then 
    # Autres outils utiles
    apt install curl net-tools git gdebi vim htop gparted numlockx unrar debconf-utils p7zip-full -y

    # Logiciels utiles normalement déjà installés (dans le cas ou ça ne serai pas le cas, notamment sur certaines variantes)
    apt install firefox firefox-locale-fr transmission-gtk thunderbird thunderbird-locale-fr -y

    # Codecs utiles
    apt install x264 x265 -y

    # Désactivation de l'affichage des messages d'erreurs à l'écran
    sed -i 's/^enabled=1$/enabled=0/' /etc/default/apport

    ###################################################
    # Pour version de base sous Gnome Shell
    if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ]
    then
        # logiciels utiles pour Gnome
        apt install gnome-software-plugin-flatpak dconf-editor gnome-tweak-tool folder-color gnome-system-tools -y
        apt install ubuntu-restricted-addons -y
        apt install ffmpegthumbnailer -y #permet de charger les minatures vidéos plus rapidement dans nautilus
        # Suppression de l'icone Amazon (présent uniquement sur la version de base)
        apt purge ubuntu-web-launchers -y
        # Création répertoire extension pour l'ajout d'extension supplémentaire pour l'utilisateur principal
        mkdir /home/$SUDO_USER/.local/share/gnome-shell/extensions /home/$SUDO_USER/.themes /home/$SUDO_USER/.icons
        # Suppression de l'écran de démarrage à la 1ere connexion
        apt purge gnome-initial-setup -y
        
        # Désinstallation des paquets snappy inutiles (5 préinstallés par défaut) et remplacement par la version deb via apt 
        if [ "$choixMode" = "1" ] || [ "$choixMode" = "2" ] || [ "$choixMode" = "3" ] || [ "$choixMode" = "4" ] 
        then 
            snap remove gnome-3-26-1604 gnome-calculator gnome-characters gnome-logs gnome-system-monitor ; apt install gnome-calculator gnome-characters gnome-logs gnome-system-monitor -y 
        fi
    fi
    ###################################################
    # Spécifique Xubuntu/Xfce 18.04
    if [ "$distrib" = "1" ]
    then
        apt install xfce4 gtk3-engines-xfce xfce4-goodies xfwm4-themes xubuntu-restricted-addons -y 
    fi
    ###################################################
    # Spécifique Ubuntu Mate/Mate 18.04
    if [ "$distrib" = "2" ]
    then
        apt install mate-desktop-environment-extras mate-tweak mate-applet-brisk-menu -y 
        apt purge ubuntu-mate-welcome -y
    fi
    ###################################################
    # Spécifique Lubuntu/Lxde/Lxqt 18.04
    if [ "$distrib" = "3" ]
    then
        apt install lubuntu-restricted-addons -y
    fi
    ###################################################
    # Spécifique Kubuntu/Kde 18.04
    if [ "$distrib" = "4" ]
    then
        apt install kubuntu-restricted-addons kubuntu-restricted-extras -y
    fi
    ###################################################
    # Spécifique Linux Mint 19
    if [ "$distrib" = "5" ]
    then
        apt purge mintwelcome -y
    fi    
fi

### Modes automatiques
###################################################
# Mode basique/novice (choix 10)
if [ "$choixMode" = "10" ]
then
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/piauto_profil1804.basique ; chmod +x piauto_profil1804.basique
    ./piauto_profil1804.basique ; rm piauto_profil1804.basique
fi

###################################################
#  Technicien IT Automatique (choix 11)
if [ "$choixMode" = "11" ]
then
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/piauto_profil1804.techIT ; chmod +x piauto_profil1804.techIT
    ./piauto_profil1804.techIT ; rm piauto_profil1804.techIT
fi

###################################################
#  Cedric.F (choix 13)
if [ "$choixMode" = "13" ]
then
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/piauto_profil1804.cdrik ; chmod +x piauto_profil1804.cdrik
    ./piauto_profil1804.cdrik ; rm piauto_profil1804.cdrik
fi

###################################################
#  Raphael.B (choix 14)
if [ "$choixMode" = "14" ]
then
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/piauto_profil1804.raf ; chmod +x piauto_profil1804.raf
    ./piauto_profil1804.raf ; rm piauto_profil1804.raf
fi

###################################################
#  PC HP Family/Corinne sous Mint19 (choix 15)
if [ "$choixMode" = "15" ]
then
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/piauto_profilTara.hpfamily ; chmod +x piauto_profilTara.hpfamily
    ./piauto_profilTara.hpfamily ; rm piauto_profilTara.hpfamily
fi

###################################################
#  Tykayn  (choix 16)
if [ "$choixMode" = "15" ]
then
    SCRIPT_PERSO="";
    wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/$SCRIPT_PERSO
     ; chmod +x $SCRIPT_PERSO
    ./piauto_profilTara.hpfamily ; rm $SCRIPT_PERSO
fi

# ==================================================== #
## Installation suivant les choix de l'utilisateur :

# Q2/ Installation des sessions demandées
for session in $choixSession
do 
    # Session vanilla        
    if [ "$session" = "2" ]
    then 
        apt install gnome-session -y 
    fi
    # Session classique  
    if [ "$session" = "3" ]
    then 
        apt install gnome-shell-extensions -y 
    fi
    # Session gnome flashback/Metacity
    if [ "$session" = "4" ]
    then 
        apt install gnome-session-flashback -y    
    fi
    # Session gnome flashback/Compiz
    if [ "$session" = "5" ]
    then 
        apt install gnome-session-flashback compiz compizconfig-settings-manager compiz-plugins compiz-plugins-extra -y    
    fi    
    # Session Ubuntu avec communitheme (snap)
    if [ "$session" = "6" ]
    then 
        snap install communitheme
    fi    
    # Session Unity
    if [ "$session" = "7" ]
    then 
        apt install unity-session unity-tweak-tool -y
    fi
done

# Q3/ Installation des navigateurs demandées
for navigateur in $choixNavigateur
do
    case $navigateur in
        "2") #Beaker Browser (appimage)
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/beaker-browser-0.7.11-x86_64.AppImage
            chmod +x beaker*
            ;;    
        "3") #Brave (snap)
            snap install brave
            ;;              
        "4") #chromium
            apt install chromium-browser chromium-browser-l10n -y    
            ;;   
        "5") #Dillo
            apt install dillo -y
            ;;     
        "6") #Eolie via Flatpak
            flatpak install flathub org.gnome.Eolie -y
            ;;            
        "7") #Falkon/Qupzilla
            apt install qupzilla -y
            ;;            
        "8") #firefox béta 
            add-apt-repository ppa:mozillateam/firefox-next -y 
            apt update ; apt upgrade -y
            ;;
        "9") #firefox developper edition 
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxDevEdition.flatpakref -y
            flatpak install flathub org.freedesktop.Platform.ffmpeg -y
            ;;               
        "10") #firefox esr
            add-apt-repository ppa:mozillateam/ppa -y 
            apt update ; apt install firefox-esr firefox-esr-locale-fr -y
            ;;
        "11") #firefox nightly
            flatpak install --from https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxNightly.flatpakref -y
            flatpak install flathub org.freedesktop.Platform.ffmpeg -y
            ;;
        "12") #Gnome Web/epiphany
            apt install epiphany-browser -y
            ;;              
        "13") #Google Chrome
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
            sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
            apt update ; apt install google-chrome-stable -y
            ;;
        "14") #Lynx (cli)
            apt install lynx -y
            ;;            
        "15") #midori
            wget http://midori-browser.org/downloads/midori_0.5.11-0_amd64_.deb
            dpkg -i midori_0.5.11-0_amd64_.deb
            apt install -fy
            ;;      
        "16") #Min
            wget https://github.com/minbrowser/min/releases/download/v1.7.1/min_1.7.1_amd64.deb
            dpkg -i min*.deb ; apt install -fy ; rm -f Min*
            ;;            
        "17") #Opera (maj automatiquement via dépot opéra ajouté par le deb)
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/opera.deb
            dpkg -i opera* ; apt install -fy ; rm opera* ; apt update ; apt upgrade -y #en cas de maj d'opéra
            ;;
        "18") #Palemoon
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/palemoon.deb
            dpkg -i palemoon.deb ; apt install -fy ; rm -f palemoon*
            ;;  
        "19") #SRWare Iron
            wget http://www.srware.net/downloads/iron64.deb ; dpkg -i iron64.deb ; apt install -fy ; rm iron64.deb
            ;;             
        "20") #Tor browser
            apt install torbrowser-launcher -y
            ;;            
        "21") #Vivaldi x64 (sera toujours à jour bien qu'une version précise soit téléchargé : dépot ajouté par le deb)
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/vivaldi.deb
            dpkg -i vivaldi* ; apt install -fy ; rm vivaldi.deb ; apt update && apt upgrade -y 
            ;;
        "22") #Waterfox
            echo "deb https://dl.bintray.com/hawkeye116477/waterfox-deb release main" >> /etc/apt/sources.list.d/waterfox.list
            curl https://bintray.com/user/downloadSubjectPublicKey?username=hawkeye116477 | apt-key add - 
            apt update
            apt install waterfox waterfox-locale-fr -y
            ;;                                    
    esac
done

# Q4/ Tchat/Messagerie instantannée/Télephonie
for internet in $choixInternet
do
    case $internet in
        "2") #Corebird
            apt install corebird -y
            ;;      
        "3") #Discord (flatpak)
            flatpak install flathub com.discordapp.Discord -y
            ;;  
        "4") #ekiga
            apt install ekiga -y
            ;;      
        "5") #empathy
            apt install empathy -y
            ;;
        "6") #gajim
            apt install gajim -y
            ;;   
        "7") #hexchat
            apt install hexchat hexchat-plugins -y
            ;;                
        "8") #jitsi
            wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add -   
            sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"   
            apt update ; apt install jitsi -y   
            ;;   
        "9") #linphone
            apt install linphone -y
            ;;    
        "10") #mumble
            apt install mumble -y
            ;;                
        "11") #pidgin
            apt install pidgin pidgin-plugin-pack -y
            ;;
        "12") #Polari
            apt install polari -y
            ;;                  
        "13") #psi
            apt install psi -y
            ;;  
        "14") #ring
            apt install ring -y
            ;;  
        "15") #Riot (flatpak)
            flatpak install flathub im.riot.Riot -y
            ;;                    
        "16") #signal (snap)
            snap install signal-desktop
            ;;               
        "17") #skype
            wget https://repo.skype.com/latest/skypeforlinux-64.deb ; dpkg -i skypeforlinux-64.deb ; apt install -fy
            rm skypeforlinux*
            ;;   
        "18") #Slack (snap)
            snap install slack --classic
            ;;     
        "19") #Teamspeak (script bash à l'intérieur à lancer manuellement par l'utilisateur)
            wget http://nux87.free.fr/script-postinstall-ubuntu/archives/Teamspeak.tar.xz ; tar -xJf Teamspeak.tar.xz ; rm -f Teamspeak.tar.xz 
            mv Teamspeak /opt/ ; chown -R $SUDO_USER:SUDO_USER /opt/Teamspeak ; wget https://gitlab.com/simbd/Fichier_de_config/raw/master/teamspeak.desktop && mv teamspeak.desktop /usr/share/applications/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/teamspeak.png && mv teamspeak.png /usr/share/icons/
            ;;             
        "20") #telegram 
            apt install telegram-desktop -y
            ;;  
        "21") #viber (flatpak)
            flatpak install flathub com.viber.Viber -y
            ;;  
        "22") #weechat
            apt install weechat -y
            ;;  
        "23") #Whalebird
            wget https://github.com/h3poteto/whalebird-desktop/releases/download/0.6.1/Whalebird-0.6.1-linux-x64.deb
            dpkg -i Whalebird* ; apt install -fy ; rm Whalebird*
            ;;    
        "24") #WhatsApp
            wget http://packages.linuxmint.com/pool/import/w/whatsapp-desktop/whatsapp-desktop_0.3.14-1_amd64.deb
            dpkg -i whatsapp* ; apt install -fy ; rm whatsapp*
            ;;              
        "25") #wire
            apt-key adv --fetch-keys http://wire-app.wire.com/linux/releases.key
            echo "deb https://wire-app.wire.com/linux/debian stable main" | tee /etc/apt/sources.list.d/wire-desktop.list
            apt update ; apt install apt-transport-https wire-desktop -y
            ;;               
    esac
done

# Q5/ Download/Copie
for download in $choixTelechargement
do
    case $download in
        "2") #aMule
            apt install amule -y
            ;;      
        "3") #Bittornado
            apt install bittornado bittornado-gui -y
            ;;      
        "4") #Deluge
            apt install deluge -y
            ;;    
        "5") #Dukto
            wget https://download.opensuse.org/repositories/home:/colomboem/xUbuntu_16.04/amd64/dukto_6.0-1_amd64.deb && dpkg -i dukto*.deb ; apt install -fy ; rm dukto*.deb  
            ;;               
        "6") #EiskaltDC++
            apt install eiskaltdcpp eiskaltdcpp-gtk3 -y
            ;;             
        "7") #filezilla
            apt install filezilla -y
            ;;
        "8") #FrostWire
            wget https://netcologne.dl.sourceforge.net/project/frostwire/FrostWire%206.x/6.5.9-build-246/frostwire-6.5.9.all.deb
            dpkg -i frostwire-6.5.9.all.deb
            apt install -fy
            ;;  
        "9") #Grsync
            apt install grsync -y
            ;;              
        "10") #Gtk-Gnutella
            apt install gtk-gnutella -y
            ;;       
        "11") #Gydl (snap)
            snap install gydl
            ;;      
        "12") #Ktorrent (kde/plasma)
            apt install ktorrent -y
            ;;               
        "13") #Nicotine+ 
            apt install nicotine -y
            ;;       
        "14") #Qarte
            add-apt-repository -y ppa:vincent-vandevyvre/vvv ; apt update ; apt install qarte -y 
            ;;                 
        "15") #qBittorrent
            apt install qbittorrent -y
            ;;  
        "16") #Rtorrent
            apt install rtorrent screen -y
            ;;
        "17") #SubDownloader
            apt install subdownloader -y
            ;;   
        "18") #Uget
            apt install uget -y
            ;;              
        "19") #Vuze
            snap install vuze-vs --classic
            ;;  
        "20") #Webtorrent (flatpak)
            flatpak install flathub io.webtorrent.WebTorrent -y
            ;;
        "21") #WormHole
            apt install magic-wormhole -y
            ;;            
    esac
done

# Q6/ Lecture multimédia
for multimedia in $choixMultimedia
do
    case $multimedia in
        "2") #audacious
            apt install audacious audacious-plugins -y
            ;;  
        "3") #Banshee
            apt install banshee -y
            ;;  
        "4") #Clementine
            apt install clementine -y
            ;;              
        "5") #dragonplayer
            apt install dragonplayer -y
            ;;            
        "6") #gmusicbrowser
            apt install gmusicbrowser -y
            ;;              
        "7") #Gnome MPV
            apt install gnome-mpv -y
            ;;
        "8") #gnome music
            apt install gnome-music -y
            ;;  
        "9") #Gnome Twitch
            apt install gnome-twitch -y
            ;;   
        "10") #Gradio (flatpak)
            flatpak install flathub de.haeckerfelix.gradio -y
            ;; 
        "11") #Guayadeque
            add-apt-repository -y ppa:anonbeat/guayadeque ; apt update
            apt install guayadeque -y
            ;;            
        "12") #Lollypop (flatpak)
            flatpak install flathub org.gnome.Lollypop -y
            ;;  
        "13") #Molotov.tv (appimage)
            wget http://desktop-auto-upgrade.molotov.tv/linux/2.1.2/molotov
            mv molotov molotov.AppImage && chmod +x molotov.AppImage
            ;;             
        "14") #MuseScore 
            apt install musescore -y
            ;;               
        "15") #musique
            apt install musique -y
            ;; 
        "16") #qmmp
            apt install qmmp -y
            ;;             
        "17") #QuodLibet
            apt install quodlibet -y
            ;;   
        "18") #Rhythmbox
            apt install rhythmbox rhythmbox-plugins -y
            ;;              
        "19") #SmPlayer
            apt install smplayer smplayer-l10n smplayer-themes -y
            ;;    
        "20") #Spotify (flatpak)
            flatpak install flathub com.spotify.Client -y
            ;;              
        "21") #VLC
            apt install vlc vlc-l10n vlc-plugin-vlsub -y
            ;;    
        "22") #VLC dev - Snap edge
            snap install vlc --edge --classic 
            ;;               
        "23") #xmms2 + plugins
            apt install xmms2 xmms2-plugin-all gxmms2 -y
            ;;             
    esac
done

# Q7/ Montage/encodage/capture vidéo
for video in $choixVideo
do
    case $video in
        "2") #Cinelerra
            add-apt-repository ppa:cinelerra-ppa/ppa -y
            apt update ; apt install cinelerra-cv -y
            ;;    
        "3") #DeVeDe 
            apt install devede -y
            ;;              
        "4") #Flowblade
            apt install flowblade -y
            ;;      
        "5") #Handbrake
            apt install handbrake -y
            ;;
        "6") #Kazam
            apt install kazam -y
            ;;            
        "7") #KDEnLive
            apt install kdenlive breeze-icon-theme -y
            ;;            
        "8") #Libav-tools
            apt install libav-tools -y
            ;;
        "9") #Lives
            apt install lives -y
            ;;    
        "10") #Mencoder
            apt install mencoder -y
            ;;  
        "11") #MMG MkvMergeGui
            apt install mkvtoolnix mkvtoolnix-gui -y
            ;;             
        "12") #Natron
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/natron_2.3.3_amd64.deb
            dpkg -i natron_2.3.3_amd64.deb
            apt install -fy
            ;;    
        "13") #OpenBroadcaster Software 
            add-apt-repository -y ppa:obsproject/obs-studio ; apt update
            apt install ffmpeg obs-studio -y
            ;;              
        "14") #OpenShot Video Editor 
            apt install --no-install-recommends openshot-qt -y
            ;;
        "15") #Peek (Flatpak) 
            flatpak install flathub com.uploadedlobster.peek -y
            ;;              
        "16") #Pitivi 
            apt install pitivi -y
            ;;
        "17") #Shotcut 
            add-apt-repository -y ppa:haraldhv/shotcut ; apt update ; apt install shotcut -y
            ;;    
        "18") #SimpleScreenRecorder
            apt install simplescreenrecorder -y
            ;;            
        "19") #WinFF
            apt install winff winff-doc winff-qt -y
            ;;            
    esac
done

# Q8/ Montage photo/graphisme/3d
for graphisme in $choixGraphisme
do
    case $graphisme in
        "2") #Blender
            apt install blender -y
            ;;       
        "3") #Darktable
            apt install darktable -y
            ;;    
        "4") #Flameshot
            apt install flameshot -y
            ;;             
        "5") #Frogr
            apt install frogr -y
            ;;              
        "6") #Gimp
            apt install gimp gimp-help-fr gimp-plugin-registry gimp-ufraw gimp-data-extras -y
            ;;
        "7") #Gimp Backporté (via PPA)
            apt purge gimp -y ; add-apt-repository -y ppa:otto-kesselgulasch/gimp ; apt update ; apt upgrade -y ; apt install gimp -y
            ;;            
        "8") #Inkscape
            apt install inkscape -y
            ;;     
        "9") #K-3D
            apt install k3d -y
            ;;  
        "10") #KolourPaint
            apt install kolourpaint -y
            ;;              
        "11") #Krita
            apt install krita krita-l10n -y
            ;;
        "12") #LibreCAD
            apt install librecad -y
            ;;       
        "13") #Luminance HDR
            apt install luminance-hdr -y
            ;;                
        "14") #MyPaint
            apt install mypaint mypaint-data-extras -y
            ;;              
        "15") #Pinta
            apt install pinta -y
            ;;
        "16") #Pixeluvo
            wget http://www.pixeluvo.com/downloads/pixeluvo_1.6.0-2_amd64.deb
            dpkg -i pixeluvo_1.6.0-2_amd64.deb
            apt install -fy
            ;; 
        "17") #Shotwell
            apt install shotwell -y
            ;;             
        "18") #Shutter
            apt install shutter -y
            ;;              
        "19") #SweetHome 3D
            apt install sweethome3d -y
            ;;               
        "20") #Ufraw
            apt install ufraw ufraw-batch -y
            ;;              
    esac
done

# Q9/ Traitement audio
for audio in $choixAudio
do
    case $audio in
        "2") #Ardour
            debconf-set-selections <<< "jackd/tweak_rt_limits false"
            apt install ardour -y
            ;;       
        "3") #Audacity
            apt install audacity -y
            ;;    
        "4") #easytag
            apt install easytag -y
            ;;              
        "5") #Flacon
            snap install flacon-tabetai
            ;;         
        "6") #Gnome Sound Recorder
            apt install gnome-sound-recorder -y
            ;;  
        "7") #Hydrogen
            apt install hydrogen -y
            ;;                 
        "8") #Lame
            apt install lame -y
            ;;            
        "9") #LMMS
            apt install lmms -y
            ;;             
        "10") #MhWaveEdit
            apt install mhwaveedit -y
            ;;    
        "11") #Mixxx
            apt install mixxx -y
            ;;   
        "12") #OcenAudio
            wget www.ocenaudio.com/downloads/index.php/ocenaudio_debian9_64.deb ; dpkg -i ocenaudio*.deb ; apt install -fy ; rm ocenaudio*.deb
            ;;               
        "13") #Pavucontrol
            apt install pavucontrol -y
            ;; 
        "14") #PulseEffects (flatpak)
            flatpak install flathub com.github.wwmm.pulseeffects -y
            ;;               
        "15") #RipperX
            apt install ripperx -y
            ;;   
        "16") #Rosegarden
            apt install rosegarden -y
            ;;              
        "17") #SoundJuicer
            apt install sound-juicer -y
            ;;            
        "18") #Xcfa
            apt install xcfa -y
            ;;
    esac
done

# Q10/ Bureautique
for bureautique in $choixBureautique
do
    case $bureautique in
        "2") # Calligra Suite
            apt install calligra -y
            ;;   
        "3") # FBReader
            apt install fbreader -y
            ;;                
        "4") #Feedreader (flatpak)
            flatpak install flathub org.gnome.FeedReader -y
            ;;    
        "5") #FreeOffice
            apt update ; apt full upgrade -y ; apt install -fy ; update-icon-caches /usr/share/icons/*
            wget http://www.softmaker.net/down/softmaker-freeoffice-2018_931-01_amd64.deb ; dpkg -i softmaker-freeoffice* ; rm softmaker-freeoffice*.deb
            ;;               
        "6") #Freeplane
            apt install freeplane -y
            ;;    
        "7") #Geary
            apt install geary -y
            ;;   
        "8") #Gnome Evolution
            apt install evolution -y
            ;;              
        "9") #Gnome Office
            apt install abiword gnumeric dia planner glabels glom tomboy gnucash -y
            ;; 
        "10") #Gramps
            apt install gramps -y
            ;;             
        "11") #Latex
            apt install texlive texlive-lang-french texworks -y
            ;;             
        "12") #LibreOffice
            apt install libreoffice libreoffice-l10n-fr libreoffice-style-breeze -y
            ;;    
        "13") #LibreOffice fresh (PPA)
            add-apt-repository -y ppa:libreoffice/ppa ; apt update ; apt upgrade -y  
            apt install libreoffice libreoffice-l10n-fr libreoffice-style-breeze -y
            ;;
        "14") #LibreOffice : Supplément
            apt install libreoffice-style-elementary libreoffice-style-oxygen libreoffice-style-human libreoffice-style-sifr libreoffice-style-tango -y
            apt install libreoffice-templates hunspell-fr mythes-fr hyphen-fr openclipart-libreoffice python3-uno -y
            #installation extension grammalecte (oxt)
            wget https://www.dicollecte.org/grammalecte/oxt/Grammalecte-fr-v0.6.2.oxt && chown $SUDO_USER Grammalecte* && chmod +x Grammalecte* 
            unopkg add --shared Grammalecte*.oxt && rm Grammalecte*.oxt ; chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/libreoffice
            ;;            
        "15") #MailSpring (Snap)
            snap install mailspring
            ;;    
        "16") #Master PDF Editor
            wget https://code-industry.net/public/master-pdf-editor-4.3.89_qt5.amd64.deb ; dpkg -i master-pdf* ; apt install -fy ; rm master-pdf*
            ;;              
        "17") #Notes Up (Flatpak)
            flatpak install flathub com.github.philip_scott.notes-up -y
            ;;  
        "18") #OnlyOffice (Snap)
            snap install onlyoffice-desktopeditors --classic
            ;;  
        "19") #OpenOffice
            wget https://freefr.dl.sourceforge.net/project/openofficeorg.mirror/4.1.5/binaries/fr/Apache_OpenOffice_4.1.5_Linux_x86-64_install-deb_fr.tar.gz
            tar xvfz Apache_OpenOffice* ; rm Apache_OpenOffice*.tar.gz ; dpkg -i ./fr/DEBS/*.deb ; rm -r fr ; wget https://raw.githubusercontent.com/simbd/Fichier_de_config/master/ooo.desktop
            mv ooo.desktop /usr/share/applications/ ; wget http://nux87.free.fr/script-postinstall-ubuntu/theme/openoffice.png && mv openoffice.png /usr/share/icons/
            ;;
        "20") #PDFMod
            apt install pdfmod -y 
            ;;    
        "21") #Police d'écriture Microsoft
            echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt install ttf-mscorefonts-installer -y
            ;;
        "22") #Scenari
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/libav-tools_3.3.4-2_all.deb ; dpkg -i libav-tools* ; rm libav-tools*
            wget -O- https://download.scenari.org/deb/scenari.asc | apt-key add - ; echo "deb https://download.scenari.org/deb bionic main" > /etc/apt/sources.list.d/scenari.list
            apt update ; apt install -fy ; apt install scenarichain4.2.fr-fr opale3.6.fr-fr -y
            ;;
        "23") #Scribus
            apt install scribus scribus-template -y
            ;;    
        "24") #Wordgrinder
            apt install wordgrinder wordgrinder-x11 -y
            ;;            
        "25") #WPS Office
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/wps032018.deb ; wget http://fr.archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb
            dpkg -i libpng* ; dpkg -i wps* ; apt install -fy ; rm *.deb ;
            ;;  
        "26") #Zim
            apt install zim -y
            ;;                              
    esac
done

# Q11/ Science/Education
for science in $choixScience
do
    case $science in
        "2") #Algobox
            apt install algobox -y
            ;;   
        "3") #Algoid (+ openjdk8 nécessaire en pré-requis)
            apt install openjdk-8-jre -y ; wget http://www.algoid.net/downloads/AlgoIDE-release.jar ; chmod +x AlgoIDE* ; mv AlgoIDE* /opt/ ; chown $SUDO_USER:SUDO_USER /opt/AlgoIDE*
            wget https://gitlab.com/simbd/Fichier_de_config/raw/master/algoid.desktop && mv algoid.desktop /usr/share/applications/ ; wget http://nux87.free.fr/script-postinstall-ubuntu/theme/algoid.png && mv algoid.png /usr/share/icons/             
            ;;  
        "4") #Astro-education
            apt install astro-education -y
            ;;             
        "5") #Avogadro
            apt install avogadro -y
            ;;   
        "6") #Celestia
            wget --no-check-certificate https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/Celestia_pour_Bionic.sh ; chmod +x Celestia*
            ./Celestia*.sh ; rm Celestia* ;
            ;;  
        "7") #ConvertAll
            apt install convertall -y
            ;;              
        "8") #Einstein Puzzle
            apt install einstein -y
            ;; 
        "9") #GanttProject
            wget https://dl.ganttproject.biz/ganttproject-2.8.7/ganttproject_2.8.7-r2262-1_all.deb
            dpkg -i ganttproject* ; apt install -fy ; rm ganttproject*
            ;;               
        "10") #GCompris
            apt install gcompris gcompris-qt gcompris-qt-data gnucap -y
            ;;      
        "11") #GElemental
            apt install gelemental -y
            ;;              
        "12") #Geogebra
            apt install geogebra -y
            ;;            
        "13") #Gnome Maps
            apt install gnome-maps -y
            ;;               
        "14") #Google Earth
            wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
            dpkg -i google-earth-pro-stable_current_amd64.deb ; apt install -fy
            rm /etc/apt/sources.list.d/google-earth* ; apt update 
            ;;
        "15") #Marble
            apt install --no-install-recommends marble -y
            ;;            
        "16") #mBlock 
            apt install libgconf-2-4 -y
            wget http://mblock.makeblock.com/mBlock4.0/mBlock_4.0.4_amd64.deb ; dpkg -i mBlock*.deb ; apt install -fy ; rm mBlock*.deb           
            ;;
        "17") #oooHG - extension LO 
            apt install ooohg -y
            ;;
        "18") #OpenBoard
            wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/Openboard_1804.sh ; chmod +x Openboard*
            ./Openboard_1804.sh ; rm Openboard_1804.sh
            ;;            
        "19") #OpenSankore
            wget http://nux87.free.fr/script-postinstall-ubuntu/deb/opensankore_amd64.deb ; dpkg -i opensankore_amd64.deb ; apt install -fy ; rm opensankore_amd64.deb 
            ;;            
        "20") #OptGeo
            apt install optgeo -y
            ;;    
        "21") #Planner
            apt install planner -y
            ;;                  
        "22") #Scratch 1.4
            apt install scratch -y
            ;;  
        "23") #Snap4Arduino
            wget https://github.com/bromagosa/Snap4Arduino/releases/download/1.2.5/Snap4Arduino_desktop-gnu-64_1.2.5.tar.gz
            tar xvfz Snap4Arduino*.tar.gz ; rm Snap4Arduino*.tar.gz ; mv Snap4Arduino* /opt/ ; wget http://nux87.free.fr/script-postinstall-ubuntu/theme/snap4arduino.png && mv snap4arduino.png /usr/share/icons/
            wget https://gitlab.com/simbd/Fichier_de_config/raw/master/snap4arduino.desktop && mv snap4arduino.desktop /usr/share/applications/ ; chown -R $SUDO_USER:$SUDO_USER /opt/Snap4Arduino* /opt/
            ;;              
        "24") #Stellarium
            apt install stellarium -y
            ;;           
        "25") #ToutEnClic
            apt install python3-pyqt5 -y
            wget http://www.bipede.fr/downloads/logiciels/ToutEnClic.zip && unzip ToutEnClic.zip && rm ToutEnClic.zip ; mv ToutEnClic /opt/ ; chown -R $SUDO_USER:SUDO_USER /opt/ToutEnClic
            wget https://gitlab.com/simbd/Fichier_de_config/raw/master/toutenclic.desktop && mv toutenclic.desktop /usr/share/applications/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/toutenclic.png && mv toutenclic.png /usr/share/icons/
            ;;               
        "26") #Xcas
            apt install xcas -y
            ;;               
    esac
done

# Q12/ Utilitaire et divers
for utilitaire in $choixUtilitaire
do
    case $utilitaire in
        "2") #AnyDesk (flatpak possible en alternative)
            wget https://download.anydesk.com/linux/anydesk_2.9.5-1_amd64.deb
            dpkg -i anydesk* ; apt install -fy ; rm anydesk* ;
            ;;        
        "3") #Brasero
            apt install brasero brasero-cdrkit nautilus-extension-brasero -y
            ;;  
        "4") #Cheese
            apt install cheese -y
            ;;      
        "5") #Dejadup
            apt install deja-dup -y
            ;;               
        "6") #Diodon
            apt install diodon -y
            ;;     
        "7") #Etcher (appimage
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/etcher-electron-1.4.4-x86_64.AppImage
            ;;               
        "8") #FlashPlayer (avec dépot partenaire)
            apt install adobe-flashplugin -y
            ;;              
        "9") #Gnome Recipes
            apt install gnome-recipes -y
            ;;                        
        "10") #MultiSystem
            wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | apt-key add -
            add-apt-repository -y 'deb http://liveusb.info/multisystem/depot all main'
            apt update ; apt install multisystem -y
            ;;            
        "11") #Oracle Java 8 
            add-apt-repository -y ppa:webupd8team/java ; apt update 
            echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java8-installer -y
            ;;  
        "12") #Oracle Java 10 
            add-apt-repository -y ppa:linuxuprising/java ; apt update
            echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt install oracle-java10-installer -y
            ;;     
        "13") #pack d'outils : vrms + screenfetch + asciinema + ncdu + screen + kclean + rclone
            apt install vrms screenfetch asciinema ncdu screen rclone -y
            wget http://hoper.dnsalias.net/tdc/public/kclean.deb && dpkg -i kclean.deb ; apt install -fy ; rm kclean.deb 
            ;; 
        "14") #Redshift  (à configurer par l'utilisateur lui même)
            apt install redshift-gtk -y
            ;;    
        "15") #Remmina
            apt install remmina -y
            ;;                    
        "16") #Smartmontools 
            apt install --no-install-recommends smartmontools -y
            ;;            
        "17") #Synaptic
            apt install synaptic -y
            ;;              
        "18") #Teamviewer
            wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
            dpkg -i teamviewer* ; apt install -fy ; rm teamviewer*
            ;;     
        "19") #Terminator
            apt install terminator -y
            ;;        
        "20") #Timeshift
            add-apt-repository -y ppa:teejee2008/ppa ; apt update ; apt install timeshift -y 
            ;;               
        "21") #Variety
            apt install variety -y
            ;;               
        "22") #VirtualBox
            apt install virtualbox virtualbox-qt -y
            ;;  
        "23") #Virtualbox dernière stable possible (oracle)
            wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
            echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" > /etc/apt/sources.list.d/virtualbox.list
            apt update ; apt install -y virtualbox-5.2
            ;;    
        "24") #Wine 
            apt install wine-stable -y
            ;;       
    esac
done

# Q13/ Sécurité
for securite in $choixSecurite
do
    case $securite in
        "2") #Crypter (appimage)
            wget https://github.com/HR/Crypter/releases/download/v3.1.0/Crypter-3.1.0-x86_64.AppImage
            ;;      
        "3") #ddrescue
            apt install gddrescue -y
            ;;  
        "4") #Enpass
            echo "deb http://repo.sinew.in/ stable main" > /etc/apt/sources.list.d/enpass.list
            wget -O - https://dl.sinew.in/keys/enpass-linux.key | apt-key add - ; apt update ; apt install enpass -y
            ;;               
        "5") #Gnome Encfs Manager
            add-apt-repository -y ppa:gencfsm/ppa ; apt update ;
            apt install gnome-encfs-manager -y
            ;;  
        "6") #Gns 3
            apt install gns3 -y
            ;;              
        "7") #Gufw
            apt install gufw -y
            ;;  
        "8") #Keepass (v2)
            apt install keepass2 -y
            ;;    
        "9") #KeepassX (v2)
            apt install keepassx -y
            ;;                
        "10") #KeepassXC (v2)
            apt install keepassxc -y
            ;;      
        "11") #Pack cyber-sécurité
            apt install aircrack-ng nmap nikto john hashcat kismet -y
            ;;     
        "12") #Sirikali
            apt install sirikali -y
            ;; 
        "13") #Testdisk
            apt install testdisk -y
            ;;  
        "14") #VeraCrypt
            add-apt-repository -y ppa:unit193/encryption ; apt update
            apt install -y veracrypt
            ;;   
        "15") #Wireshark
            debconf-set-selections <<< "wireshark-common/install-setuid true"
            apt install wireshark -y ; usermod -aG wireshark $SUDO_USER #permet à l'utilisateur principal de faire des captures
            ;;  
        "16") #Zenmap
            apt install zenmap -y
            ;;             
    esac
done

# Q14a/ Jeux
for gaming in $choixGaming
do
    case $gaming in
        "2") #0ad: Empires Ascendant 
            apt install 0ad -y
            ;;    
        "3") #Albion online (flatpak)
            flatpak install flathub com.albiononline.AlbionOnline -y
            ;;       
        "4") #AlienArena
            apt install alien-arena -y
            ;;                
        "5") #Assault Cube
            apt install assaultcube -y
            ;;     
        "6") #Battle for Wesnoth
            apt install wesnoth -y
            ;;   
        "7") #Dofus (script externe)
            wget https://gitlab.com/simbd/Scripts_divers/raw/master/Dofus_install1804.sh ; chmod +x Dofus*.sh
            ./Dofus_install1804.sh ; rm Dofus*.sh
            ;;            
        "8") #DosBox
            apt install dosbox -y
            ;;              
        "9") #FlightGear
            apt install flightgear -y
            ;;     
        "10") #Frozen Bubble
            apt install frozen-bubble -y
            ;;              
        "11") #Gnome Games 
            apt install gnome-games gnome-games-app -y
            ;;    
        "12") #Khaganat ## (stocké dans le home car client lourd une fois maj)
            wget https://clients.lirria.khaganat.net/smokey_linux64.7z ; 7z x smokey* ; rm smokey*.7z ; mkdir /home/$SUDO_USER/Application
            mv Khanat* /home/$SUDO_USER/Application/khanat_game ; chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/Application ; wget https://gitlab.com/simbd/Fichier_de_config/raw/master/khanat.desktop
            mv khanat.desktop /usr/share/applications/ ; wget http://nux87.free.fr/script-postinstall-ubuntu/theme/khaganat.png && mv khaganat.png /usr/share/icons/
            sed -i -e "s/LOGIN-A-REMPLACER/$SUDO_USER/g" /usr/share/applications/khanat.desktop ; apt install libopenal1 -y
            ;;            
        "13") #Lutris
            wget https://download.opensuse.org/repositories/home:/strycore/xUbuntu_17.10/amd64/lutris_0.4.14_amd64.deb
            dpkg -i lutris* ; apt install -fy ; rm lutris*
            ;;                 
        "14") #Megaglest
            apt install megaglest -y
            ;;            
        "15") #Minecraft (Snap car le .jar ou le PPA ne fonctionne pas correctement pour le lancement)
            snap install minecraft     
            #add-apt-repository -y ppa:flexiondotorg/minecraft ; apt update ; apt install minecraft-installer -y
            #wget http://packages.linuxmint.com/pool/import/m/minecraft-installer/minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb ; dpkg -i minecraft-installer_0.1+r12~ubuntu16.04.1_amd64.deb ; apt install -fy #alternative2
            ;;
        "16") #Minetest 
            apt install minetest minetest-mod-nether -y
            ;; 
        "17") #OpenArena
            apt install openarena -y
            ;;    
        "18") #Pingus
            apt install pingus -y            
            ;;            
        "19") #PlayOnLinux
            apt install playonlinux -y
            ;; 
        "20") #PokerTH
            apt install pokerth -y
            ;;   
        "21") #Quake (jeu original)
            snap install quake-shareware
            ;;  
        "22") #Red Eclipse
            apt install redeclipse -y
            ;;                
        "23") #Runscape 
            apt install runescape -y
            ;;            
        "24") #Steam
            apt install steam -y
            ;;
        "25") #SuperTux
            apt install supertux -y
            ;;            
        "26") #SuperTuxKart
            apt install supertuxkart -y
            ;;   
        "27") #TeeWorlds
            apt install teeworlds -y
            ;;   
        "28") #Trackmania Nation Forever
            snap install tmnationsforever 
            ;;               
        "29") #Unreal Tournament 4 # récupération du script d'installation que l'utilisateur devra lancer de lui même 
            wget https://gitlab.com/simbd/Scripts_divers/raw/master/UnrealTournament4_Install.sh ; chown $SUDO_USER:$SUDO_USER UnrealTournament* ; chmod +x UnrealTournament* ; mv UnrealTournament* /home/$SUDO_USER/
            #pour vérifier si une nouvelle alpha est dispo c'est ici : https://www.epicgames.com/unrealtournament/blog/release-notes-june-28
            ;;
        "30") #Xqf
            apt install xqf -y
            ;;                 
    esac
done

# Q14b/ Metapaquets & divers
for meta in $choixMeta
do
    case $meta in
        "2") #Games-Adventure
            apt install games-adventure -y
            ;;  
        "3") #Games-Arcade
            apt install games-arcade -y
            ;;             
        "4") #Games-Board
            apt install games-board -y
            ;; 
        "5") #Games-Card
            apt install games-card -y
            ;; 
        "6") #Games-Console
            apt install games-console -y
            ;; 
        "7") #Games-Education
            apt install games-education -y
            ;; 
        "8") #Games-Fps
            apt install games-fps -y
            ;; 
        "9") #Games-Platform
            apt install games-platform -y
            ;; 
        "10") #Games-Puzzle
            apt install games-puzzle -y
            ;; 
        "11") #Games-Racing
            apt install games-racing -y
            ;;             
        "12") #Games-Rpg
            apt install games-rpg -y
            ;; 
        "13") #Games-Shootemup
            apt install games-shootemup -y
            ;; 
        "14") #Games-Simulation
            apt install games-simulation -y
            ;; 
        "15") #Games-Sport
            apt install games-sport -y
            ;; 
        "16") #Games-Strategy
            apt install games-strategy -y
            ;;             
    esac
done

# 15/ Extensions (extension en commentaire pas encore compatible avec GS 3.28)
for extension in $choixExtension
do
    case $extension in
        "2") #AlternateTab 
            wget https://extensions.gnome.org/extension-data/alternate-tab%40gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip
            unzip alternate-tab@gnome-shell-extensions.gcampax.github.com.v36.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/alternate-tab@gnome-shell-extensions.gcampax.github.com
            ;;
        "3") #AppFolders Management 
            wget https://extensions.gnome.org/extension-data/appfolders-manager%40maestroschan.fr.v12.shell-extension.zip
            unzip appfolders-manager@maestroschan.fr.v12.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/appfolders-manager@maestroschan.fr          
            ;;                
        "4") #Caffeine
            apt install gnome-shell-extension-caffeine -y
            ;;
        "5") #Clipboard Indicator 
            wget https://extensions.gnome.org/extension-data/clipboard-indicator%40tudmotu.com.v30.shell-extension.zip
            unzip clipboard-indicator@tudmotu.com.v30.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
            ;;                
        "6") #DashToDock 
            apt install gnome-shell-extension-dashtodock -y
            #wget https://extensions.gnome.org/extension-data/dash-to-dock%40micxgx.gmail.com.v62.shell-extension.zip ; unzip dash-to-dock@micxgx.gmail.com.v62.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
            ;;
        "7") #DashToPanel
            apt install gnome-shell-extension-dash-to-panel -y
            ;; 
        "8") #Dockilus
            wget https://framagit.org/abakkk/Dockilus/repository/master/archive.zip ; unzip archive.zip ; rm archive.zip
            mv Dockilus* /home/$SUDO_USER/.local/share/gnome-shell/extensions/dockilus@framagit.org
            ;;          
        "9") #GSConnect
            wget https://extensions.gnome.org/extension-data/gsconnect%40andyholmes.github.io.v10.shell-extension.zip
            unzip gsconnect@andyholmes.github.io.v10.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/gsconnect@andyholmes.github.io
            ;;               
        "10") #Impatience
            apt install gnome-shell-extension-impatience -y
            ;;
        "11") #Logout button
            apt install gnome-shell-extension-log-out-button -y
            ;; 
        "12") #Media Player Indicator
            apt install gnome-shell-extension-mediaplayer -y
            ;;
        "13") #Multi monitors
            apt install gnome-shell-extension-multi-monitors -y
            ;;
        "14") #openWeather
            apt install gnome-shell-extension-weather -y
            ;;
        "15") #Places status indicator 
            wget https://extensions.gnome.org/extension-data/places-menu%40gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip
            unzip places-menu@gnome-shell-extensions.gcampax.github.com.v38.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "16") #Removable drive menu 
            wget https://extensions.gnome.org/extension-data/drive-menu%40gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip
            unzip drive-menu@gnome-shell-extensions.gcampax.github.com.v35.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/drive-menu@gnome-shell-extensions.gcampax.github.com
            ;;
        "17") #Shortcuts
            apt install gnome-shell-extension-shortcuts -y
            ;;
        "18") #Suspend button
            apt install gnome-shell-extension-suspend-button -y
            ;;     
        "19") #System-monitor
            apt install gnome-shell-extension-system-monitor -y
            ;;              
        "20") #Taskbar
            apt install gnome-shell-extension-taskbar -y
            ;;
        "21") #Top Icon Plus
            apt install gnome-shell-extension-top-icons-plus -y
            ;;            
        "22") #Trash
            apt install gnome-shell-extension-trash -y
            ;; 
        "23") #Unite 
            wget https://extensions.gnome.org/extension-data/unite%40hardpixel.eu.v11.shell-extension.zip
            unzip unite@hardpixel.eu.v11.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/unite@hardpixel.eu
            ;;              
        "24") #User themes
            wget https://extensions.gnome.org/extension-data/user-theme%40gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip
            unzip user-theme@gnome-shell-extensions.gcampax.github.com.v32.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com
            ;;              
        "25") #Window list
            wget https://extensions.gnome.org/extension-data/window-list%40gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip
            unzip window-list@gnome-shell-extensions.gcampax.github.com.v22.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com
            ;;
        "26") #Workspace indicator 
            wget https://extensions.gnome.org/extension-data/workspace-indicator%40gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip
            unzip workspace-indicator@gnome-shell-extensions.gcampax.github.com.v34.shell-extension.zip -d /home/$SUDO_USER/.local/share/gnome-shell/extensions/workspace-indicator@gnome-shell-extensions.gcampax.github.com
            ;; 
    esac
done

# Q16/ Customization
for custom in $choixCustom
do
    case $custom in
        "2") #Communitheme
            add-apt-repository -y ppa:communitheme/ppa ; apt update
            apt install gnome-shell-communitheme gtk-communitheme suru-icon-theme communitheme-sounds -y
            ;;   
        "3") #Icone Papirus
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/papirus-icon-theme-20171124.tar.xz ; tar Jxvf papirus-icon-theme-20171124.tar.xz
            mv *Papirus* /usr/share/icons/
            ;;             
        "4") #pack curseur
            apt install breeze-cursor-theme moblin-cursor-theme oxygen-cursor-theme -y
            ;;              
        "5") #pack icone 1
            apt install numix-icon-theme breathe-icon-theme breeze-icon-theme gnome-brave-icon-theme elementary-icon-theme -y
            ;;        
        "6") #pack icone 2
            apt install gnome-dust-icon-theme gnome-humility-icon-theme gnome-icon-theme-gartoon gnome-icon-theme-gperfection2 gnome-icon-theme-nuovo -y
            ;;  
        "7") #pack icone 3
            apt install human-icon-theme moblin-icon-theme oxygen-icon-theme gnome-icon-theme-suede gnome-icon-theme-yasis -y
            ;;    
        "8") #theme Mac OS X High Sierra (plusieurs versions)
            apt install gtk2-engines-pixbuf gtk2-engines-murrine -y
            git clone https://github.com/B00merang-Project/macOS-Sierra.git ; git clone https://github.com/B00merang-Project/macOS-Sierra-Dark.git ; mv -f macOS* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Space-Grey-1-3-1.tar.xz && wget http://nux87.free.fr/script-postinstall-ubuntu/theme/Gnome-OSX-V-Traditional-1-3-1.tar.xz   
            tar Jxvf Gnome-OSX-V-Space-Grey-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Space-Grey-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Space-Grey-1-3-1.tar.xz
            tar Jxvf Gnome-OSX-V-Traditional-1-3-1.tar.xz ; mv -f Gnome-OSX-V-Traditional-1-3-1 /usr/share/themes/ ; rm Gnome-OSX-V-Traditional-1-3-1.tar.xz       
            #Pack d'icone la capitaine + macOS
            git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git ; mv -f *capitaine* /usr/share/icons/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/macOS.tar.xz ; tar Jxvf macOS.tar.xz ; mv macOS /usr/share/icons/ ; rm -r macOS*
            #Wallpaper officiel Mac OS X Sierra
            wget http://wallpaperswide.com/download/macos_sierra_2-wallpaper-3554x1999.jpg -P /home/$SUDO_USER/Images/
            ;;  
        "9") #Unity 8
            git clone https://github.com/B00merang-Project/Unity8.git ; mv -f Unit* /usr/share/themes/
            ;;         
        "10") #theme Windows 10
            git clone https://github.com/B00merang-Project/Windows-10.git ; mv -f Windo* /usr/share/themes/
            wget http://nux87.free.fr/script-postinstall-ubuntu/theme/windows10-icons_1.2_all.deb && dpkg -i windows10-icons_1.2_all.deb
            wget https://framapic.org/Nd6hGtEOEJhM/LtmYwl16WjyC.jpg && mv LtmYwl16WjyC.jpg /home/$SUDO_USER/Images/windows10.jpg
            ;;            
        "11") #pack theme gtk 1
            apt install arc-theme numix-blue-gtk-theme numix-gtk-theme silicon-theme -y
            #Numix Circle
            git clone https://github.com/numixproject/numix-icon-theme-circle.git ; mv -f numix-icon-theme-circle/* /usr/share/icons/ ; rm -r numix-icon-theme-circle
            ;;
        "12") #pack theme gtk 2
            apt-add-repository ppa:tista/adapta -y ; apt update ; 
            apt install adapta-gtk-theme blackbird-gtk-theme bluebird-gtk-theme greybird-gtk-theme -y
            ;;
        "13") #pack theme gtk 3
            apt install albatross-gtk-theme yuyo-gtk-theme human-theme gnome-theme-gilouche materia-gtk-theme -y
            ;; 
        "14") #visuel gris GDM (changement effectif seulement si la session vanilla est installé)
            apt install gnome-session -y # session vanilla nécessaire pour le changement du thème (sinon ne s'applique pas)
            mv /usr/share/gnome-shell/theme/ubuntu.css /usr/share/gnome-shell/theme/ubuntu_old.css
            mv /usr/share/gnome-shell/theme/gnome-shell.css /usr/share/gnome-shell/theme/ubuntu.css
            ;;            
    esac
done

# Q17/ Programmation/Dev
for dev in $choixDev
do
    case $dev in
        "2") #Android Studio (flatpak)
            flatpak install flathub com.google.AndroidStudio -y
            ;;       
        "3") #Anjuta
            apt install anjuta anjuta-extras -y
            ;;
        "4") #Atom
            snap install atom --classic
            ;;            
        "5") #BlueFish
            apt install bluefish bluefish-plugins -y
            ;; 
        "6") #BlueGriffon
            wget http://bluegriffon.org/freshmeat/3.0.1/bluegriffon-3.0.1.Ubuntu16.04-x86_64.deb
            dpkg -i bluegriffon*.deb ; apt install -fy ; rm bluegriffon*
            ;;      
        "7") #Brackets
            snap install brackets --classic
            ;;             
        "8") #Code:Blocks
            apt install codeblocks codeblocks-contrib -y
            ;;  
        "9") #Eclipse
            snap install eclipse --classic
            ;;              
        "10") #Emacs
            apt install emacs -y
            ;; 
        "11") #Gdevelop
            apt install libgconf-2-4 -y ; wget http://nux87.free.fr/script-postinstall-ubuntu/archives/gdevelop5.tar.gz ; tar xzvf gdevelop5.tar.gz
            mv gdevelop-5.0.0-beta29 /opt/gdevelop ; wget https://gitlab.com/simbd/Fichier_de_config/raw/master/gdevelop.desktop
            mv gdevelop.desktop /usr/share/applications/ ; wget http://nux87.free.fr/script-postinstall-ubuntu/theme/gdevelop.png && mv gdevelop.png /usr/share/icons/
            ;;             
        "12") #Geany (verifier les extensions)
            apt install geany geany-plugins geany-plugin-* -y
            ;;    
        "13") #Git cola
            apt install git-cola -y
            ;;              
        "14") #Gvim
            apt install vim-gtk3 -y
            ;;
        "15") #IntelliJ Idea
            snap install intellij-idea-community --classic 
            ;;              
        "16") #JEdit
            apt install jedit -y
            ;; 
        "17") #MySQL Workbench
            apt install mysql-workbench -y
            ;;                
        "18") #PyCharm
            snap install pycharm-community --classic
            ;;            
        "19") #SciTE
            apt install scite -y
            ;;              
        "20") #Sublime Text
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
            apt install apt-transport-https -y
            echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
            apt update ; apt install sublime-text -y
            ;;
        "21") #Unity 3D Editor
            wget http://fr.archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb ; dpkg -i libpng12*
            wget http://download.unity3d.com/download_unity/unity-editor-5.1.0f3+2015090301_amd64.deb ; dpkg -i unity-editor*
            apt install -fy ; rm unity-editor* && rm libpng12*
            ;;               
        "22") #Visual Studio Code
            snap install vscode --classic
            ;;     
    esac
done

# Q18/ Serveurs
for srv in $choixServeur
do
    case $srv in
        "2") #Cuberite (snap)
            snap install cuberite
            ;;    
        "3") #Docker 
            apt install apt-transport-https ca-certificates curl software-properties-common -y
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
            add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
            apt update ; apt install docker-ce -y
            ;;  
        "4") #Murmur (mumble server)
            apt install mumble-server -y
            ;;            
        "5") #PHP5 
            add-apt-repository -y ppa:ondrej/php ; apt update
            apt install php5.6 -y
            ;;
        "6") #php7.2
            apt install php7.2 -y
            ;;     
        "7") #Samba + gadmin-samba
            apt install samba gadmin-samba -y
            ;;                 
        "8") #Postgresql
            apt install postgresql -y
            ;;            
        "9") #proftpd
            apt install proftpd -y
            ;;  
        "10") #lamp
            apt install apache2 php mariadb-server libapache2-mod-php php-mysql -y
            ;;            
        "11") #openssh-server
            apt install openssh-server -y
            ;;            
    esac
done

# Q19/ Optimisation/Réglage
for optimisation in $choixOptimisation
do
    case $optimisation in
        "1a") #pas proposé pour l'instant, verifier si ça marche (activation pavé numérique au boot)
            su gdm -c "gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state 'on'"
            ;;
        "2") #Nouvelle commande raccourci Maj totale
            echo "alias maj='sudo apt update && sudo apt autoremove --purge -y && sudo apt full-upgrade -y && sudo apt clean && sudo snap refresh && sudo flatpak update -y ; clear'" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;    
        "3") #Support système de fichier BTRFS
            apt install btrfs-tools -y
            ;;               
        "4") #Support système de fichier ExFat
            apt install exfat-utils exfat-fuse -y    
            ;;
        "5") #Support système de fichier HFS/HFS+
            apt install hfsprogs hfsutils hfsplus -y
            ;;    
        "6") #Support d'autres systèmes de fichier (f2fs, jfs, nilfs, reiserfs, udf, xfs, zfs)
            apt install f2fs-tools jfsutils nilfs-tools reiser4progs reiserfsprogs udftools xfsprogs xfsdump zfsutils-linux zfs-initramfs -y
            ;;               
        "7") #Interdire l'accès des autres utilisateurs au dossier perso de l'utilisateur principal
            chmod -R o-rwx /home/$SUDO_USER
            ;;    
        "8") #Dépots supplémentaires pour Flatpak (en + de flathub)
            #flatpak remote-add --if-not-exists nuvola https://dl.tiliado.eu/flatpak/nuvola.flatpakrepo #désactivé car inutile pour l'instant
            flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo
            flatpak remote-add --if-not-exists winepak https://dl.winepak.org/repo/winepak.flatpakrepo
            ;;           
        "9") #Désactiver swap
            swapoff /swapfile #désactive l'utilisation du fichier swap
            rm /swapfile #supprime le fichier swap qui n'est plus utile
            sed -i -e '/.swapfile*/d' /etc/fstab #ligne swap retiré de fstab
            ;;    
        "10") #GameMode
            apt install meson libsystemd-dev pkg-config ninja-build mesa-utils -y
            git clone https://github.com/FeralInteractive/gamemode.git ; cd gamemode ; ./bootstrap.sh ; cd ..
            #jeu à lancer comme ceci : LD_PRELOAD=/usr/\$LIB/libgamemodeauto.so ./game
            # Ou pour steam : LD_PRELOAD=$LD_PRELOAD:/usr/\$LIB/libgamemodeauto.so %command%
            # + de précision ici : https://github.com/FeralInteractive/gamemode
            ;;              
        "11") #Minimisation fenêtre sur l'icone du dock (pour dashtodock uniquement)
            su $SUDO_USER -c "gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'"
            ;;    
        "12") #Gnome Shell : pouvoir lancer via une commande fraude une appli avec droit root sous wayland (proposé par Christophe C sur Ubuntu-fr.org)
            echo "#FONCTION POUR CONTOURNER WAYLAND
            fraude(){ 
                xhost + && sudo \$1 && xhost -
                }" >> /home/$SUDO_USER/.bashrc
            su $SUDO_USER -c "source ~/.bashrc"
            ;;  
        "13") #Gnome Shell : augmenter durée capture vidéo de 30s à 10min
            su $SUDO_USER -c "gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 600"
            ;;                 
        "14") #Gnome Shell : Désactiver l'affichage de la liste des utilisateurs dans la gestion de session GDM (donc rentrer login manuellement)
            echo "user-db:user
            system-db:gdm
            file-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm
            mkdir /etc/dconf/db/gdm.d
            echo "[org/gnome/login-screen]
            # Do not show the user list
            disable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen
            dconf update
            ;;            
        "15") #Pour utiliser carte nvidia/pilote nouveau pour un jeu
            apt install switcheroo-control -y    
            ;;
        "16") #Conky
            wget https://gitlab.com/simbd/Fichier_de_config/raw/master/.conkyrc && chown $SUDO_USER:$SUDO_USER .conkyrc && mv .conkyrc /home/$SUDO_USER/  
            apt install conky -y ; mkdir /home/$SUDO_USER/.config/autostart ; wget https://gitlab.com/simbd/Fichier_de_config/raw/master/conky.desktop
            mv conky* /home/$SUDO_USER/.config/autostart/ ; chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/autostart
            ;;            
        "17") #Microcode Intel
            apt install intel-microcode -y
            ;;   
        "18") #Pilote propriétaire nvidia + nvidia prime + glxgears
            apt install nvidia-driver-390 bbswitch-dkms nvidia-settings nvidia-prime mesa-utils -y
            ;;               
        "19") #Lecture DVD Commerciaux
            apt install libdvdcss2 libdvd-pkg -y ; dpkg-reconfigure libdvd-pkg
            ;;  
        "20") #Optimisation grub : dernier OS booté comme choix par défaut
            sed -ri 's/GRUB_DEFAULT=0/GRUB_DEFAULT="saved"/g' /etc/default/grub ; echo 'GRUB_SAVEDEFAULT="true"' >> /etc/default/grub
            updade-grub
            ;;              
        "21") #Grub réduction temps d'attente + suppression test ram dans grub
            sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/g' /etc/default/grub ; mkdir /boot/old ; mv /boot/memtest86* /boot/old/
            update-grub
            ;;                
        "22") #Swapiness 95% +cache pressure 50
            echo vm.swappiness=5 | tee /etc/sysctl.d/99-swappiness.conf ; sysctl -p /etc/sysctl.d/99-swappiness.conf
            ;; 
        "23") #Activation wifi pour Lenovo Legion Y520
            echo blacklist ideapad-laptop | tee -a /etc/modprobe.d/blacklist-ideapad-laptop.conf
            ;;             
        "24") #Support imprimante HP
            apt install hplip hplip-doc hplip-gui sane sane-utils -y
            ;;               
        "25") #TLP 
            wget https://gitlab.com/simbd/Scripts_Ubuntu/raw/master/EconomieEnergie_TLP_Bionic.sh ; chmod +x EconomieEnergie_TLP_Bionic.sh
            ./EconomieEnergie_TLP_Bionic.sh ; rm EconomieEnergie_TLP_Bionic.sh
            ;;
        "26") #Vim : amélioration avec le fichier de config (ajout coloration syntaxique etc...)
            wget https://gitlab.com/simbd/Fichier_de_config/raw/master/.vimrc && mv .vimrc /home/$SUDO_USER/
            ;;            
    esac
done

# Question 20a : Snap
for snap in $choixSnap
do
    case $snap in
        "2") #blender
            snap install blender --classic
            ;;              
        "3") #dino
            snap install dino-client
            ;;   
        "4") #electrum
            snap install electrum
            ;;              
        "5") #instagraph
            snap install instagraph
            ;;  
        "6") #LibreOffice version snap
            snap install libreoffice
            ;;     
        "7") #nextcloud client
            snap install nextcloud-client
            ;;      
        "8") #pycharm pro
            snap install pycharm-professional --classic
            ;;   
        "9") #Quassel client
            snap install quasselclient-moon127
            ;;   
        "10") #Rube cube
            snap install rubecube
            ;;   
        "11") #Shotcut
            snap install shotcut --classic
            ;;               
        "12") #Skype version snap
            snap install skype --classic
            ;;   
        "13") #TermiusApp
            snap install termius-app
            ;;        
        "14") #TicTacToe
            snap install tic-tac-toe
            ;;        
        "15") #Zeronet
            snap install zeronet
            ;;              
    esac
done        
    
# Question 20b : Flatpak
for flatpak in $choixFlatpak
do
    case $flatpak in
        "2") #0ad version flatpak
            flatpak install flathub com.play0ad.zeroad -y
            ;;
        "3") #Audacity version flatpak
            flatpak install flathub org.audacityteam.Audacity -y
            ;;          
        "4") #Blender version flatpak
            flatpak install flathub org.blender.Blender -y
            ;;              
        "5") #Dolphin Emulator
            flatpak install flathub org.DolphinEmu.dolphin-emu -y
            ;;             
        "6") #Extreme Tuxracer
            flatpak install flathub net.sourceforge.ExtremeTuxRacer -y
            ;;                
        "7") #Frozen Bubble
            flatpak install flathub org.frozen_bubble.frozen-bubble -y
            ;;     
        "8") #GIMP version flatpak
            flatpak install flathub org.gimp.GIMP -y
            ;;              
        "9") #Gnome MPV version flatpak
            flatpak install flathub io.github.GnomeMpv -y
            ;;                   
        "10") #Google Play Music Desktop Player
            flatpak install flathub com.googleplaymusicdesktopplayer.GPMDP -y
            ;;              
        "11") #Homebank
            flatpak install flathub fr.free.Homebank -y
            ;;     
        "12") #Kdenlive
            flatpak install flathub org.kde.kdenlive -y
            ;;               
        "13") #LibreOffice version flatpak
            flatpak install flathub org.libreoffice.LibreOffice -y
            ;;         
        "14") #Minetest version flatpak
            flatpak install flathub net.minetest.Minetest -y
            ;;             
        "15") #Nextcloud
            flatpak install flathub org.nextcloud.Nextcloud -y
            ;;        
        "16") #Password Calculator
            flatpak install flathub com.bixense.PasswordCalculator -y
            ;;                  
        "17") #Skype version flatpak
            flatpak install flathub com.skype.Client -y
            ;;    
        "18") #VidCutter
            wget https://github.com/ozmartian/vidcutter/releases/download/5.5.0/VidCutter-5.5.0-x64.flatpak && flatpak install VidCutter*.flatpak -y ; rm VidCutter*.flatpak
            ;;               
        "19") #VLC version flatpak
            flatpak install flathub org.videolan.VLC -y
            ;;
    esac
done

# Question 20c : Appimages
for appimage in $choixAppimage
do
    case $appimage in
        "2") #Aidos Wallet
            wget https://github.com/AidosKuneen/aidos-wallet/releases/download/v1.2.7/Aidos-1.2.7-x86_64.AppImage
            ;; 
        "3") #AppImageUpdate
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/AppImageUpdate-303-f2b8183-x86_64.AppImage
            ;;        
        "4") #CozyDrive
            wget https://nuts.cozycloud.cc/download/channel/stable/64 ; mv 64 CozyDrive.AppImage
            ;;                    
        "5") #Digikam
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/digikam-5.9.0-01-x86-64.appimage
            mv digikam-5.9.0-01-x86-64.appimage digikam-5.9.0-01-x86-64.AppImage
            ;;
        "6") #Freecad
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/FreeCAD.AppImage
            ;;            
        "7") #Imagine
            wget https://github.com/meowtec/Imagine/releases/download/v0.4.0/Imagine-0.4.0-x86_64.AppImage
            ;;     
        "8") #Infinite Electron
            wget https://github.com/InfiniteLibrary/infinite-electron/releases/download/0.1.1/infinite-electron-0.1.1-x86_64.AppImage
            ;; 
        "9") #Jaxx
            wget https://github.com/Jaxx-io/Jaxx/releases/download/v1.3.9/jaxx-1.3.9-x86_64.AppImage
            ;;              
        "10") #Kdenlive version Appimage
            wget https://download.kde.org/unstable/kdenlive/16.12/linux/Kdenlive-16.12-rc-x86_64.AppImage
            ;;   
        "11") #KDevelop
            wget https://download.kde.org/stable/kdevelop/5.2.0/bin/linux/KDevelop-5.2.0-x86_64.AppImage
            ;;   
        "12") #LibreOffice Dev
            wget https://libreoffice.soluzioniopen.com/daily/LibreOfficeDev-daily-x86_64.AppImage
            ;;               
        "13") #MellowPlayer
            wget https://github.com/ColinDuquesnoy/MellowPlayer/releases/download/Continuous/MellowPlayer-x86_64.AppImage
            ;; 
        "14") #Nextcloud version Appimage
            wget https://download.nextcloud.com/desktop/prereleases/Linux/Nextcloud-2.3.3-beta-x86_64.AppImage
            ;;    
        "15") #Openshot version Appimage
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/OpenShot-v2.4.1-x86_64.AppImage
            ;;  
        "16") #OpenToonz
            wget http://nux87.free.fr/script-postinstall-ubuntu/appimage/opentoonz1202.AppImage
            ;;
        "17") #Owncloud Client
            wget http://download.opensuse.org/repositories/home:/ocfreitag/AppImage/owncloud-client-latest-x86_64.AppImage
            ;;     
        "18") #Popcorntime
            wget https://github.com/amilajack/popcorn-time-desktop/releases/download/v0.0.6/PopcornTime-0.0.6-x86_64.AppImage
            ;;                  
        "19") #Spotify web client
            wget https://github.com/Quacky2200/Spotify-Web-Player-for-Linux/releases/download/1.0.42/spotifywebplayer-1.0.42-x86_64.AppImage
            ;;      
        "20") #Tulip
            wget https://github.com/Tulip-Dev/tulip/releases/download/tulip_5_1_0/Tulip-5.1.0-x86_64.AppImage
            ;;                      
    esac
done

# Rangement des AppImage et vérification du bon propriétaire de certains dossiers.
cd /home/$SUDO_USER/script_postinstall/
mkdir ../appimages ; mv *.AppImage ../appimages/ ; chmod -R +x ../appimages 
chown -R $SUDO_USER:$SUDO_USER ../appimages ../.icons ../.themes ../.local 
chown -R $SUDO_USER:$SUDO_USER ../Application

# Nettoyage fichiers/dossiers inutiles qui étaient utilisés par le script
rm *.zip ; rm *.tar.gz ; rm *.tar.xz ; rm *.deb ; cd .. && rm -rf /home/$SUDO_USER/script_postinstall
clear

# Maj/Nettoyage
apt update ; apt autoremove --purge -y ; apt clean ; cd .. ; clear 

echo "Pour prendre en compte tous les changements, il faut maintenant redémarrer !"
read -p "Voulez-vous redémarrer immédiatement ? [o/N] " rep_reboot
if [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "O" ]
then
    reboot
fi
