#!/usr/bin/env bash

# shellcheck disable=SC1090

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Ignore duplicates in history
export HISTCONTROL=ignoreboth:erasedups

_SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"

if [ "$(bash "${_SCRIPT_DIR}"/.local/bin/get_arch)" == Windows ] ; then
    # local binaries
    export PATH="${_SCRIPT_DIR}"/../third_party/_bin:$PATH

    # fzf
    export FZF_CTRL_R_OPTS='--no-height'
    source "${_SCRIPT_DIR}"/../third_party/fzf/shell/key-bindings.bash
    source "${_SCRIPT_DIR}"/../third_party/fzf/shell/completion.bash
else
    # shared config among different machines
    source ~/.local/share/shell_config/variables.sh
    source ~/.local/share/shell_config/aliases.sh

    # fzf
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi

unset _SCRIPT_DIR
