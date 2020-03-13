#!/usr/bin/env bash

# Install local copy of third party dependencies in user space

set -euo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
third_party="$dir/third_party"
bin_dir="$dir/third_party/_bin"
autojump_dir="$third_party/_share/autojump"
tmp="$(mktemp -d)"

function cleanup() {
	rm -rf "$tmp"
}
trap cleanup EXIT

mkdir -p "$autojump_dir" "$bin_dir"

# install_git <repo> <commit>
function install_git() {
	local _dest=
	_dest="$third_party/$(echo "$1" | grep -oP '.*/\K([^/]+)' | sed "s,.git$,,")"
	cd "$third_party" || exit 1
	git clone "$1" "$_dest"
	git --git-dir "$_dest/.git" --work-tree "$_dest" checkout "$2"
}

# fzf
cd "$tmp"
curl -LJO "https://github.com/junegunn/fzf-bin/releases/download/0.21.0/fzf-0.21.0-linux_amd64.tgz"
tar -xf fzf-*.tgz
mv fzf "$bin_dir/fzf"

# fd
cd "$tmp"
curl -LJO "https://github.com/sharkdp/fd/releases/download/v7.4.0/fd-v7.4.0-x86_64-unknown-linux-musl.tar.gz"
tar -xf fd-*.tar.gz
mv fd*/fd "$bin_dir/fd"

# Autojump
git clone https://github.com/wting/autojump.git "$tmp/autojump"
cd "$tmp/autojump" || exit 1
git checkout 06e082c
python install.py -d "$autojump_dir"

# Other components
install_git https://github.com/djui/alias-tips.git 29bf28c
install_git https://github.com/junegunn/fzf.git 1dd256a
install_git https://github.com/denysdovhan/spaceship-prompt.git c047e3f
install_git https://github.com/zsh-users/zsh-autosuggestions.git d43c309
install_git https://github.com/zsh-users/zsh-completions.git 8def5f1
install_git https://github.com/zsh-users/zsh-syntax-highlighting.git e7d3fbc
