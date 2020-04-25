# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_TMUX_SHOW="${SPACESHIP_TMUX_SHOW=true}"
SPACESHIP_TMUX_PREFIX="${SPACESHIP_TMUX_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_TMUX_SUFFIX="${SPACESHIP_TMUX_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_TMUX_SYMBOL="${SPACESHIP_TMUX_SYMBOL="(tmux)"}"
SPACESHIP_TMUX_COLOR="${SPACESHIP_TMUX_COLOR="green"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show tmux
spaceship_tmux() {
  [[ $SPACESHIP_TMUX_SHOW == false ]] && return

  # If tmux is detected
  [[ -n "${TMUX}" ]] || return

  spaceship::exists tmux || return


  spaceship::section \
    "$SPACESHIP_TMUX_COLOR" \
    "$SPACESHIP_TMUX_PREFIX" \
    "${SPACESHIP_TMUX_SYMBOL}" \
    "$SPACESHIP_TMUX_SUFFIX"
}
