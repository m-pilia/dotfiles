#!/usr/bin/env bash
# shellcheck disable=2155

if command -v stack > /dev/null; then
	eval "$(stack --bash-completion-script stack)"
fi

if command -v pipenv > /dev/null; then
	eval "$(pipenv --completion)"
fi

if command -v ssh-agent > /dev/null; then
    ensure_ssh_agent
fi

if [[ -n "${TMUX_DETECTED}" ]]; then
    export TERM=screen-256color
fi

if [[ -n "${WSL_DETECTED}" ]]; then
    export GPG_TTY=$(tty)
fi

# editor
if command -v nvim &> /dev/null ; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export VISUAL=$EDITOR
