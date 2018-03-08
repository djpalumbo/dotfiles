#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

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

# User settings
export EDITOR=/bin/nvim
export BROWSER=/bin/chromium
export ANDROID_HOME=/opt/android-sdk
alias vim='nvim'
alias emulator="/opt/android-sdk/emulator/emulator"
alias cookie="fortune -s | cowsay -f tux | lolcat"

