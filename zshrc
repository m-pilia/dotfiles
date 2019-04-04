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

# Custom completions
fpath=(~/.shell_config/completions $fpath)

# Completion system initialization
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# Enable command autocorrection
setopt correct

# Key bindings
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Shared config among different machines

. ~/.shell_config/variables.sh
. ~/.shell_config/aliases.sh

# spaceship-prompt
. /usr/lib/spaceship-prompt/spaceship.zsh
SPACESHIP_PROMPT_ORDER[3]=host
SPACESHIP_PROMPT_ORDER[4]=dir

# zsh-autosuggestions
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept

# Alias tips
. /usr/share/zsh/plugins/alias-tips/alias-tips.plugin.zsh

# Autojump
. /etc/profile.d/autojump.zsh

# Thefuck
eval "$(thefuck --alias)"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh
. ~/.shell_config/fzf_widgets.zsh

bindkey '^Y' fzf-command-widget

# zsh-syntax-highlighting (must be the last plugin sourced)
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
