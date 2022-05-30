#Script d'install de Mastodon sur Ubuntu 18.04 
à lancer après une installation toute neuve d'ubuntu 18.04 server.

Cette install de Mastodon fonctionne avec Ruby, Nginx, NPM, yarn qui seront installés automatiquement si besoin
```bash
 
 && wget https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/mastodon/mastodon_install.sh \
  && chmod +x mastodon_install.sh
  && sudo bash mastodon_install.sh
```