#!/usr/bin/env bash
# shellcheck disable=2164,2155

alias ls='ls --color=auto'
alias ll='ls -l'

alias grep='grep --color=auto'

# exec emacs in a 256 color terminal
alias emacs='env TERM=xterm-256color emacs -nw'

# readline support
alias ocaml='rlwrap ocaml'
alias poly='rlwrap poly'

alias pypi2pkgbuild='PKGEXT=.pkg.tar pypi2pkgbuild.py -g cython -b /tmp/pypi2pkgbuild/ -f'

alias rgfzf='rg --no-line-number --no-heading . | fzf --delimiter=: --nth=2..'

alias julia='julia -pauto'

alias drop_last_command="sed -i '$ d' \"\${HISTFILE}\" && sed -i '$ d' \"\${HISTFILE}\""

if [[ -n "${WSL_DETECTED}" ]]; then
    alias wslshutdown='history -a && cmd.exe /C wsl --shutdown'
    alias wslterminate='history -a && cmd.exe /C wsl --terminate "${WSL_DISTRO_NAME}"'

    alias wslcopy='clip.exe'
    alias wslpaste='powershell.exe -command "Get-Clipboard"'
fi

alias external_monitor_off='xrandr --output DP-1 --off'

alias massif='valgrind --tool=massif'
