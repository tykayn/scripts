#!/bin/bash

# titre du terminal personnalisé
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
# prompt personnalisé fait avec http://bashrcgenerator.com/
export PS1="\[\033[38;5;214m\]\T\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;192m\]\u\[$(tput sgr0)\]\[\033[38;5;42m\]@\[$(tput sgr0)\]\[\033[38;5;84m\]\h\[$(tput sgr0)\]\[\033[38;5;70m\]:\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"