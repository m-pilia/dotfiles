#!/usr/bin/env bash

# Install local copy of third party dependencies in user space

set -euo pipefail

fzf_url="https://github.com/junegunn/fzf-bin/releases/download/0.21.0/fzf-0.21.0"
fd_url="https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64"
rg_url="https://github.com/BurntSushi/ripgrep/releases/download/12.0.1/ripgrep-12.0.1-x86_64"

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
third_party="$dir/third_party"
bin_dir="$dir/third_party/_bin"
autojump_dir="$third_party/_share/autojump"

mkdir -p "$autojump_dir" "$bin_dir"

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
curl -LJO "${fzf_url}-linux_amd64.tgz"
tar -xf fzf-*.tgz
mv fzf "$bin_dir/fzf"

# Autojump
git clone https://github.com/wting/autojump.git "$tmp_dir/autojump"
cd "$tmp_dir/autojump" || exit 1
git checkout 06e082c
python install.py -d "$autojump_dir"

# Other components
install_git https://github.com/djui/alias-tips.git 29bf28c
install_git https://github.com/junegunn/fzf.git 9cb7a36
install_git https://github.com/denysdovhan/spaceship-prompt.git c047e3f
install_git https://github.com/zsh-users/zsh-autosuggestions.git d43c309
install_git https://github.com/zsh-users/zsh-completions.git 8def5f1
install_git https://github.com/zsh-users/zsh-syntax-highlighting.git e7d3fbc

# fd
cd "$tmp_dir"
curl -LJO "${fd_url}-unknown-linux-musl.tar.gz"
tar -xf fd-*.tar.gz
mv fd*/fd "$bin_dir/fd"
mv fd*/autocomplete/_fd "${third_party}"/zsh-completions/src/_fd

# ripgrep
cd "$tmp_dir"
curl -LJO "${rg_url}-unknown-linux-musl.tar.gz"
tar -xf ripgrep-*.tar.gz
mv ripgrep*/rg "$bin_dir/rg"
mv ripgrep*/complete/_rg "${third_party}"/zsh-completions/src/_rg
