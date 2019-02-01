export PROMPT="[%n@%M %~] %% "

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

# compsys initialization
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# key bindings
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

# shared config among different machines

. ~/.shell_config/sh_variables.sh
. ~/.shell_config/sh_aliases.sh

# Enable command autocorrection
setopt correct

# vi mode command line editing
#bindkey -v

# spaceship-prompt
. /usr/lib/spaceship-prompt/spaceship.zsh
SPACESHIP_CHAR_SYMBOL='➜ '
SPACESHIP_CHAR_SYMBOL_ROOT='# '
SPACESHIP_USER_SHOW=needed
SPACESHIP_HOST_SHOW=needed
SPACESHIP_DIR_TRUNC_REPO=true
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

# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'
. /usr/share/fzf/key-bindings.zsh
. /usr/share/fzf/completion.zsh

# zsh-syntax-highlighting (must be the last plugin sourced)
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
