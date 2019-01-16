# alias per cd con ls automatico
cdalias () {
	cd $* && ls --color=auto
}

alias ls='ls --color=auto'
alias ll='ls -l'
#alias cd='cdalias' # è definita qui sopra

# exec emacs in a 256 color termina
alias emacs='env TERM=xterm-256color emacs -nw'

# readline support
alias ocaml='rlwrap ocaml'
alias poly='rlwrap poly'

# wmsystemtray
alias wmsystemtray='wmsystemtray --non-wmaker --bgcolor white'

alias pypi2pkgbuild='PKGEXT=.pkg.tar pypi2pkgbuild.py -g cython -b /tmp/pypi2pkgbuild/ -f'

alias rgfzf='rg --no-line-number --no-heading . | fzf --delimiter=: --nth=2..'

alias new_venv='python -m venv .venv && source .venv/bin/activate && pip install -r'
