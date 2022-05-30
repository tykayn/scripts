#Script de PostInstall 
à lancer après une installation toute neuve d'ubuntu 18.04 sur votre ordinateur portable.

```bash
mkdir script_postinstall \
 && cd script_postinstall \
 && wget https://gitlab.com/tykayn1/cipherbliss.com/raw/master/bash/postinstall/tykayn_postinstall.sh \
  && chmod +x tykayn_postinstall.sh
  && sudo bash tykayn_postinstall.sh
```

