#!/usr/bin/env bash

cd ~/.dots

set -e



echo ''

info() {
  printf "  [ \033[00;34m..\033[0m ] %s" "$1"
}

user() {
  printf "\r  [ \033[0;33m?\033[0m ] %s " "$1"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit
}



########

check_brew() {
info 'Setting up your Mac...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


check_brew


echo ''
echo ''