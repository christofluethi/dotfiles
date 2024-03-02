# Where the magic happens.
export DOTFILES=~/.dotfiles

# Add binaries into the path
PATH=$DOTFILES/bin:$PATH
export PATH

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

# functionallity for the 'sm' command, that let's one switch
# the user but keeping it's own environment
export INIT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"	# dir this script is in
export HOME_DIR=$(eval echo ~$(id -un))	# home dir of current user

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2500

# make sure to use right history file
HISTFILE=$HOME_DIR/.bash_history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Load other user's rc and profile file
SMRC=$(readlink -f $HOME_DIR/.bashrc)
DMRC=$(readlink -f "${BASH_SOURCE[0]}")
if [ $DMRC != $SMRC ]; then
  SMPF=$HOME_DIR/.profile
  SMBP=$HOME_DIR/.bash_profile
  [ -f $SMPF ] && . $SMPF
  [ -f $SMRC ] && . $SMRC
  [ -f $SMBP ] && . $SMBP
fi
alias sm="HOME=$INIT_DIR su -m"

# use my tmux.conf if it exists
if [ -r $INIT_DIR/.tmux.conf ]; then
  alias tmux="HOME=$INIT_DIR tmux -f $INIT_DIR/.tmux.conf"
fi

# very private bash definitions
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

src

unset INIT_DIR
export HOME=$HOME_DIR
cd $HOME_DIR

# Add Jbang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"
