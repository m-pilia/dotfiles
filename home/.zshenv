# Sourced by every zsh, including scripts and non-interactive ssh sessions:
# it must not print to stdout nor read from stdin

typeset -U PATH path

# Shell config root folder
export SHELL_CONFIG_ROOT=${${(%):-%x}:A:h:h}

# Detect SSH session
export SSH_SESSION_DETECTED=
if [[ -n "${SSH_CLIENT:-}" ]] || [[ -n "${SSH_TTY:-}" ]]; then
    export SSH_SESSION_DETECTED=1
fi

# Detect Windows Subsystem for Linux
export WSL_DETECTED=
if [[ -r /proc/sys/kernel/osrelease ]] && [[ "$(</proc/sys/kernel/osrelease)" == *[Mm]icrosoft* ]]; then
    export WSL_DETECTED=1
fi

# Detect tmux
export TMUX_DETECTED=
if [[ -n "${TMUX:-}" ]]; then
    export TMUX_DETECTED=1
fi

# Drop-in binary path
if [[ -d "${SHELL_CONFIG_ROOT}/third_party/_bin" ]]; then
    export PATH=${PATH}:${SHELL_CONFIG_ROOT}/third_party/_bin
fi

# Shared config among different machines
source ~/.local/share/shell_config/variables.sh
source ~/.local/share/shell_config/functions.sh

if [[ -n "${WSL_DETECTED}" ]] && ! command -v cmd.exe > /dev/null; then
    append_windows_path
fi

if [[ -r ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
