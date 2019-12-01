# shellcheck disable=2164,2155

alias ls='ls --color=auto'
alias ll='ls -l'

# exec emacs in a 256 color terminal
alias emacs='env TERM=xterm-256color emacs -nw'

# readline support
alias ocaml='rlwrap ocaml'
alias poly='rlwrap poly'

alias pypi2pkgbuild='PKGEXT=.pkg.tar pypi2pkgbuild.py -g cython -b /tmp/pypi2pkgbuild/ -f'

alias rgfzf='rg --no-line-number --no-heading . | fzf --delimiter=: --nth=2..'

alias julia='julia -pauto'

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
