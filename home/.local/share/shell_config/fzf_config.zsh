export FZF_DEFAULT_COMMAND='fd --type f'

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
else
    source "${SHELL_CONFIG_ROOT}/third_party/fzf/shell/key-bindings.zsh"
    source "${SHELL_CONFIG_ROOT}/third_party/fzf/shell/completion.zsh"
fi

source ~/.local/share/shell_config/fzf_widgets.zsh
