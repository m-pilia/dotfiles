# shellcheck disable=2155,2006

# custom scripts
export PATH=~/.shell_config/bin:$PATH

# local binaries
export PATH=~/.local/bin:$PATH

# personal scripts
export PATH=$PATH:~/Cryptbox/SW/bin/

# HiDPI support for QT applications (must be an integer)
#export QT_DEVICE_PIXEL_RATIO=2

# HiDPI support for GTK applications
export GDK_SCALE=2

# HiDPI support for java 9+ applications
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dsun.java2d.uiScale=2"

# Erlang library path
export ERL_LIBS=/opt/proper/

# cabal
export PATH=$PATH:~/.cabal/bin

# stack auto-completion
eval "$(stack --bash-completion-script stack)"

# visual editor
export VISUAL="vim"

# history timestamp format
export HISTTIMEFORMAT="%d/%m/%y %T "

# make flags
export MAKEFLAGS="-j $((`nproc` + 0))"

# ssh helper
export SSH_ASKPASS=/usr/bin/ksshaskpass

# QQC2 style
# export QT_QUICK_CONTROLS_STYLE=Desktop

# ccache
export PATH=/usr/lib/ccache/bin/:$PATH

# bash/zsh history size
HISTSIZE=10000

# command to show images in SimpleITK
# %f is the filename, Display is from MINC toolkit v2
export SITK_SHOW_COMMAND="Display %f"

# npm global packages path
export PATH=~/.npm-global/bin:$PATH

# start ssh-agent
if ! pgrep -u "$USER" ssh-agent &> /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
    eval "$(<~/.ssh-agent-thing)" &> /dev/null
    ssh-add ~/.ssh/github < /dev/null &> /dev/null
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" &> /dev/null
fi

# matlab
export PATH=$PATH:~/Cryptbox/Configs/matlab-config/bin

# ruby
export PATH=$PATH:"$(find ~/.gem/ruby -maxdepth 1 -type d | sort | tail -1)/bin"
export GEM_HOME=~/.gem
