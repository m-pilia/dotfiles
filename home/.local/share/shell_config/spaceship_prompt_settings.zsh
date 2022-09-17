source "${SHELL_CONFIG_ROOT}/home/.local/share/shell_config/spaceship_tmux.zsh"

# Do not show git status in WSL (for performance reasons)
local _SPACESHIP_GIT_STATUS=
if [[ -z "${WSL_DETECTED}" ]] || [[ -n "${SHELL_CONFIG_FORCE_GIT_STATUS}" ]]; then
    _SPACESHIP_GIT_STATUS=git
fi

SPACESHIP_PROMPT_ORDER=(
    time
    user
    host
    dir
    vi_mode
    tmux
    $_SPACESHIP_GIT_STATUS
    hg
    package
    node
    ruby
    elixir
    xcode
    swift
    golang
    php
    rust
    haskell
    julia
    docker
    aws
    venv
    conda
    dotnet
    kubectl
    terraform
    exec_time
    line_sep
    battery
    jobs
    exit_code
    char
    )

SPACESHIP_VI_MODE_INSERT='i'
SPACESHIP_VI_MODE_NORMAL='n'
SPACESHIP_VI_MODE_PREFIX='('
SPACESHIP_VI_MODE_SUFFIX=') '

spaceship_vi_mode_enable

