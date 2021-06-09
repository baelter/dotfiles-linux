#!/bin/bash

# don't put duplicate lines or lines starting with space in the  history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

unsetopt correct_all
setopt correct

# Go
# export GOPATH=$HOME/84codes/go
# export PATH=$PATH:$GOPATH/bin
# ulimit -n 65536

# Ruby
eval "$(rbenv init -)"
export RBENV_ROOT=$HOME/.rbenv

# Git
gpp() {
  git push origin && git push heroku
}
gppl() {
  gpp && heroku logs -t
}

# terminal
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}

# Locale
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# User bin
export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/84codes/tools/bin

# Work
ptl() {
  open https://papertrailapp.com/systems/$(basename $PWD)/events
}
hkpsql() {
  psql $(URL=$(heroku config:get ELEPHANTSQL_URL); if [ -z $URL ]; then heroku config:get DATABASE_URL; else echo $URL; fi)
}
devpsql() {
  psql $(grep '\(ELEPHANTSQL_URL\|DATABASE_URL\)' .env | awk -F= '{print $2}' | sed "s/'//g" | head -n1)
}
testport4() {
  nc -4vz $*
}
testport6() {
  nc -6vz $*
}
testssl4() {
  openssl s_client -showcerts -4 -connect $* </dev/null
}
testssl6() {
  openssl s_client -showcerts -6 -connect $* </dev/null
}

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
