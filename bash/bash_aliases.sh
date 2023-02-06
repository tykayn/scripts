# these bash aliases are meant to be added in your user folder,
# in a file named: .bash_aliases (with the dot at the beginning)
# done for my blog http://www.cipherbliss.com
#!/bin/bash
# these bash aliases are meant to be added in your user folder,
# in a file named: .bash_aliases (with the dot at the beginning)
# done for my blog http://www.cipherbliss.com

############################ current

	alias work='cd ~/www/funky-framadate-front \ 
nvm use 16 && yarn start'
########## lieux ###########
  alias goserv='ssh monUtilisateur@monServeur.com/var/www/html'; # customise this one!
	alias dok="docker-compose"
	alias doc="dok"
	alias goc="cd /media/tykayn/catwoman"
	
###### lieux locaux
	alias gok='ssh tykayn@5.196.69.85'
	alias goj='ssh -p 3910 tykayn@bbb.liness.org'
	alias syncnas='export RSYNC_PASSWORD="blah_blah_blah" && rsync -avP --delete "$USER@192.168.1.8:/volume1/bidules_partagés/videos/*" /home/poule/medias/videos'
	alias findup='cd && sudo /usr/share/fslint/fslint/findup |grep a_ranger > duplicates_a_ranger.txt'
	alias netre='sudo service network-manager restart'
	alias dc='docker-compose'
	alias goa='ssh root@biliz.cluster.chapril.org'
	alias goo='cd ~/Nextcloud/textes/orgmode'
################ symfony3 ######################
  alias sf='php bin/console';
  alias sfdsu='sf doctrine:schema:update --dump-sql';
  alias sfdsuf='sf doctrine:schema:update --force';
  alias sfcc='sf cache:clear';
  alias sfdcc='sf doctrine:cache:clear-metadata && sf doctrine:cache:clear-query && sf doctrine:cache:clear-result ';
  alias sfdge='sf doctrine:generate:entities';
  alias sfdsv='sf doctrine:schema:validate';
  alias sfdges='sf doctrine:generate:entities';
  alias sffuc='sf fos:user:change-password';
  alias c7='sudo chmod 777 -R';
  alias ptest='phpunit -c app';
  alias composer='/usr/local/bin/composer.phar';
  alias sfad='sf assetic:dump';
  alias sfai='sf assets:install';
  alias yre='yarn run encore --dev';
  alias yrep='yarn run encore --production';

################ system without graphic interface - command line ################
	alias basha='nano ~/.bash_aliases'; # éditer les alisas
	alias bashare='source ~/.bash_aliases'; # recharger les alias
	alias ainstall='sudo apt-get install'; # installer un programme
	alias apachere='sudo /etc/init.d/apache2 restart'; # apache restart
	alias apacheconf='sudo nano /etc/apache2/apache2.conf'; # fichier de config apache2
	alias phpini='sudo nano /etc/php8/apache2/php.ini'; # fichier de config de php8
	alias tfa='tail -f /var/log/nginx/*.log'; # suivi des erreurs apache
	alias aupg='sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get update -y && sudo apt-get upgrade -y';

################ système with X server ################
	alias phpini='sudo gedit /etc/php8/apache2/php.ini';

################ git helpers ################
	alias gci='git commit';
	alias gco='git checkout';
	alias gst='git status';
	alias gbr='git branch';
	alias gpull='git pull';
	alias gpush='git push';
	alias gpoush='git push'; # for slipping fingers
	alias glg='git log --pretty=oneline';
	alias myglg='git log --pretty=oneline --author=tykayn'; # log pour seulement mes commits, utile pour un stand up de  projet Agile
	alias gaci='git add . --all && git commit -m '; # ajouter sans les tests js, donnez le message du commit entre guillemets suite à cette commande
	alias gacio='goo && git add . --all && git commit -m "update orgmode files" && cd -'
	alias gaaci='git add . --all && git commit -m '; # ajouter sans les tests js
	alias mysr='mysql -uroot -p';
################ other helpers
	alias hgrep="history |grep"
	alias whatport="sudo netstat -pna | grep "
	alias runport="firefox https://localhost:$1"

export RUBY_ENV=devlopment
#cd /media/tykayn/catwoman/stockage-syncable
export GIT_AUTHOR_NAME="Tykayn";
export GIT_AUTHOR_EMAIL="contact@cipherbliss.com";

#export BORG_PASSCOMMAND="cat ~/.borg-passtk4to"
export NVM_DIR="$HOME/.nvm"

alias python=python3
alias py=python3
alias ydl="yt-dlp -o '%(title)s.f%(format_id)s.%(ext)s' "
alias ydla="yt-dlp -o '%(title)s.f%(format_id)s.%(ext)s' "
alias oklm="killall gajim telegram-desktop signal-desktop dino-im"



# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
	alias ll='ls -alF'
	alias la='ls -A'
	#alias l='ls -CF'
	alias l="exa -lh --git --all"

nvm use 16
node --version


export PATH=~/.local/bin:$PATH
export PATH="$HOME/.emacs.d/bin:$HOME/.symfony/bin:$PATH"
CURRENT_YEAR="2022"
# fix mastodon development
# export LD_PRELOAD=libjemalloc.so
export RAILS_ENV=development

########## ---------------- syncro disks ------------------------------------------------------ ##########
echo "load functions to sync files"
source ~/Nextcloud/ressources/workflow_nextcloud/functions_sync.sh

# ----------------------------------------------------------------------

export HISTTIMEFORMAT="%d/%m/%y %T "
export EDITOR=nano
export HUGO_BASE_DIR="~/Nextcloud/textes/hugo"
export PATH=/snap/bin:$PATH


# gestion elixir version ASDF
. ~/.asdf/asdf.sh