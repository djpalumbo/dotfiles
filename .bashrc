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

# Import/refresh colorscheme from 'wal' (termite)
if [ $TERM = 'xterm-termite' ]
then
  (cat ~/.cache/wal/sequences &)
fi

# Run Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  PYTHON_SITE=$(python -c "import site; print(site.getsitepackages())" | sed "s/[][']//g")
  source $PYTHON_SITE/powerline/bindings/bash/powerline.sh
fi

# Use vi mode
set -o vi

# fzf keybindings and completions
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# User settings
export EDITOR=/bin/nvim
export BROWSER=/bin/firefox
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g "" -u'
export FZF_DEFAULT_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind=tab:up,btab:down"
alias vim='nvim'
alias cookie='fortune -s | cowsay -f tux | lolcat'
alias syu='curl -s https://www.archlinux.org/feeds/news/ | xmllint --xpath //item/title\ \|\ //item/pubDate /dev/stdin | sed -r -e "s:<title>([^<]*?)</title><pubDate>([^<]*?)</pubDate>:\2\t\1\n:g" && yay -Syu'

