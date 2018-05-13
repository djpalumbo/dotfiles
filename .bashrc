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

# fzf keybindings and completions
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# User settings
export EDITOR=/bin/nvim
export BROWSER=/bin/chromium
export ANDROID_HOME=/opt/android-sdk
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
alias vim='nvim'
alias android-emulator="/opt/android-sdk/emulator/emulator"
alias android-monitor="/opt/android-sdk/tools/monitor"
alias cookie="fortune -s | cowsay -f tux | lolcat"
alias trizen="trizen --noedit"
alias syu="curl -s https://www.archlinux.org/feeds/news/ | xmllint --xpath //item/title\ \|\ //item/pubDate /dev/stdin | sed -r -e \"s:<title>([^<]*?)</title><pubDate>([^<]*?)</pubDate>:\2\t\1\n:g\" && trizen -Syu --noedit"

