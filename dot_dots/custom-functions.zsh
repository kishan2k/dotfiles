#/usr/local/bin/zsh

# switch to cr-dev
function cr-dev() {
	eval $( $(which assume-role) cr-dev);
}

# switch to cr-staging
function cr-staging() {
	eval $( $(which assume-role) cr-staging);
}

# switch to cr-prod
function cr-prod() {
	eval $( $(which assume-role) cr-prod);
}

function vpy() {
	eval $( pyenv init - )
	eval $( pyenv virtualenv-init - )
	pyenv virtualenv $2 pyenv-$1 && source activate pyenv-$1 || source activate pyenv-$1
}

function vpy-off() {
	source deactivate pyenv-$1
}



function f(){
	_evalcache thefuck --alias
	fuck -r
}