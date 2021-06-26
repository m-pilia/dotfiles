#!/usr/bin/env bash
# shellcheck disable=2155,2006

# editor
if command -v nvim &> /dev/null ; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export VISUAL=$EDITOR

# local binaries
export PATH=~/.local/bin:$PATH

# personal scripts
export PATH=$PATH:~/Cryptbox/SW/bin/

if [[ -x "${SSH_SESSION_DETECTED:-}" ]] && [ "$(bc -l <<< "$(get_dpi) > 200")" -eq 1 ]; then
	# HiDPI support for QT applications (must be an integer)
	#export QT_DEVICE_PIXEL_RATIO=2

	# HiDPI support for GTK applications
	export GDK_SCALE=2

	# HiDPI support for Java 9+ applications
	export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dsun.java2d.uiScale=2"
fi

# Erlang library path
export ERL_LIBS=/opt/proper/

# cabal
export PATH=$PATH:~/.cabal/bin

# stack auto-completion
if command -v stack > /dev/null; then
	eval "$(stack --bash-completion-script stack)"
fi

# pipenv auto-completion
if command -v pipenv > /dev/null; then
	eval "$(pipenv --completion)"
fi

# history timestamp format
export HISTTIMEFORMAT="%d/%m/%y %T "

# make flags
export MAKEFLAGS="-j $((`nproc` + 0))"
export CFLAGS="${CFLAGS} -fdiagnostics-color=always"
export CXXFLAGS="${CXXFLAGS} -fdiagnostics-color=always"

# ssh helper
if command -v ksshaskpass > /dev/null; then
	export SSH_ASKPASS=/usr/bin/ksshaskpass
fi

# QQC2 style
# export QT_QUICK_CONTROLS_STYLE=Desktop

# ccache
export PATH=/usr/lib/ccache/bin/:$PATH

# command to show images in SimpleITK
# %f is the filename, Display is from MINC toolkit v2
export SITK_SHOW_COMMAND="Display %f"

# npm global packages path
export PATH=~/.npm-global/bin:$PATH

# ssh keys to be added to agent
SSH_KEYS_TO_ADD+=(~/.ssh/github)
export SSH_KEYS_TO_ADD

# start ssh-agent
if [[ ! -o login ]] && [[ -z "${SSH_SESSION_DETECTED:-}" ]] && command -v ssh-agent > /dev/null; then
	if ! pgrep -u "$USER" ssh-agent &> /dev/null; then
		ssh-agent > ~/.ssh-agent-thing
		eval "$(<~/.ssh-agent-thing)" &> /dev/null
		for key in $SSH_KEYS_TO_ADD; do
			ssh-add "${key}" < /dev/null &> /dev/null
		done
	fi
	if [[ "$SSH_AGENT_PID" == "" ]]; then
		eval "$(<~/.ssh-agent-thing)" &> /dev/null
	fi
fi

# matlab
export PATH=$PATH:~/Cryptbox/Configs/matlab-config/bin

# ruby
if [[ -d ~/.gem/ruby ]]; then
	export PATH=$PATH:"$(find ~/.gem/ruby -maxdepth 1 -type d | sort | tail -1)/bin"
	export GEM_HOME=~/.gem
fi

# Julia Pkg server
export JULIA_PKG_SERVER=pkg.julialang.org

# TERM for tmux
if [[ -n "${TMUX_DETECTED}" ]]; then
    export TERM=screen-256color
fi

# TTY for gpg on WSL
if [[ -n "${WSL_DETECTED}" ]]; then
    export GPG_TTY=$(tty)
fi
