source "${SHELL_CONFIG_ROOT}/home/.local/share/shell_config/spaceship_tmux.zsh"

SPACESHIP_PROMPT_ORDER=(
    time
    user
    host
    dir
    vi_mode
    tmux
    git
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
    pyenv
    dotnet
    ember
    kubecontext
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

