#!/usr/bin/env bash
# shellcheck disable=2164,2155

alias ls='ls --color=auto'
alias ll='ls -l'

alias grep='grep --color=auto'

# exec emacs in a 256 color terminal
alias emacs='env TERM=xterm-256color emacs -nw'

# readline support
alias ocaml='rlwrap ocaml'
alias poly='rlwrap poly'

alias pypi2pkgbuild='PKGEXT=.pkg.tar pypi2pkgbuild.py -g cython -b /tmp/pypi2pkgbuild/ -f'

alias rgfzf='rg --no-line-number --no-heading . | fzf --delimiter=: --nth=2..'

alias julia='julia -pauto'

if [[ -n "${WSL_DETECTED}" ]]; then
    alias wslshutdown='history -a && cmd.exe /C wsl --shutdown'
    alias wslterminate='history -a && cmd.exe /C wsl --terminate "${WSL_DISTRO_NAME}"'
fi

function xdocker() {
	docker run \
		-it \
		--rm \
		--user "$(id -u)":"$(id -u)" \
		--userns=host \
		--net=host \
		--ipc=host \
		-e DISPLAY="$DISPLAY" \
		-v /tmp/.X11-unix/:/tmp/.X11-unix:ro \
		-v "${HOME}/.Xauthority:/home/$(whoami)/.Xauthority:ro" \
		-v /etc/passwd:/etc/passwd:ro \
		-v /etc/group:/etc/group:ro \
		"$@"
}

# Create a Python virtual environment in a temporary directory
function tmpvenv() {
	if [ $# -lt 1 ] || [ ! -f "$1" ]; then
		echo "usage: tmpvenv requirements.txt [venv ARGS]"
		return
	fi

	local requirements=$1
	shift
	export TMPVENV_DIR=$(mktemp -d)

	# shellcheck source=/dev/null
	python -m venv "$@" "${TMPVENV_DIR}" && \
	source "${TMPVENV_DIR}"/bin/activate && \
	pip install -r "${requirements}"
}

alias external_monitor_off='xrandr --output DP-1 --off'

function external_monitor_1080p() {
	xrandr --output DP-1 --off
	xrandr --output eDP-1 --scale "0.9999x0.9999" \
	       --output DP-1 --auto --scale 2x2 --right-of eDP-1
}

function find_static_symbol() {
	fd '.*\.a$' -x bash -c "nm --defined-only {} 2>/dev/null | grep \"$1\" && echo {}"
}

function find_dynamic_symbol() {
	scanelf -ls +"$1" | grep "$1"
}

function search_dynamic_symbol() {
	(cd /usr/lib && fd -i ".*${1}.*\.so" -x bash -c "nm --dynamic --with-symbol-versions --defined-only {} 2>/dev/null | rg -i \"$2\" && echo {}")
}

alias massif='valgrind --tool=massif'

function gperftools_heap_profiler() {
	echo "Visualise profiling data with \`pprof --gv heap_profile.xxxx.hprof\`"
	env \
		LD_PRELOAD=/usr/lib/libtcmalloc.so \
		HEAPPROFILE="$(pwd)"/heap_profile.hprof \
		"$@"
}

function gdb_attach() {
	if [ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]; then
		echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
	fi
	local bin=$1
	shift
	gdb -q "$bin" "$(pgrep "$bin")" "$@"
}

function gif_args() {
	if [ $# -ne 3 ]; then
		echo "Usage: gif_args <width> <fps> <speedup>"
		return 1
	fi
	echo -vf "fps=${2:-12},scale=${1:-600}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,setpts=$(echo "scale=2; 1/${3:-1}" | bc)*PTS" -loop 0
}

function compare_dirs() {
    python -c "import filecmp; filecmp.dircmp('${1}', '${2}').report_full_closure()"
}

function rgsed() {(
    set -euo pipefail
    eval "rg '$1' --files-with-matches | xargs sed -Ei 's/$1/$2/g'"
)}
