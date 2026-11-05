#
# ~/.bash_profile
#

export FLYCTL_INSTALL="/home/anders/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc

. "$HOME/.local/share/../bin/env"

clipfile() {
  local f=${1:?usage: clipfile <file>}
  wl-copy --type "$(file -b --mime-type -- "$f")" <"$f"
}
