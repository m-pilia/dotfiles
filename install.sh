#!/usr/bin/env bash

set -euo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
force=
if [ "${1:-}" == "--force" ]; then
	force=f
fi

for file in dotfiles/**; do
	dotfile=$(basename "$file")
	echo "symlink ~/.$dotfile"
	ln -s$force "$dir/dotfiles/$dotfile" "$HOME/.$dotfile"
done

for folder in 'local' 'config'; do
	find "$folder" -type d -printf "mkdir ~/.%p\n" -exec mkdir -p "$HOME/.{}" \;
	find "$folder" -type f -printf "symlink ~/.%p\n" -exec ln -s$force "$dir/{}" "$HOME/.{}" \;
done
