#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# shared config among different machines
. ~/.shell_config/sh_variables.sh
. ~/.shell_config/sh_aliases.sh

PS1='[\u@\h \W]\$ '

# vi mode command line editing
#set -o vi

# fzf
. /usr/share/fzf/key-bindings.bash
. /usr/share/fzf/completion.bash

