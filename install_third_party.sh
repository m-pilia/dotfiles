#!/usr/bin/env bash

# Install local copy of third party dependencies in user space

set -euo pipefail

fzf_url="https://github.com/junegunn/fzf/releases/download/0.33.0/fzf-0.33.0"
fd_url="https://github.com/sharkdp/fd/releases/download/v8.4.0/fd-v8.4.0-x86_64"
rg_url="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
third_party="$dir/third_party"
bin_dir="$third_party/_bin"
completions_dir="$third_party/_completions"
autojump_dir="$third_party/_share/autojump"

mkdir -p "$autojump_dir" "$bin_dir" "$completions_dir"

tmp_dir="$(mktemp -d -p "${third_party}")"
mkdir -p "${tmp_dir}" # on Windows it may not be created by mktemp

function cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

# install_git <repo> <commit>
function install_git() {
(
	local _dest=
	_dest="$third_party/$(echo "$1" | grep -oP '.*/\K([^/]+)' | sed "s,.git$,,")"
	cd "$third_party" || exit 1
	git clone "$1" "$_dest"
	git --git-dir "$_dest/.git" --work-tree "$_dest" checkout "$2"
)
}

# On git bash, install only binaries
if [ "$(bash "${dir}"/home/.local/bin/get_arch)" == Windows ] ; then
    cd "$tmp_dir"

    curl -LJO "${fzf_url}-windows_amd64.zip"
    unzip fzf-*.zip
    mv fzf.exe "$bin_dir/".
    install_git https://github.com/junegunn/fzf.git 1dd256a

    curl -LJO "${fd_url}-pc-windows-gnu.zip"
    unzip fd-*.zip
    mv fd.exe "$bin_dir/".

    curl -LJO "${rg_url}-pc-windows-gnu.zip"
    unzip ripgrep-*.zip
    mv ripgrep*/rg.exe "$bin_dir/".

    exit 0
fi


# fzf
cd "$tmp_dir"
curl -LJO "${fzf_url}-linux_amd64.tar.gz"
tar -xf fzf-*.tar.gz
mv fzf "$bin_dir/fzf"

# Autojump
git clone https://github.com/wting/autojump.git "$tmp_dir/autojump"
cd "$tmp_dir/autojump" || exit 1
git checkout 06e082c
python install.py -d "$autojump_dir"

# Other components
install_git https://github.com/junegunn/fzf.git 9cb7a36

# fd
cd "$tmp_dir"
curl -LJO "${fd_url}-unknown-linux-musl.tar.gz"
tar -xf fd-*.tar.gz
mv fd*/fd "$bin_dir/fd"
mv fd*/autocomplete/_fd "${completions_dir}"/_fd

# ripgrep
cd "$tmp_dir"
curl -LJO "${rg_url}-unknown-linux-musl.tar.gz"
tar -xf ripgrep-*.tar.gz
mv ripgrep*/rg "$bin_dir/rg"
mv ripgrep*/complete/_rg "${completions_dir}"/_rg
