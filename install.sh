#!/usr/bin/env bash

set -euo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
force=
drop_in=

# Parse arguments
while [[ "$#" -gt 0 ]]; do case $1 in
	-f|--force) force=f;;
	-d|--drop-in) drop_in=1;;
	*) echo "Unknown parameter: $1"; exit 1;;
esac; shift; done

cd "$dir"

for file in dotfiles/**; do
	dotfile=$(basename "$file")
	echo "symlink ~/.$dotfile"
	ln -s$force "$dir/dotfiles/$dotfile" "$HOME/.$dotfile"
done

for folder in 'local' 'config'; do
	find "$folder" -type d -printf "mkdir ~/.%p\n" -exec mkdir -p "$HOME/.{}" \;
	find "$folder" -type f -printf "symlink ~/.%p\n" -exec ln -s$force "$dir/{}" "$HOME/.{}" \;
done

if [ $drop_in ]; then
	bash install_third_party.sh
fi
