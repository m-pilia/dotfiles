local SHELL_CONFIG_MODULES="${SHELL_CONFIG_ROOT}"/third_party/modules

# Key bindings
source ~/.local/share/shell_config/zsh_keybindings.zsh

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

source ~/.local/share/shell_config/interactive.sh

# Show completion menu when the number of options is at least 2
zstyle ':completion:*' menu select=2

# Enable command autocorrection
setopt correct

source ~/.local/share/shell_config/aliases.sh

# Autojump
if [ -f /etc/profile.d/autojump.sh ]; then
    source /etc/profile.d/autojump.sh
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

    eval "$(starship init zsh)"
    source "${SHELL_CONFIG_MODULES}"/zsh-autosuggestions/zsh-autosuggestions.zsh
    source "${SHELL_CONFIG_MODULES}"/alias-tips/alias-tips.plugin.zsh

    source ~/.local/share/shell_config/fzf_config.zsh

    # zsh-syntax-highlighting (must be the last plugin sourced)
    source "${SHELL_CONFIG_MODULES}"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    if [[ -n "${WSL_DETECTED}" ]] && [[ -z "${SSH_SESSION_DETECTED}" ]]; then
        # Notify Windows Terminal of the current path
        # https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
        _keep_current_path() {
            printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
        }
        precmd_functions+=(_keep_current_path)
    fi
fi

if [[ -r ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
