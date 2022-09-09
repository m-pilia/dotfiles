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

_fzf_complete_git() {
    # Command line being completed
    local input_args
    input_args="$@"

    # Check if the command line matches a given pattern
    local matches_pattern() {
        grep -Ee "$1" <<< "$input_args" &>/dev/null
    }

    # List of completion items
    local completion_items
    completion_items=

    # Arguments to FZF
    local fzf_args
    fzf_args=(
        --reverse
        --multi
        --ansi
        --height '80%'
        --preview-window 'right:70%'
    )

    # List branches sorted by most recent committer date
    local list_branches() {
        git branch -vv --sort=-committerdate --color=always "$@" | sed 's,^..,,'
    }

    # Completed commands
    if matches_pattern '\s*git (co|checkout).*' ; then
        completion_items=$(list_branches)
        fzf_args+=(
            --preview 'git log --oneline --graph --date=short --color=always --format=twoliner $(cut -d" " -f1 <<< {})'
        )
    elif matches_pattern '\s*git (add).*' ; then
        completion_items=$(
            git status --porcelain \
            | awk -v r="$(git rev-parse --show-toplevel)" '{print r "/" substr($0, 4)}' \
            | tr '\n' '\0' \
            | xargs -0 -n1 realpath --relative-to="$(pwd)"
        )
        fzf_args+=(
            --preview '
                if git ls-files --error-unmatch {} &>/dev/null ; then
                    git diff --color=always -- {}
                else
                    git diff --no-index --color=always -- /dev/null {}
                fi'
        )
    fi

    # Invoke completion function (fallback to buit-in zsh completion)
    if [ -n $completion_items ]; then
        _fzf_complete $fzf_args -- "$@" < <(
            echo $completion_items
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
