# Start tmux in WSL login shell
if [[ -n "${WSL_DETECTED}" ]] && [[ -z "${TMUX_DETECTED}" ]] && command -v tmux &> /dev/null; then
    exec tmux && exit
fi
