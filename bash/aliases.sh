# these bash aliases are meant to be added in your user folder,
# in a file named: .bash_aliases (with the dot at the beginning)
# done for my blog http://www.cipherbliss.com

########## lieux ###########
        alias goserv='ssh monUtilisateur@monServeur.com/var/www/html'; # customise this one!
###### lieux locaux
        alias gowork='cd /var/www/html/MON-PROJET-EN-COURS'; # customise this one!
        alias gowww='cd /var/www/html'
################ symfony3 ######################
        alias sf='php bin/console';
        alias sfdsu='sf doctrine:schema:update --dump-sql';
        alias sfdsuf='sf doctrine:schema:update --force';
        alias sfcc='rm -rf app/cache/* && rm -rf app/logs/*';
        alias sfdcc='sf doctrine:cache:clear-metadata && sf doctrine:cache:clear-query && sf doctrine:cache:clear-result ';
        alias sfdge='sf doctrine:generate:entities Tykayn';
        alias sfdsv='sf doctrine:schema:validate';
        alias sfdges='sf doctrine:generate:entities Tykayn';
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
	alias phpini='sudo nano /etc/php5/apache2/php.ini'; # fichier de config de php5
	alias tfa='tail -f /var/log/apache2/error.log'; # suivi des erreurs apache
	alias aupg='apt-get update && apt-get upgrade';

################ système with X server ################
	alias phpini='sudo gedit /etc/php5/apache2/php.ini';

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
	alias gaci='git add . --all && git reset -- *.spec.js && git commit -m '; # ajouter sans les tests js, donnez le message du commit entre guillemets suite à cette commande
    	alias gaaci='git add . --all && git commit -m '; # ajouter sans les tests js

################ other helpers
	alias hgrep="history |grep"
