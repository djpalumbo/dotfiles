#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User settings
export EDITOR=nvim
export BROWSER=chromium
alias vim='nvim'

# Tab-completion
complete -c man which
complete -cf sudo

# Line wrap on window resize
shopt -s checkwinsize

# Run Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

# Import/refresh colorscheme from 'wal' (termite)
if [ $TERM = 'xterm-termite' ]
then
  (cat ~/.cache/wal/sequences &)
fi
