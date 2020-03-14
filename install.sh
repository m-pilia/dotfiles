#!/usr/bin/env bash
# shellcheck disable=2156

set -euo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dry_run=
force=
third_party=

# Parse arguments
while [[ "$#" -gt 0 ]]; do case $1 in
	-d|--dry-run) dry_run=1;;
	-f|--force) force=f;;
	-t|--third-party) third_party=1;;
	*) echo "Unknown parameter: $1"; exit 1;;
esac; shift; done

cd "$dir/home"

# Create folders
find . \
	-mindepth 1 \
	-type d \
	-printf "mkdir -p \"$HOME/%P\"\n" \
	-exec bash -c "[ $dry_run ] || mkdir -p \"$HOME/{}\"" \;

# Symlink files
find . \
	-mindepth 1 \
	-type f \
	-printf "ln -s$force \"$dir/home/%P\" \"$HOME/%P\"\n" \
	-exec bash -c "[ $dry_run ] || ln -s$force \"$dir/home/{}\" \"$HOME/{}\"" \;

# Fetch third party dependencies
if [ $third_party ]; then
	bash "$dir/install_third_party.sh"
fi
