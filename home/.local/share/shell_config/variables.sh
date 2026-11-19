#!/usr/bin/env bash
# shellcheck disable=2155,2006

# editor
if command -v nvim &> /dev/null ; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export VISUAL=$EDITOR

# local binaries
export PATH=~/.local/bin:$PATH

# personal scripts
export PATH=$PATH:~/Cryptbox/SW/bin/

# Erlang library path
export ERL_LIBS=/opt/proper/

# cabal
export PATH=$PATH:~/.cabal/bin

# history timestamp format
export HISTTIMEFORMAT="%d/%m/%y %T "

# make flags
export MAKEFLAGS="-j $((`nproc` + 0))"
# Nested shells inherit the flags, avoid appending them again
if [[ " ${CFLAGS:-} " != *" -fdiagnostics-color=always "* ]]; then
	export CFLAGS="${CFLAGS:-} -fdiagnostics-color=always"
fi
if [[ " ${CXXFLAGS:-} " != *" -fdiagnostics-color=always "* ]]; then
	export CXXFLAGS="${CXXFLAGS:-} -fdiagnostics-color=always"
fi

# ssh helper
if command -v ksshaskpass > /dev/null; then
	export SSH_ASKPASS=/usr/bin/ksshaskpass
fi

# QQC2 style
# export QT_QUICK_CONTROLS_STYLE=Desktop

# ccache
export PATH=/usr/lib/ccache/bin/:$PATH

# command to show images in SimpleITK
# %f is the filename, Display is from MINC toolkit v2
export SITK_SHOW_COMMAND="Display %f"

# npm global packages path
export PATH=~/.npm-global/bin:$PATH

# ssh keys to be added to agent
SSH_KEYS_TO_ADD+=(~/.ssh/github)
export SSH_KEYS_TO_ADD

# matlab
export PATH=$PATH:~/Cryptbox/Configs/matlab-config/bin

# ruby
if [[ -d ~/.gem/ruby ]]; then
	export PATH=$PATH:"$(find ~/.gem/ruby -maxdepth 1 -type d | sort | tail -1)/bin"
	export GEM_HOME=~/.gem
fi

# Julia Pkg server
export JULIA_PKG_SERVER=pkg.julialang.org

# Rust
export RUST_BACKTRACE=1

# OpenCode
export OPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECT=1

# CUDA
export CUDA_PATH=/opt/cuda
export PATH='/opt/cuda/bin':'/opt/cuda/nsight_compute':'/opt/cuda/nsight_systems/bin':${PATH}
export NVCC_CCBIN='/usr/bin/g++-14'
