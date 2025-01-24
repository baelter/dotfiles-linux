#!/bin/bash

# don't put duplicate lines or lines starting with space in the  history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Go
export PATH=$PATH:/usr/local/go/bin
# export GOPATH=$HOME/84codes/go
# export PATH=$PATH:$GOPATH/bin
# ulimit -n 65536

# Ruby
export PATH="$PATH:$HOME/.rbenv/bin"
export PATH="$PATH:$HOME/.rbenv/plugins/ruby-build/bin"
eval "$(rbenv init -)"
export RBENV_ROOT=$HOME/.rbenv
#export PATH="/usr/local/bin/rubocop-daemon-wrapper:$PATH"
alias rake='noglob rake'

# User bin
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/84codes/tools/bin:$PATH


# Git
gpp() {
  git push origin && git push heroku
}
gppl() {
  gpp && heroku logs -t
}
gho() {
  gh repo view --web
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

# Work
ptl() {
  open https://papertrailapp.com/systems/$(basename $PWD)/events
}
hkpsql() {
  psql $(URL=$(heroku config:get ELEPHANTSQL_URL); if [ -z $URL ]; then heroku config:get DATABASE_URL; else echo $URL; fi) "$@";
}
devpsql() {
  psql $(grep '^\(ELEPHANTSQL_URL\|DATABASE_URL\)' .env | awk -F= '{print $2}' | sed "s/'//g" | head -n1) "$@";
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
kill-rubies() {
  pkill -f 'ruby:'; pkill -f puma
}
csvgrep() { head -n 1 "$1" > "$3"; tail -n +2 "$1" | grep "$2" >> "$3"; }

# Python
if command -v pyenv &> /dev/null
then
  eval "$(pyenv virtualenv-init -)"
  export PATH="$PATH:$HOME/.pyenv/bin"
fi
export PATH="$PATH:$HOME/.local/bin"

# Node
NPM_PACKAGES="${HOME}/.npm-packages"

export PATH="$PATH:$NPM_PACKAGES/bin"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

export SIGN_SSH_KEY_RESET_AGENT=true

export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/anders/.local/share/flatpak/exports/share"
. "$HOME/.cargo/env"

export OPENCV_LOG_LEVEL=OFF
export GST_DEBUG=0

# Pipe to clipboard
alias xclip="xclip -selection c"

# Custom lsgit function
function lsgit() {
  # Define colors for output
  local DIR_COLOR="\033[1;34m"      # Blue for directory names
  local BRANCH_COLOR="\033[0;31m"   # Red for branch names
  local CLEAN_STATUS=""             # No symbol for clean repositories
  local DIRTY_STATUS=" \033[0;33m✗" # Yellow for the dirty symbol
  local RESET_COLOR="\033[0m"       # Reset color

  # Iterate through each directory
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      # Get the branch name and status directly using `git -C` to avoid `cd`
      local branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
      local git_status=""

      # Check for uncommitted or untracked changes
      if [[ -n $(git -C "$dir" status --porcelain) ]]; then
        git_status="$DIRTY_STATUS"  # Dirty repository
      fi

      # Print the directory name with Git branch and status
      echo -e "${DIR_COLOR}${dir}${RESET_COLOR} git:(${BRANCH_COLOR}${branch}${RESET_COLOR})${git_status}"
    else
      # Not a Git repository, mimic normal `ls` behavior
      echo "$dir"
    fi
  done
}

# Pretty less
alias less=~/.bin/pretty-less.sh
