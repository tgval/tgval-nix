export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"


# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/rdv67mff1y8i47bx85mdxw86fjmzq1sf-bash-completion-2.16.0/etc/profile.d/bash_completion.sh"
fi

