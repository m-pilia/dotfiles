#!/usr/bin/env zsh

__command_selector() {
    local commands=$(echo "${(k)commands}" | sed 's, ,\n,g' | grep -v '^_')
    setopt localoptions pipefail 2> /dev/null
    echo "$commands" | \
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} \
                          --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" \
            $(__fzfcmd) -m "$@" | \
        while read item; do echo -n "${(q)item} "; done
    local ret=$?
    echo
    return $ret
}

fzf-command-widget() {
  LBUFFER="${LBUFFER}$(__command_selector)"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle -N fzf-command-widget
