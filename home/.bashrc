#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# shared config among different machines
source ~/.local/share/shell_config/variables.sh
source ~/.local/share/shell_config/aliases.sh

# fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

