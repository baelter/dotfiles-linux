# Enable alias expansion in non-interactive shells
shopt -s expand_aliases

shopt -s histappend

# Save to history file immediately BEFORE executing the command
PS0="${PS0}\$(history -a)"

# Add working dir to window title
PROMPT_COMMAND+=('printf "\e]2;%s\a" "$(dirs)"')

# Add your own exports, aliases, and functions here.
# These will be available in both interactive and non-interactive shells

# Load bash completions from ~/.local/share/bash-completion/completions
if [ -d "$HOME/.local/share/bash-completion/completions" ]; then
  for completion in "$HOME/.local/share/bash-completion/completions"/*; do
    [ -r "$completion" ] && . "$completion"
  done
fi

export PATH=$HOME/Work/84codes/tools/bin:$PATH

# Pipe to clipboard
alias xclip="xclip -selection c"

alias la='ls -lah'
alias vi=nvim

# Does not support certificates :(
# export SSH_AUTH_SOCK=~/.1password/agent.sock
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

alias gst='git status'
alias gc='git commit -v'
alias gca='gc -a'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gco='git checkout'
alias gcm='git checkout main'
alias ggpur='git pull --rebase'

alias trash='trash-put'

eval "$(git-wt --init bash)"

alias wt='git wt'
alias claude-yolo='claude --dangerously-skip-permissions'
alias cy='claude-yolo'

export PATH=$HOME/.local/bin/:$PATH
alias sparoid=$HOME/.local/bin/sparoid # to win over mise path manipulation

. "$HOME/.local/share/../bin/env"
#source /home/anders/.config/op/plugins.sh

if [[ -z "${CLAUDECODE}" ]]; then
  source /home/anders/.config/op/plugins.sh
fi

# If not running interactively, don't do anything further
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Infinite history, deduplicated, saved after every command
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignorespace:erasedups

# Omarchy overrides our preference
alias gcm='git checkout main'
alias ga='git add'
alias gd='git diff'

# Git completions for aliases
source /usr/share/bash-completion/completions/git
__git_complete gst _git_status
__git_complete gc _git_commit
__git_complete ga _git_add
__git_complete gd _git_diff
__git_complete gp _git_push
__git_complete gpf _git_push
__git_complete gl _git_pull
__git_complete gco _git_checkout
__git_complete gcm _git_checkout
__git_complete ggpur _git_pull
