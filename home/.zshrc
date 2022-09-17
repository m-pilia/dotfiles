# Shell config root folder
export SHELL_CONFIG_ROOT=$(dirname "$(dirname "$(readlink -f ~/.zshrc)")")

local SHELL_CONFIG_MODULES="${SHELL_CONFIG_ROOT}"/third_party/modules

# Detect SSH session
export SSH_SESSION_DETECTED=
if [[ -n "${SSH_CLIENT:-}" ]] || [[ -n "${SSH_TTY:-}" ]]; then
    export SSH_SESSION_DETECTED=1
fi

# Detect Windows Subsystem for Linux
export WSL_DETECTED=
if [[ -n "${IS_WSL:-}" ]] || [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    if uname -a | grep 'microsoft-standard' ; then
        export WSL_DETECTED=2
    else
        export WSL_DETECTED=1
    fi
fi

# Detect tmux
export TMUX_DETECTED=
if [[ -n "${TMUX}" ]]; then
    export TMUX_DETECTED=1
fi

# Prompt format (fallback)
export PROMPT="[%n@%M %~] %% "

# History settings
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Additional completions
fpath=(
    "${SHELL_CONFIG_MODULES}"/zsh-completions/src
    "${SHELL_CONFIG_ROOT}"/third_party/_completions
    ~/.local/share/zsh_functions
    $fpath
)

# Completion system initialization
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Show completion menu when the number of options is at least 2
zstyle ':completion:*' menu select=2

# Enable command autocorrection
setopt correct

# Drop-in binary path
if [ -d "${SHELL_CONFIG_ROOT}/third_party/_bin" ]; then
    export PATH=${PATH}:${SHELL_CONFIG_ROOT}/third_party/_bin
fi

# Shared config among different machines

source ~/.local/share/shell_config/variables.sh
source ~/.local/share/shell_config/aliases.sh

# Autojump
if [ -f /etc/profile.d/autojump.zsh ]; then
    source /etc/profile.d/autojump.zsh
else
    export PATH=$PATH:"${SHELL_CONFIG_ROOT}"/third_party/_share/autojump/bin
    source "${SHELL_CONFIG_ROOT}"/third_party/_share/autojump/share/autojump/autojump.zsh
fi

# Thefuck
if command -v thefuck >/dev/null; then
    eval "$(thefuck --alias)"
fi

# Run fancier stuff only in non-login shells or in ssh shells
if     [[ ! -o login ]] \
    || [[ -n "${SSH_SESSION_DETECTED}" ]] \
    || [[ -n "${WSL_DETECTED}" ]] \
    || [[ -n "${TMUX_DETECTED}" ]] \
    ; then

    source "${SHELL_CONFIG_MODULES}"/spaceship-prompt/spaceship.zsh
    source "${SHELL_CONFIG_MODULES}"/spaceship-vi-mode/spaceship-vi-mode.plugin.zsh
    source "${SHELL_CONFIG_MODULES}"/zsh-autosuggestions/zsh-autosuggestions.zsh
    source "${SHELL_CONFIG_MODULES}"/alias-tips/alias-tips.plugin.zsh

    source ~/.local/share/shell_config/spaceship_prompt_settings.zsh
    source ~/.local/share/shell_config/fzf_config.zsh

    # zsh-syntax-highlighting (must be the last plugin sourced)
    source "${SHELL_CONFIG_MODULES}"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Key bindings
source ~/.local/share/shell_config/zsh_keybindings.zsh
