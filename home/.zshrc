# Shell config root folder
export SHELL_CONFIG_ROOT=$(dirname "$(dirname "$(readlink -f ~/.zshrc)")")

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

# Fallback for zsh-completions
if [ ! -f /usr/share/zsh/site-functions/_afew ]; then
    fpath=("${SHELL_CONFIG_ROOT}/third_party/zsh-completions/src" $fpath)
fi

# Custom completions
fpath=(~/.local/share/zsh_functions $fpath)

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
    export PATH=$PATH:"${SHELL_CONFIG_ROOT}/third_party/_share/autojump/bin"
    source "${SHELL_CONFIG_ROOT}/third_party/_share/autojump/share/autojump/autojump.zsh"
fi

# Thefuck
if command -v thefuck >/dev/null; then
    eval "$(thefuck --alias)"
fi

# Run fancier stuff only in non-login shells or in ssh shells
if [[ ! -o login ]] || [[ -n "${SSH_SESSION_DETECTED}" ]] || [[ -n "${WSL_DETECTED}" ]] || [[ -n "${TMUX_DETECTED}" ]]; then

    # spaceship-prompt
    if [ -f /usr/lib/spaceship-prompt/spaceship.zsh ]; then
        source /usr/lib/spaceship-prompt/spaceship.zsh
    else
        source "${SHELL_CONFIG_ROOT}/third_party/spaceship-prompt/spaceship.zsh"
    fi

    source ~/.local/share/shell_config/spaceship_prompt_settings.zsh

    # zsh-autosuggestions
    if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    else
        source "${SHELL_CONFIG_ROOT}/third_party/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    # Alias tips
    if [ -f /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh ]; then
        source /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh
    else
        source "${SHELL_CONFIG_ROOT}/third_party/alias-tips/alias-tips.plugin.zsh"
    fi

    # fzf
    export FZF_DEFAULT_COMMAND='fd --type f'

    if [ -f /usr/share/fzf/key-bindings.zsh ]; then
        source /usr/share/fzf/key-bindings.zsh
        source /usr/share/fzf/completion.zsh
    else
        source "${SHELL_CONFIG_ROOT}/third_party/fzf/shell/key-bindings.zsh"
        source "${SHELL_CONFIG_ROOT}/third_party/fzf/shell/completion.zsh"
    fi

    source ~/.local/share/shell_config/fzf_widgets.zsh

    # zsh-syntax-highlighting (must be the last plugin sourced)
    if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    else
        source "${SHELL_CONFIG_ROOT}/third_party/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
fi

# Key bindings
source ~/.local/share/shell_config/zsh_keybindings.zsh
