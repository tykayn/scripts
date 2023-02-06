#!/bin/sh

/usr/bin/gnome-terminal \
    --geometry=73x5+330+5  \
    --hide-menubar \
    -x $HOME/.local/bin/appendfilename "${@}"

#end
