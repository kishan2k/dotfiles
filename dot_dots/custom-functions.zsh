#/usr/local/bin/zsh

# switch to cr-dev
function cr-dev() {
	_evalcache assume-role cr-dev
}

# switch to cr-staging
function cr-staging() {
	_evalcache assume-role cr-staging
}

# switch to cr-prod
function cr-prod() {
	_evalcache assume-role cr-prod
}

function vpy() {
	_evalcache pyenv init -
	_evalcache pyenv virtualenv-init -
	pyenv virtualenv $2 pyenv-$1 && source activate pyenv-$1 || source activate pyenv-$1
}

function vpy-off() {
	source deactivate pyenv-$1
}



function f(){
	_evalcache thefuck --alias
	fuck -r
}