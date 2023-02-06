#!/bin/sh

/usr/bin/gnome-terminal \
    --geometry=73x5+330+5  \
    --hide-menubar \
    -x $HOME/areas/www/misc/novoid/filetags/__init__.py --interactive "${@}"

#end
