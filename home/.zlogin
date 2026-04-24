# Start tmux in WSL login shell
if [[ -n "${WSL_DETECTED}" ]] &&
    [[ -z "${TMUX_DETECTED}" ]] &&
    [[ -n "${RUN_ZSH_IN_TMUX:-}" ]] &&
    command -v tmux &> /dev/null; then
    exec tmux && exit
fi
