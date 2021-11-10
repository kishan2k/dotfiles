#/usr/local/bin/zsh

alias zshreload="source ~/.zshrc"

# Shortcuts
alias c="clear"
alias e="exit"

# Tools
alias cm="chezmoi"
alias pip="pip3"

# Directories
alias library="cd $HOME/Library"
alias dev="cd $HOME/Code"
alias devp="cd $HOME/Code/Personal"

alias dots="cd ~/.dots"

# Git
alias amend="git add . && git commit -a --amend --no-edit"
alias force="git push --force-with-lease origin"
alias nuke="git clean -df && git reset --hard"
alias resolve="git add . && git commit --no-edit"

alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"
