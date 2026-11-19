#!/usr/bin/env bash
# shellcheck disable=2155

if command -v stack > /dev/null; then
	eval "$(stack --bash-completion-script stack)"
fi

if command -v pipenv > /dev/null; then
	eval "$(pipenv --completion)"
fi

# start ssh-agent
if [[ ! -o login || -n "${WSL_DETECTED}" ]] \
        && [[ -z "${SSH_SESSION_DETECTED:-}" ]] \
        && command -v ssh-agent > /dev/null; then
    if ! pgrep -u "$USER" ssh-agent &> /dev/null; then
        ssh-agent > ~/.ssh_agent_state
    fi
    if [[ "$SSH_AGENT_PID" == "" ]]; then
        eval "$(<~/.ssh_agent_state)" &> /dev/null
    fi
    added_ssh_keys=$(ssh-add -l)
    for key in $SSH_KEYS_TO_ADD; do
        if [[ -f "${key}" ]] && ! grep -q "$(ssh-keygen -lf "${key}" | awk '{print $2}')" \
                <<<"${added_ssh_keys}" 2>/dev/null; then
            ssh-add "${key}" < /dev/null
        fi
    done
    unset added_ssh_keys
fi

if [[ -n "${TMUX_DETECTED}" ]]; then
    export TERM=screen-256color
fi

if [[ -n "${WSL_DETECTED}" ]]; then
    export GPG_TTY=$(tty)
fi
