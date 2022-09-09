# vi mode
bindkey -v

# Timeout for multi-character key sequences
export KEYTIMEOUT=10

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
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^l' clear-screen
bindkey '^k' kill-line

# Plugin bindings
bindkey '^ ' autosuggest-accept

# Custom bindings
bindkey '^Y' fzf-command-widget

# Vim mode key bindings
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M vicmd "?" history-incremental-pattern-search-backward
bindkey -M vicmd "/" history-incremental-pattern-search-forward
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^r' redo
bindkey -M vicmd '~' vi-swap-case

# Text objects
# From https://tinyurl.com/5cx8fnc3
autoload -Uz select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted
for km in viopp visual; do
    bindkey -M $km -- '-' vi-up-line-or-history
    for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
        bindkey -M $km $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $km $c select-bracketed
    done
done

# Surround
autoload -Uz surround
zle -N add-surround surround
zle -N change-surround surround
zle -N delete-surround surround
bindkey -M vicmd ys add-surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M visual S add-surround

# Yank to clipboard
function vi-yank-to-clipboard {
    zle vi-yank
    if type xclip &> /dev/null ; then
        echo -n "$CUTBUFFER" | xclip -i -selection clipboard
    elif type wl-copy &> /dev/null ; then
        echo -n "$CUTBUFFER" | wl-copy
    elif type win32yank &> /dev/null ; then
        echo -n "$CUTBUFFER" | win32yank -i
    fi
}
zle -N vi-yank-to-clipboard
bindkey -M vicmd 'y' vi-yank-to-clipboard
